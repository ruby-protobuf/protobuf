module Protobuf
  module Rpc
    module Middleware
      class RequestDecoder
        include ::Protobuf::Logging

        # Too deep a nesting of messages in the request uses up the stack. That
        # error is not a StandardError, and on JRuby it is a Java error, so the
        # plain rescues below do not catch it. Without this the client gets no
        # response, and the ZMQ worker thread stops.
        STACK_ERRORS = [::SystemStackError].tap do |errors|
          errors << ::Java::JavaLang::StackOverflowError if defined?(::JRUBY_VERSION)
        end.freeze

        attr_reader :app, :env

        def initialize(app)
          @app = app
        end

        def call(env)
          dup._call(env)
        end

        def _call(env)
          @env = env

          logger.debug { sign_message("Decoding request: #{env.encoded_request}") }
          env.service_name = service_name
          env.method_name = method_name
          env.request = request
          env.request_wrapper = request_wrapper
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
          return @method_name unless @method_name.nil?

          @method_name = request_wrapper.method_name.underscore.to_sym
          fail MethodNotFound, "#{service.name}##{@method_name} is not a defined RPC method." unless service.rpc_method?(@method_name)
          @method_name
        end

        def request
          @request ||= rpc_method.request_type.decode(request_wrapper.request_proto)
        rescue StandardError, *STACK_ERRORS => exception
          raise BadRequestData, "Unable to decode request: #{exception.message}"
        end

        # Decode the incoming request object into our expected request object
        #
        def request_wrapper
          @request_wrapper ||= ::Protobuf::Socketrpc::Request.decode(env.encoded_request)
        rescue StandardError, *STACK_ERRORS => exception
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
