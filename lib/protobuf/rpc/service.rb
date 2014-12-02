module Protobuf
  module Rpc
    # Object to encapsulate the request/response types for a given service method
    #
    RpcMethod = Struct.new(:method, :request_type, :response_type)

    class Service
      class << self
        # An array of defined service classes that contain implementation
        # code
        def implemented_services
          classes = (subclasses || []).select do |subclass|
            subclass.rpcs.any? do |(name, _)|
              subclass.method_defined? name
            end
          end

          classes.map(&:name)
        end

        # Define an rpc method with the given request and response types.
        # This methods is only used by the generated service definitions
        # and not useful for user code.
        #
        def rpc(method, request_type, response_type)
          rpcs[method] = RpcMethod.new(method, request_type, response_type)
        end

        # Hash containing the set of methods defined via `rpc`.
        #
        def rpcs
          @rpcs ||= {}
        end

        # Check if the given method name is a known rpc endpoint.
        #
        def rpc_method?(name)
          rpcs.key?(name)
        end
      end

      # Convenience method to get back to class method.
      #
      def rpc_method?(name)
        self.class.rpc_method?(name)
      end

      # Convenience method to get back to class rpcs hash.
      #
      def rpcs
        self.class.rpcs
      end
    end
  end
end
