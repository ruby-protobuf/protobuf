require 'active_support/number_helper'

module Protobuf
  module Rpc
    module Middleware
      class Logger
        include ::Protobuf::Logging
        include ::ActiveSupport::NumberHelper

        RECEIVED_FORMAT  = '[%s] Received %s#%s (%s) from %s'.freeze

        def initialize(app)
          @app = app
        end

        def call(env)
          logger.info do
            RECEIVED_FORMAT % [
              thread_id,
              env.service_name || "Unknown",
              env.method_name || "unknown",
              number_to_human_size(env['encoded_request'].size),
              env.client_host
            ]
          end

          @app.call(env)
        end
      end
    end
  end
end
