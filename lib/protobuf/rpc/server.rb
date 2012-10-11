require 'protobuf/logger'
require 'protobuf/rpc/rpc.pb'
require 'protobuf/rpc/buffer'
require 'protobuf/rpc/error'
require 'protobuf/rpc/stat'

module Protobuf
  module Rpc
    module Server

      def initialize_request!
        log_debug { sign_message('Post init') }
        @request = ::Protobuf::Socketrpc::Request.new
        @response = ::Protobuf::Socketrpc::Response.new
        @stats = Protobuf::Rpc::Stat.new(:SERVER)
        set_peer
      end

      # no-op, implemented by including class if desired.
      def set_peer; end

      # Invoke the service method dictated by the proto wrapper request object
      def handle_client
        # Parse the protobuf request from the socket
        log_debug { "[#{log_signature}] Parsing request from client" }
        parse_request_from_buffer

        # Determine the service class and method name from the request
        log_debug { "[#{log_signature}] Extracting procedure call info from request" }
        parse_service_info

        # Call the service method
        log_debug { "[#{log_signature}] Dispatching client request to service" }
        ::GC.disable if ::Protobuf.gc_pause_server_request?
        invoke_rpc_method
      rescue => error
        log_exception(error)
        handle_error(error)
        send_response
      end

      # Client error handler. Receives an exception object and writes it into the @response
      def handle_error(error)
        log_debug { sign_message("handle_error: #{error.inspect}") }
        if error.respond_to?(:to_response)
          error.to_response(@response)
        else
          message = error.respond_to?(:message) ? error.message : error.to_s
          code = error.respond_to?(:code) ? error.code : 'RPC_ERROR'
          ::Protobuf::Rpc::PbError.new(message, code).to_response(@response)
        end
      end

      # Assuming all things check out, we can call the service method
      def invoke_rpc_method
        # Get a new instance of the service
        @service = @klass.new

        # Define our response callback to perform the "successful" response to our client
        # This decouples the service's rpc method from our response to the client,
        # allowing the service to be the dictator for when the response should be sent back.
        #
        # In other words, we don't send the response once the service method finishes executing
        # since the service may perform it's own operations asynchronously.
        @service.on_send_response do |response|
          unless @did_respond
            parse_response_from_service(response)
            send_response
          end
        end

        @service.on_rpc_failed do |error|
          unless @did_respond
            handle_error(error)
            send_response
          end
        end

        # Call the service method
        log_debug { "[#{log_signature}] Invoking %s#%s with request %s" % [@klass.name, @method, @request.inspect] }
        @service.__send__(@method, @request)
      end

      def log_signature
        @_log_signature ||= "[server-#{self.class.name}]"
      end

      # Parse the incoming request object into our expected request object
      def parse_request_from_buffer
        log_debug { sign_message("Parsing request from buffer: #{@request_data}") }
        @request.parse_from_string(@request_data)
      rescue => error
        exc = ::Protobuf::Rpc::BadRequestData.new("Unable to parse request: #{error.message}")
        log_error { exc.message }
        raise exc
      end

      # Read out the response from the service method,
      # setting it on the pb request, and serializing the
      # response to the protobuf response wrapper
      def parse_response_from_service(response)
        expected = @klass.rpcs[@klass][@method].response_type

        # Cannibalize the response if it's a Hash
        response = expected.new(response) if response.is_a?(Hash)
        actual = response.class
        log_debug { "[#{log_signature}] response (should/actual): %s/%s" % [expected.name, actual.name] }

        # Determine if the service tried to change response types on us
        if expected != actual
          raise ::Protobuf::Rpc::BadResponseProto, 'Response proto changed from %s to %s' % [expected.name, actual.name]
        else
          @response.response_proto = response
        end
      rescue => error
        log_error error.message
        log_error error.backtrace.join("\n")
        handle_error(error)
      end

      # Parses and returns the service and method name from the request wrapper proto
      def parse_service_info
        @klass = @request.service_name.constantize
        @method = @request.method_name.underscore.to_sym

        unless @klass.instance_methods.include?(@method)
          raise MethodNotFound, "Service method #{@request.method_name} is not defined by the service"
        end

        @stats.service = @klass.name
        @stats.method = @method
      rescue NameError
        raise ServiceNotFound, "Service class #{@request.service_name} is not found"
      end

      # Write the response wrapper to the client
      def send_response
        raise 'Response already sent to client' if @did_respond
        log_debug { sign_message("Sending response to client: #{@response.inspect}") }
        send_data
        @did_respond = true
        @stats.stop && log_info { @stats.to_s }
      ensure
        ::GC.enable if ::Protobuf.gc_pause_server_request?
      end
    end
  end
end
