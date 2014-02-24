module Protobuf
  module Rpc
    module Middleware
      class Logger
        include ::Protobuf::Logging

        RECEIVED_FORMAT  = '[%s] Received %s#%s from %s'.freeze

        def initialize(app)
          @app = app
        end

        def call(env)
          logger.info do
            RECEIVED_FORMAT % [
              thread_id,
              env.service_name || "Unknown",
              env.method_name || "unknown",
              env.client_host
            ]
          end

          @app.call(env)
        end
      end
    end
  end
end
