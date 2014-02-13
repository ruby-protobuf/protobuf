require 'protobuf/logger'

module Protobuf
  module Rpc
    class ServiceDispatcher
      include ::Protobuf::Logger::LogMethods

      attr_accessor :callable_method, :definition, :env, :error, :response, :service, :service_klass

      def initialize(app)
        # End of the line...
      end

      def call(env)
        @env = env

        init_service!
        init_method!
        register_rpc_failed
        invoke!

        self.env
      end

      # We're in error if the error is populated.
      #
      def error?
        ! success?
      end

      # Call the given service method. If we get to this point and an error
      # has already occurred, do not invoke the method and simply respond.
      #
      def invoke!
        unless error?
          callable_method.call
          validate_response
        end

        env.response = error || response
      end

      def outer_request
        env.request
      end

      # We're successful if the error is not populated.
      #
      def success?
        error.nil?
      end

    private

      # Prod the object to see if we can produce a proto object as a response
      # candidate. Either way, return the candidate for validation.
      def coerced_response
        candidate = service.response

        case
        when candidate.is_a?(::Protobuf::Message) then
          # no-op
        when candidate.respond_to?(:to_proto) then
          candidate = candidate.to_proto
        when candidate.respond_to?(:to_proto_hash) then
          candidate = definition.response_type.new(candidate.to_proto_hash)
        when candidate.respond_to?(:to_hash) then
          candidate = definition.response_type.new(candidate.to_hash)
        end

        candidate
      end

      # Get the method for the current request.
      #
      def init_method!
        method_name = outer_request.method_name.underscore.to_sym
        request_proto = outer_request.has_field?(:request_proto) ? outer_request.request_proto : nil

        self.service = service_klass.new(method_name, request_proto, outer_request.caller)

        unless service_klass.rpc_method?(method_name)
          raise MethodNotFound, "#{service.class.name}##{method_name} is not a defined rpc method."
        end

        unless self.service.respond_to?(method_name)
          raise MethodNotFound, "#{service.class.name}##{method_name} is not implemented."
        end

        self.callable_method = service.callable_rpc_method(method_name)
        self.definition = service.rpcs[method_name]
      end

      # Constantize the service for this request. Initialization of the service
      # happens when we verify that the method is callable for this service.
      #
      def init_service!
        self.service_klass = outer_request.service_name.constantize
      rescue NameError
        raise ServiceNotFound, "Service class #{outer_request.service_name} is not defined."
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
        self.error = RpcFailed.new(message.respond_to?(:message) ? message.message : message)

        log_error { sign_message("RPC Failed: #{error.message}") }
      end

      # Ensure that the response candidate we've been given is of the type
      # we expect so that deserialization on the client side works.
      #
      def validate_response
        candidate = coerced_response
        expected = definition.response_type
        actual = candidate.class

        if expected != actual
          raise BadResponseProto, "Response proto changed from #{expected.name} to #{actual.name}"
        end

        self.response = candidate
      end
    end
  end
end
