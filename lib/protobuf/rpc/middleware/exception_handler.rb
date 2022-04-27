module Protobuf
  module Rpc
    module Middleware
      class ExceptionHandler
        include ::Protobuf::Logging

        attr_reader :app

        def initialize(app)
          @app = app
        end

        def call(env)
          dup._call(env)
        end

        def _call(env)
          app.call(env)
        rescue => exception
          log_exception(exception)

          # Rescue exceptions, re-wrap them as generic Protobuf errors,
          # and encode them
          env.response = wrap_exception(exception)
          env.encoded_response = wrap_and_encode_with_server(env.response, env)
          env
        end

        private

        # Wrap exceptions in a generic Protobuf errors unless they already are
        #
        def wrap_exception(exception)
          exception = RpcFailed.new(exception.message) unless exception.is_a?(PbError)
          exception
        end

        # If the response is a PbError, it won't have the server merged into the response proto.
        # We should add it here since exception handler is always at the bottom of the middleware
        # stack. Without this, the server hostname in the client rpc log will not be set.
        def wrap_and_encode_with_server(response, env)
          if response.is_a?(PbError)
            response.encode(:server => env.server)
          else
            response.encode
          end
        end
      end
    end
  end
end
