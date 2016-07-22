require "puma/cli"
require "protobuf/rpc/server"

module Protobuf
  module Rpc
    class HTTPRequest
      include ::Protobuf::Rpc::Server
      include ::Protobuf::Logging

      attr_reader :env

      def initialize(env)
        @env = env
      end

      def handle
        response = handle_request(body)
        [200, {}, [response]]
      end

      def body
        @body ||= env["rack.input"].read
      end

      def service
        @service ||= @service_name.constantize
      rescue NameError
        raise ServiceNotFound, "Service class #{@service_name} is not defined."
      end
    end

    class HTTPRunner
      attr_reader :options

      def initialize(options)
        @options = options.to_hash.symbolize_keys
        @should_stop = false
      end

      def run
        app = lambda { |env|
          request = ::Protobuf::Rpc::HTTPRequest.new(env)
          request.handle
        }

        server = ::Puma::Server.new(app)
        server.add_tcp_listener(options.fetch(:host), options.fetch(:port))
        server.max_threads = options.fetch(:threads)
        server.min_threads = options.fetch(:threads)
        server.run

        yield if block_given?

        sleep 0.1 until @should_stop

        server.stop(true)
      end
    end
  end
end
