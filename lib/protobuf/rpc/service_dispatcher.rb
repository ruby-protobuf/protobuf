require 'protobuf/logger'

module Protobuf
  module Rpc
    class ServiceDispatcher

      include ::Protobuf::Logger::LogMethods

      attr_accessor :service, :callable_method, :outer_request, :definition
      attr_accessor :request, :response, :error

      def initialize(wrapper_request)
        self.error = nil
        self.outer_request = wrapper_request

        init_service
        if service.present?
          init_method
          register_rpc_failed
        end

        if definition.present?
          init_request
          init_response
        end
      end

      # Call the given service method. If we get to this point and an error
      # has already occurred, do not invoke the method and simply respond.
      def invoke!
        validate_response(callable_method.call(request, response)) unless error?
        return error || response
      end

      # We're successful if the error is not populated.
      def success?
        error.nil?
      end

      # We're in error if the error is populated.
      def error?
        ! success?
      end

      private

      def assign_error(error_klass, message)
        self.error = error_klass.new(message)
      end

      # Get the method for the current request.
      def init_method
        method_name = outer_request.method_name.underscore.to_sym
        if service.rpc_method?(method_name)
          self.callable_method = service.method(method_name)
          self.definition = service.rpcs[method_name]
        else
          assign_error(MethodNotFound, "#{service.class.name}##{method_name} is not a defined rpc method.")
        end
      rescue NameError => e
        log_exception(e)
        assign_error(MethodNotFound, "#{service.class.name}##{method_name} is not implemented.")
      end

      # Initialize the request and parse it from the bytes buffer.
      def init_request
        self.request = definition.request_type.new.parse_from_string(outer_request.request_proto)
      rescue => e
        log_exception(e)
        assign_error(BadRequestProto, "Unable to parse request: #{e.message}")
      end

      # Initialize an empty response for the current method.
      def init_response
        self.response = definition.response_type.new
      end

      # Get the service for the current request.
      def init_service
        self.service = outer_request.service_name.constantize.new
      rescue NameError => e
        log_exception(e)
        assign_error(ServiceNotFound, "Service class #{outer_request.service_name} is not defined.")
      end

      # Make sure we get rpc errors back.
      def register_rpc_failed
        service.on_rpc_failed(method(:rpc_failed))
      end

      def rpc_failed(message)
        assign_error(RpcFailed, (message.respond_to?(:message) ? message.message : message))
        log_error { sign_message("RPC Failed: #{error.message}") }
      end

      def validate_response(object)
        expected = definition.response_type

        # Cannibalize the response if it's a Hash
        object = expected.new(object) if object.is_a?(Hash)
        actual = object.class
        log_debug { sign_message("response (should/actual): #{expected.name}/#{actual.name}") }

        # Determine if the service tried to change response types on us
        if expected != actual
          assign_error(BadResponseProto, "Response proto changed from #{expected.name} to #{actual.name}")
        else
          self.response = object
        end
      end

    end
  end
end

