module Protobuf
  module Rpc
    module Middleware
      class Logger
        include ::Protobuf::Logging

        def initialize(app)
          @app = app
        end

        def call(env)
          @app.call(env)
        end
      end
    end
  end
end
