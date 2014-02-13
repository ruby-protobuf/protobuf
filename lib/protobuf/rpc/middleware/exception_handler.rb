module Protobuf
  module Rpc
    module Middleware
      class ExceptionHandler
        include ::Protobuf::Logger::LogMethods

        attr_reader :app

        def initialize(app)
          @app = app
        end

        def call(env)
          app.call(env)
        rescue => exception
          log_exception(exception)

          # Rescue exceptions, re-wrap them as generic Protobuf errors,
          # and set the response
          env.response = wrap_exception(exception)
          env
        end

      private

        # Wrap exceptions in a generic Protobuf errors unless they already are
        #
        def wrap_exception(exception)
          exception = PbError.new(exception.message) unless exception.is_a?(PbError)
          exception
        end
      end
    end
  end
end
