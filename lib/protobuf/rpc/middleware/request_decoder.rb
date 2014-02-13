module Protobuf
  module Rpc
    module Middleware
      class RequestDecoder
        include Logger::LogMethods

        attr_reader :app, :env

        def initialize(app)
          @app = app
        end

        def call(env)
          @env = env

          call_app
        end

        def log_signature
          env.signature || super
        end

      private

        def call_app
          if env.request = decode_request_data(env.encoded_request)
            env.caller = env.request.caller
            env.service_name = env.request.service_name
            env.method_name = env.request.method_name

            # TODO: Figure out a better way to do stat tracking
            env.stats.request_size = env.encoded_request.size
            env.stats.client = env.request.caller

            app.call(env)
          else
            env
          end
        end

        # Decode the incoming request object into our expected request object
        #
        def decode_request_data(data)
          log_debug { sign_message("Decoding request: #{data}") }

          Socketrpc::Request.decode(data)
        rescue => exception
          log_exception(exception)

          # Rescue decoding exceptions, re-wrap them as bad request data errors,
          # and set the response so we can safely short-curcuit the rest of the
          # middleware call.
          env.response = BadRequestData.new("Unable to decode request: #{exception.message}").to_response

          return nil # Explicitly return nil so we don't continue up the stack
        end
      end
    end
  end
end
