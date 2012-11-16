require 'protobuf/logger'
require 'protobuf/rpc/rpc.pb'
require 'protobuf/rpc/buffer'
require 'protobuf/rpc/error'
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
        set_peer
      end

      def disable_gc!
        ::GC.disable if ::Protobuf.gc_pause_server_request?
      end

      def enable_gc!
        ::GC.enable && ::GC.start if ::Protobuf.gc_pause_server_request?
      end

      # no-op, implemented by including class if desired.
      def set_peer; end

      # Invoke the service method dictated by the proto wrapper request object
      def handle_client
        parse_request_from_buffer
        @dispatcher = ::Protobuf::Rpc::ServiceDispatcher.new(@request)
        @stats.dispatcher = @dispatcher

        disable_gc!
        @dispatcher.invoke!
        if @dispatcher.success?
          @response.response_proto = @dispatcher.response
        else
          handle_error(@dispatcher.error)
        end
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
