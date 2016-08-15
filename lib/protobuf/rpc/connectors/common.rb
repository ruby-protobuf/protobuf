require 'protobuf'

module Protobuf
  module Rpc
    module Connectors
      module Common

        attr_reader :error

        def any_callbacks?
          [@complete_cb, @failure_cb, @success_cb].any?
        end

        def request_caller
          @options[:client_host] || ::Protobuf.client_host
        end

        def complete
          @stats.stop
          logger.info { @stats.to_s }
          logger.debug { sign_message('Response proceessing complete') }
          @complete_cb.call(self) unless @complete_cb.nil?
        rescue => e
          logger.error { sign_message('Complete callback error encountered') }
          log_exception(e)
          raise
        end

        def data_callback(data)
          logger.debug { sign_message('Using data_callback') }
          @used_data_callback = true
          @data = data
        end

        # All failures should be routed through this method.
        #
        # @param [Symbol] code The code we're using (see ::Protobuf::Socketrpc::ErrorReason)
        # @param [String] message The error message
        def failure(code, message)
          @error = ClientError.new
          @error.code = Protobuf::Socketrpc::ErrorReason.fetch(code)
          @error.message = message
          logger.debug { sign_message("Server failed request (invoking on_failure): #{@error.inspect}") }

          @failure_cb.call(@error) unless @failure_cb.nil?
        rescue => e
          logger.error { sign_message("Failure callback error encountered") }
          log_exception(e)
          raise
        ensure
          complete
        end

        def initialize_stats
          @stats = ::Protobuf::Rpc::Stat.new(:CLIENT)
          @stats.server = [@options[:port], @options[:host]]
          @stats.service = @options[:service].name
          @stats.method_name = @options[:method].to_s
        rescue => ex
          log_exception(ex)
          failure(:RPC_ERROR, "Invalid stats configuration. #{ex.message}")
        end

        def log_signature
          @_log_signature ||= "[client-#{self.class}]"
        end

        def parse_response
          # Close up the connection as we no longer need it
          close_connection

          logger.debug { sign_message("Parsing response from server (connection closed)") }

          # Parse out the raw response
          @stats.response_size = @response_data.size unless @response_data.nil?
          response_wrapper = Protobuf::Socketrpc::Response.decode(@response_data)

          # Determine success or failure based on parsed data
          if response_wrapper.field?(:error_reason)
            logger.debug { sign_message("Error response parsed") }

            # fail the call if we already know the client is failed
            # (don't try to parse out the response payload)
            failure(response_wrapper.error_reason, response_wrapper.error)
          else
            logger.debug { sign_message("Successful response parsed") }

            # Ensure client_response is an instance
            parsed = @options[:response_type].decode(response_wrapper.response_proto.to_s)

            if parsed.nil? && !response_wrapper.field?(:error_reason)
              failure(:BAD_RESPONSE_PROTO, 'Unable to parse response from server')
            else
              verify_callbacks
              succeed(parsed)
              return @data if @used_data_callback
            end
          end
        end

        def post_init
          send_data unless error?
        rescue => e
          failure(:RPC_ERROR, "Connection error: #{e.message}")
        end

        def request_bytes
          validate_request_type!
          fields = { :service_name => @options[:service].name,
                     :method_name => @options[:method].to_s,
                     :request_proto => @options[:request],
                     :caller => request_caller }

          return ::Protobuf::Socketrpc::Request.encode(fields)
        rescue => e
          failure(:INVALID_REQUEST_PROTO, "Could not set request proto: #{e.message}")
        end

        def setup_connection
          initialize_stats
          @request_data = request_bytes
          @stats.request_size = @request_data.size
        end

        def succeed(response)
          logger.debug { sign_message("Server succeeded request (invoking on_success)") }
          @success_cb.call(response) unless @success_cb.nil?
        rescue => e
          logger.error { sign_message("Success callback error encountered") }
          log_exception(e)
          failure(:RPC_ERROR, "An exception occurred while calling on_success: #{e.message}")
        ensure
          complete
        end

        def timeout
          if options[:timeout]
            options[:timeout]
          else
            300 # seconds
          end
        end

        # Wrap the given block in a timeout of the configured number of seconds.
        #
        def timeout_wrap(&block)
          ::Timeout.timeout(timeout, &block)
        rescue ::Timeout::Error
          failure(:RPC_FAILED, "The server took longer than #{timeout} seconds to respond")
        end

        def validate_request_type!
          unless @options[:request].class == @options[:request_type]
            expected = @options[:request_type].name
            actual = @options[:request].class.name
            failure(:INVALID_REQUEST_PROTO, "Expected request type to be type of #{expected}, got #{actual} instead")
          end
        end

        def verify_callbacks
          unless any_callbacks?
            logger.debug { sign_message("No callbacks set, using data_callback") }
            @success_cb = @failure_cb = method(:data_callback)
          end
        end

        def verify_options!
          # Verify the options that are necessary and merge them in
          [:service, :method, :host, :port].each do |opt|
            failure(:RPC_ERROR, "Invalid client connection configuration. #{opt} must be a defined option.") if @options[opt].nil?
          end
        end
      end
    end
  end
end
