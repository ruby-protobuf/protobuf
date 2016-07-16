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
        headers = {
          "Accept" => "application/x-protobuf",
          "Content-Type" => "application/x-protobuf",
        }
        [200, headers, [response]]
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
      end

      def run
        args = [
          "--port", "#{options.fetch(:port)}",
          # "--bind", "tcp://#{options.fetch(:host)}",
          "/Users/garrettthornburg/Development/RubyDevelopment/protobuf/lib/protobuf/rpc/servers/http/rackup.ru"
        ]

        cli = Puma::CLI.new(args)
        cli.run
      end
    end
  end
end
