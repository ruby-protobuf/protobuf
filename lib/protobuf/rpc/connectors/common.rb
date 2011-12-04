module Protobuf
  module Rpc 
    module Connectors
      module Common 
        # For state tracking
        STATES = {
          :pending    => 0,
          :succeeded  => 1,
          :failed     => 2,
          :completed  => 3
        }
 
        def complete
          @state = STATES[:completed]
          @stats.end
          @stats.log_stats
          log_debug '[client-cnxn] Response proceessing complete'
          @success_cb = @failure_cb = nil
          @complete_cb.call(@state) unless @complete_cb.nil?
        rescue
          log_error '[client-cnxn] Complete callback error encountered: %s' % $!.message
          log_error '[client-cnxn] %s' % $!.backtrace.join("\n")
          raise
        end

        def fail(code, message)
          @state = STATES[:failed]
          error.code = code.is_a?(Symbol) ? Protobuf::Socketrpc::ErrorReason.values[code] : code
          error.message = message
          log_debug '[client-cnxn] Server failed request (invoking on_failure): %s' % error.inspect
          @failure_cb.call(error) unless @failure_cb.nil?
        rescue
          log_error '[client-cnxn] Failure callback error encountered: %s' % $!.message
          log_error '[client-cnxn] %s' % $!.backtrace.join("\n")
          raise
        ensure
          complete
        end

        def initialize_stats
          @stats = Protobuf::Rpc::Stat.new(:CLIENT, true)
          @stats.server = [@options[:port], @options[:host]]
          @stats.service = @options[:service].name
          @stats.method = @options[:method]
        end

        def parse_response
          # Close up the connection as we no longer need it
          close_connection
        
          log_debug '[client-cnxn] Parsing response from server (connection closed)'
          @stats.response_size = @buffer.size
        
          # Parse out the raw response
          response_wrapper = Protobuf::Socketrpc::Response.new
          response_wrapper.parse_from_string(@buffer.data)
        
          # Determine success or failure based on parsed data
          if response_wrapper.has_field? :error_reason
            log_debug '[client-cnxn] Error response parsed'
          
            # fail the call if we already know the client is failed
            # (don't try to parse out the response payload)
            fail response_wrapper.error_reason, response_wrapper.error
          else
            log_debug '[client-cnxn] Successful response parsed'
          
            # Ensure client_response is an instance
            response_type = @options[:response_type].new
            parsed = response_type.parse_from_string(response_wrapper.response_proto.to_s)
      
            if parsed.nil? and not response_wrapper.has_field?(:error_reason)
              fail :BAD_RESPONSE_PROTO, 'Unable to parse response from server'
            else
              succeed(parsed)
            end
          end
        end

        # Setup the read buffer for data coming back
        def post_init
          log_debug '[client-cnxn] Post init, new read buffer created'
          @buffer = Protobuf::Rpc::Buffer.new(:read)
        rescue
          fail(:RPC_ERROR, 'Connection error: %s' % $!.message) unless failed?
        end

        # Sends the request to the server, invoked by the connection_completed event
        def _send_request
          request_wrapper = Protobuf::Socketrpc::Request.new
          request_wrapper.service_name = @options[:service].name
          request_wrapper.method_name = @options[:method].to_s
        
          if @options[:request].class == @options[:request_type]
            request_wrapper.request_proto = @options[:request].serialize_to_string
          else
            expected = @options[:request_type].name
            actual = @options[:request].class.name
            fail :INVALID_REQUEST_PROTO, 'Expected request type to be type of %s, got %s instead' % [expected, actual]
          end
        
          log_debug '[client-cnxn] Sending Request: %s' % request_wrapper.inspect
          request_buffer = Protobuf::Rpc::Buffer.new(:write, request_wrapper)
          send_data(request_buffer.write)
          @stats.request_size = request_buffer.size
        end
      
        def succeed(response)
          @state = STATES[:succeeded]
          log_debug '[client-cnxn] Server succeeded request (invoking on_success)'
          @success_cb.call(response) unless @success_cb.nil?
        rescue
          log_error '[client-cnxn] Success callback error encountered: %s' % $!.message
          log_error '[client-cnxn] %s' % $!.backtrace.join("\n")
          fail :RPC_ERROR, 'An exception occurred while calling on_success: %s' % $!.message
        ensure 
          complete
        end

        def verify_options
          # Verify the options that are necessary and merge them in
          [:service, :method, :host, :port].each do |opt|
            fail(:RPC_ERROR, "Invalid client connection configuration. #{opt} must be a defined option.") if @options[opt].nil?
          end
        end

      end
    end
  end
end