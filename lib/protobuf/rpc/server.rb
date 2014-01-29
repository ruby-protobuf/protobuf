require 'protobuf'
require 'protobuf/logger'
require 'protobuf/rpc/rpc.pb'
require 'protobuf/rpc/buffer'
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

        ::GC.enable && ::GC.start if ::Protobuf.gc_pause_server_request?
      end

      # Invoke the service method dictated by the proto wrapper request object
      #
      def handle_request(request_data)
        log_debug { sign_message("Handling request") }

        # Create an env object that holds different parts of the environment and
        # is available to all of the middlewares.
        initialize_env!
        env['stats'].request_size = request_data.size

        env['request'] = decode_request_data(request_data)
        env['stats'].client = env['request'].caller

        # Invoke the middleware stack, the last of which is the service
        # dispatcher. The dispatcher sets either an error object or a
        # protobuf response object to env['response'].
        env = Rpc.middleware.call(env)

        response_data = handle_response(env['response'])
      rescue => error
        log_exception(error)
        response_data = handle_error(error)
      ensure
        encoded_response = encode_response_data(response_data)
        env['stats'].stop

        # Log the response stats
        log_info { env['stats'].to_s }

        encoded_response
      end

      def log_signature
        @_log_signature ||= "[server-#{self.class.name}]"
      end

    private

      # Decode the incoming request object into our expected request object
      #
      def decode_request_data(data)
        log_debug { sign_message("Decoding request: #{data}") }

        Socketrpc::Request.decode(data)
      rescue => error
        exception = BadRequestData.new("Unable to decode request: #{error.message}")
        log_error { exception.message }
        raise exception
      end

      # Encode the response wrapper to return to the client
      #
      def encode_response_data(response)
        log_debug { sign_message("Encoding response: #{response.inspect}") }

        encoded_response = response.encode
      rescue => error
        log_exception(error)
        encoded_response = handle_error(error).encode
      ensure
        env['stats'].response_size = encoded_response.size
        encoded_response
      end

      # Embed exceptions in a response wrapper
      #
      def handle_error(error)
        log_debug { sign_message("handle_error: #{error.inspect}") }

        if error.respond_to?(:to_response)
          error.to_response
        else
          PbError.new(error.message).to_response
        end
      end

      # The middleware stack returns either an error or response proto. Package
      # it up so that it's in the correct spot in the respone wrapper
      #
      def handle_response(response)
        if response < Protobuf::Rpc::PbError
          handle_error(response)
        else
          Socketrpc::Response.new(:response_proto => response)
        end
      end

      # Initialize a new environment object
      #
      # NOTE: This has to be reinitialized with each request and can't be
      # memoized since servers aren't always reinitialized with each request
      #
      def initialize_env!
        # TODO: Add extra info about the environment (i.e. variables) and other
        # information that might be useful
        @_env = {
          'request' => nil,
          'response' => nil,
          'stats' => Stat.new(:SERVER)
        }
      end

      def stats
        @_stats
      end
    end
  end
end
