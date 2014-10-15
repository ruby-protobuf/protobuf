module Protobuf
  module Rpc
    module Middleware
      class RequestDecoder
        include ::Protobuf::Logging

        attr_reader :app, :env

        def initialize(app)
          @app = app
        end

        def call(env)
          @env = env

          env.service_name = service_name
          env.method_name = method_name
          env.request = request
          env.client_host = request_wrapper.caller

          env.rpc_service = service
          env.rpc_method = rpc_method
          env.request_type = rpc_method.request_type
          env.response_type = rpc_method.response_type

          app.call(env)
        end

        def log_signature
          env.log_signature || super
        end

        private

        def method_name
          @method_name ||= begin
            method_name = request_wrapper.method_name.underscore.to_sym

            unless service.rpc_method?(method_name)
              fail MethodNotFound, "#{service.name}##{method_name} is not a defined RPC method."
            end

            method_name
          end
        end

        def request
          @request ||= begin
            data = request_wrapper.request_proto
            rpc_method.request_type.decode(data)
          end
        rescue => exception
          raise BadRequestData, "Unable to decode request: #{exception.message}"
        end

        # Decode the incoming request object into our expected request object
        #
        def request_wrapper
          @request_wrapper ||= begin
            logger.debug { sign_message("Decoding request: #{env.encoded_request}") }
            Socketrpc::Request.decode(env.encoded_request)
          end
        rescue => exception
          raise BadRequestData, "Unable to decode request: #{exception.message}"
        end

        def rpc_method
          @rpc_method ||= service.rpcs[method_name]
        end

        def service
          @service ||= service_name.constantize
        rescue NameError
          raise ServiceNotFound, "Service class #{service_name} is not defined."
        end

        def service_name
          @service_name ||= request_wrapper.service_name
        end
      end
    end
  end
end
