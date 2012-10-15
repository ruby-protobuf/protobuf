require 'protobuf/logger'

module Protobuf
  module Rpc
    class ServiceDispatcher

      include ::Protobuf::Logger::LogMethods

      attr_accessor :service, :service_klass, :callable_method, :outer_request
      attr_accessor :definition, :response, :error

      def initialize(wrapper_request)
        self.error = nil
        self.outer_request = wrapper_request

        init_service
        init_method if service_klass.present?
        register_rpc_failed if service.present?
      end

      # Call the given service method. If we get to this point and an error
      # has already occurred, do not invoke the method and simply respond.
      #
      def invoke!
        unless error?
          callable_method.call
          validate_response
        end

        return error || response
      end

      # We're successful if the error is not populated.
      #
      def success?
        error.nil?
      end

      # We're in error if the error is populated.
      #
      def error?
        ! success?
      end

      private

      def assign_error(error_klass, message)
        self.error = error_klass.new(message)
      end

      # Get the method for the current request.
      #
      def init_method
        method_name = outer_request.method_name.underscore.to_sym
        if service_klass.rpc_method?(method_name)
          self.service = service_klass.new(method_name, outer_request.request_proto)
          self.callable_method = service.method(method_name)
          self.definition = service.rpcs[method_name]
        else
          assign_error(MethodNotFound, "#{service.class.name}##{method_name} is not a defined rpc method.")
        end
      rescue NameError => e
        log_exception(e)
        assign_error(MethodNotFound, "#{service.class.name}##{method_name} is not implemented.")
      end

      # Constantize the service for this request. Initialization of the service
      # happens when we verify that the method is callable for this service.
      #
      def init_service
        self.service_klass = outer_request.service_name.constantize
      rescue NameError => e
        log_exception(e)
        assign_error(ServiceNotFound, "Service class #{outer_request.service_name} is not defined.")
      end

      # Make sure we get rpc errors back.
      #
      def register_rpc_failed
        service.on_rpc_failed(method(:rpc_failed_callback))
      end

      # Receive the failure message from the service. This method is registered
      # as the callable to the service when an `rpc_failed` call is invoked.
      #
      def rpc_failed_callback(message)
        assign_error(RpcFailed, (message.respond_to?(:message) ? message.message : message))
        log_error { sign_message("RPC Failed: #{error.message}") }
      end

      # Ensure that the response candidate we've been given is of the type
      # we expect so that deserialization on the client side works.
      #
      def validate_response
        expected = definition.response_type

        candidate = service.response
        candidate = expected.new(candidate) if candidate.is_a?(Hash)

        actual = candidate.class
        log_debug { sign_message("response (should/actual): #{expected.name}/#{actual.name}") }

        # Determine if the service tried to change response types on us
        if expected != actual
          assign_error(BadResponseProto, "Response proto changed from #{expected.name} to #{actual.name}")
        else
          self.response = candidate
        end
      end

    end
  end
end

