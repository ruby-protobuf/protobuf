require 'protobuf/statsd'

module Protobuf
  module Rpc
    module Middleware
      class Statsd
        def initialize(app)
          @app = app
        end

        def call(env)
          start_time = Time.now.utc
          begin
            env = @app.call(env)
          ensure
            record_stats(env, start_time)
          end

          env
        end

        # Return base path for StatsD metrics
        def statsd_base_path(env)
          if env.service_name && env.method_name
            "rpc-server.#{env.service_name}.#{env.method_name}".gsub('::', '.').downcase
          else
            nil
          end
        end

        # Send success/failure and timing information to Statsd, if
        # one was configured in Protobuf::Statsd.
        def record_stats(env, start_time)
          statsd_client = Protobuf::Statsd.client
          path = statsd_base_path(env)
          return unless statsd_client && path && env.response
          end_time = Time.now.utc

          if env.response.is_a?(Protobuf::Rpc::PbError)
            statsd_client.increment("#{path}.failure.total")
            statsd_client.increment("#{path}.failure.#{env.response.error_type}")
          else
            statsd_client.increment("#{path}.success")
          end

          statsd_client.timing("#{path}.time", end_time - start_time)
        rescue => e
          # We insert ourself after Exception handler, so no exceptions allowed!
          Protobuf::Logger.warn { "Error with Statsd middleware: #{e.message}" }
        end
        private :record_stats
      end
    end
  end
end
