module Protobuf
  module Rpc
    module Middleware
      class ResponseEncoder
        include ::Protobuf::Logger::LogMethods

        attr_reader :app, :env

        def initialize(app)
          @app = app
        end

        def call(env)
          @env = app.call(env)
          @env.encoded_response = encode_response_data(@env.response)

          @env
        end

        def log_signature
          env.signature || super
        end

      private

        # Encode the response wrapper to return to the client
        #
        def encode_response_data(response)
          log_debug { sign_message("Encoding response: #{response.inspect}") }

          response = wrap_response(response)
          env.encoded_response = Socketrpc::Response.encode(response)
        rescue => exception
          log_exception(exception)

          # Rescue encoding exceptions, re-wrap them as generic protobuf errors,
          # and set it as the encoded response so we always have something to
          # send back
          error = PbError.new(exception.message)
          env.response = error
          env.encoded_response = error.to_response.encode
        ensure
          return env.encoded_response
        end

        # The middleware stack returns either an error or response proto. Package
        # it up so that it's in the correct spot in the response wrapper
        #
        def wrap_response(response)
          if response.is_a?(Protobuf::Rpc::PbError)
            { :error => response.message, :error_reason => response.error_type }
          else
            { :response_proto => response.encode }
          end
        end
      end
    end
  end
end
