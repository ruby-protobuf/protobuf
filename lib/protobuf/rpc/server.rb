require 'protobuf'
require 'protobuf/logger'
require 'protobuf/rpc/rpc.pb'
require 'protobuf/rpc/buffer'
require 'protobuf/rpc/env'
require 'protobuf/rpc/error'
require 'protobuf/rpc/middleware'
require 'protobuf/rpc/stat'
require 'protobuf/rpc/service_dispatcher'

module Protobuf
  module Rpc
    module Server
      def gc_pause
        ::GC.disable if ::Protobuf.gc_pause_server_request?

        yield

        ::GC.enable if ::Protobuf.gc_pause_server_request?
      end

      # Invoke the service method dictated by the proto wrapper request object
      #
      def handle_request(request_data)
        log_debug { sign_message("Handling request") }

        # Create an env object that holds different parts of the environment and
        # is available to all of the middlewares
        initialize_env!(request_data)

        # Invoke the middleware stack, the last of which is the service dispatcher
        env = Rpc.middleware.call(env)
        env.stats.stop

        # Log the response stats
        log_info { env.stats.to_s }

        env.encoded_response
      end

      def log_signature
        @_log_signature ||= "[server-#{self.class.name}]"
      end

    private

      # Initialize a new environment object
      #
      # NOTE: This has to be reinitialized with each request and can't be
      # memoized since servers aren't always reinitialized with each request
      #
      def initialize_env!(request_data)
        # TODO: Figure out a better way to handle logging with signatures
        @_env = Env.new(
          'encoded_request' => request_data,
          'log_signature' => log_signature,
          'stats' => Stat.new(:SERVER)
        )
      end
    end
  end
end
