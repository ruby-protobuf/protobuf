module Protobuf
  module Rpc
    module Middleware
      class RequestDecoder
        include ::Protobuf::Logger::LogMethods

        attr_reader :app, :env

        def initialize(app)
          @app = app
        end

        def call(env)
          @env = env

          request_wrapper = decode_request_data(env.encoded_request)

          env.request = request_wrapper
          env.caller = request_wrapper.caller
          env.service_name = request_wrapper.service_name
          env.method_name = request_wrapper.method_name

          app.call(env)
        end

        def log_signature
          env.signature || super
        end

      private

        # Decode the incoming request object into our expected request object
        #
        def decode_request_data(data)
          log_debug { sign_message("Decoding request: #{data}") }

          Socketrpc::Request.decode(data)
        rescue => exception
          log_exception(exception)

          # Rescue decoding exceptions, re-wrap them as bad request data errors,
          # and re-raise so we can safely short-curcuit the rest of the
          # middleware call.
          raise BadRequestData.new("Unable to decode request: #{exception.message}")
        end
      end
    end
  end
end
