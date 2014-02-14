require 'protobuf/logger'

module Protobuf
  module Rpc
    class ServiceDispatcher
      include ::Protobuf::Logger::LogMethods

      attr_reader :env

      def initialize(app)
        # End of the line...
      end

      def call(env)
        @env = env

        register_rpc_failed

        env.response = dispatch_rpc_request
        env
      end

      def rpc_service
        @rpc_service ||= env.rpc_service.new(env)
      end

    private

      # Get a callable RPC method for the current request.
      #
      def callable_rpc_method
        unless rpc_service.respond_to?(method_name)
          raise MethodNotFound.new("#{rpc_service.class.name}##{method_name} is not implemented.")
        end

        rpc_service.callable_rpc_method(method_name)
      end

      # Prod the object to see if we can produce a proto object as a response
      # candidate. Either way, return the candidate for validation.
      def coerced_response
        candidate = rpc_service.response

        case
        when candidate.is_a?(::Protobuf::Message) then
          # no-op
        when candidate.respond_to?(:to_proto) then
          candidate = candidate.to_proto
        when candidate.respond_to?(:to_proto_hash) then
          candidate = env.response_type.new(candidate.to_proto_hash)
        when candidate.respond_to?(:to_hash) then
          candidate = env.response_type.new(candidate.to_hash)
        end

        candidate
      end

      def dispatch_rpc_request
        # Call the given service method.
        callable_rpc_method.call
        validate_response!
      end

      def method_name
        env.method_name
      end

      # Make sure we get rpc errors back.
      #
      def register_rpc_failed
        rpc_service.on_rpc_failed(method(:rpc_failed_callback))
      end

      # Receive the failure message from the service. This method is registered
      # as the callable to the service when an `rpc_failed` call is invoked.
      #
      def rpc_failed_callback(message)
        message = message.message if message.respond_to?(:message)
        raise RpcFailed.new(message)
      end

      def rpc_method
        env.rpc_method
      end

      # Ensure that the response candidate we've been given is of the type
      # we expect so that deserialization on the client side works.
      #
      def validate_response!
        candidate = coerced_response
        actual = candidate.class
        expected = env.response_type

        if expected != actual
          raise BadResponseProto.new("Response proto changed from #{expected.name} to #{actual.name}")
        end

        candidate
      end
    end
  end
end
