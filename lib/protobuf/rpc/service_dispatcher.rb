require 'protobuf/logging'

module Protobuf
  module Rpc
    class ServiceDispatcher
      include ::Protobuf::Logging

      attr_reader :env

      def initialize(_app)
        # End of the line...
      end

      def call(env)
        @env = env

        env.response = dispatch_rpc_request
        env
      end

      def rpc_service
        @rpc_service ||= env.rpc_service.new(env)
      end

      private

      # Call the given service method.
      def dispatch_rpc_request
        unless rpc_service.respond_to?(method_name)
          fail MethodNotFound, "#{service_name}##{method_name} is not a publicly defined method."
        end

        rpc_service.callable_rpc_method(method_name).call
        rpc_service.response
      end

      def method_name
        env.method_name
      end

      def service_name
        env.service_name
      end
    end
  end
end
