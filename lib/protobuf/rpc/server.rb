require 'protobuf'
require 'protobuf/logger'
require 'protobuf/rpc/rpc.pb'
require 'protobuf/rpc/buffer'
require 'protobuf/rpc/error'
require 'protobuf/rpc/middleware'
require 'protobuf/rpc/stat'
require 'protobuf/rpc/service_dispatcher'

module Protobuf
  module Rpc
    module Server
      def initialize_request!
        log_debug { sign_message('Post init') }
        @request = ::Protobuf::Socketrpc::Request.new
        @response = ::Protobuf::Socketrpc::Response.new
        @stats = Protobuf::Rpc::Stat.new(:SERVER)
      end

      def disable_gc!
        ::GC.disable if ::Protobuf.gc_pause_server_request?
      end

      def enable_gc!
        ::GC.enable && ::GC.start if ::Protobuf.gc_pause_server_request?
      end

      # Invoke the service method dictated by the proto wrapper request object
      def handle_client
        parse_request_from_buffer

        # Create an env object that holds different parts of the environment and
        # is available to all of the middlewares.
        #
        # TODO: Add extra info about the environment (i.e. variables) and other
        # information that might be useful to
        env = {
          'request' => @request,
          'stats' => @stats
        }

        # Invoke the middleware stack, the last of which is the service
        # dispatcher. The dispatcher returns either an error object or a
        # protobufresponse object.
        error_or_response = ::Protobuf::Rpc.middleware.call(env)

        # TODO: I think it would be better if the middleware stack became a
        # clean separation between the server and the dispatcher so that what
        # was returned from the dispatcher was a response object that was ready
        # to go (e.g. the wrapper response). Any errors that occurred in the
        # server would need to be handled accordingly, but this way, there is
        # a consistent API.
        handle_error_or_response(error_or_response)

        # TODO: Move the stats tracking into the middleware stack.
        @stats.client = @request.caller

        # TODO: Move request logging to the middleware stack.
        log_info { @stats.to_s }

        disable_gc!
      rescue => error
        log_exception(error)
        handle_error(error)
      ensure
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

      # The middleware stack returns either an error or response proto. Package
      # it up so that it's in the correct spot in the respone wrapper.
      def handle_error_or_response(error_or_response)
        if error_or_response < Protobuf::Rpc::PbError
          handle_error(error_or_response)
        else
          @response.response_proto = error_or_response
        end
      end

      def log_signature
        @_log_signature ||= "[server-#{self.class.name}]"
      end

      # Parse the incoming request object into our expected request object
      def parse_request_from_buffer
        log_debug { sign_message("Parsing request from buffer: #{@request_data}") }
        @stats.request_size = @request_data.size
        @request.decode(@request_data)
      rescue => error
        exc = ::Protobuf::Rpc::BadRequestData.new("Unable to parse request: #{error.message}")
        log_error { exc.message }
        raise exc
      end

      # Write the response wrapper to the client
      def send_response
        log_debug { sign_message("Sending response to client: #{@response.inspect}") }
        send_data
      ensure
        @stats.stop
        log_info { @stats.to_s }
        enable_gc!
      end
    end
  end
end
