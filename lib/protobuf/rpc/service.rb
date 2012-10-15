require 'protobuf/logger'
require 'protobuf/rpc/client'
require 'protobuf/rpc/error'

module Protobuf
  module Rpc
    # Object to encapsulate the request/response types for a given service method
    #
    RpcMethod = Struct.new("RpcMethod", :method, :request_type, :response_type)

    class Service
      include Protobuf::Logger::LogMethods

      attr_reader :response

      DEFAULT_HOST = '127.0.0.1'.freeze
      DEFAULT_PORT = 9399

      ##
      # Class Methods
      #

      # Create a new client for the given service.
      # See Client#initialize and ClientConnection::DEFAULT_OPTIONS
      # for all available options.
      #
      def self.client(options = {})
        ::Protobuf::Rpc::Client.new({ :service => self,
                                      :host => host,
                                      :port => port }.merge(options))
      end

      # Allows service-level configuration of location.
      # Useful for system-startup configuration of a service
      # so that any Clients using the Service.client sugar
      # will not have to configure the location each time.
      #
      def self.configure(config = {})
        self.host = config.delete(:host) if config.key?(:host)
        self.port = config.delete(:port) if config.key?(:port)
      end

      # The host location of the service.
      #
      def self.host
        @_host ||= DEFAULT_HOST
      end

      # The host location setter.
      #
      def self.host=(new_host)
        @_host = new_host
      end

      # Shorthand call to configure, passing a string formatted as hostname:port
      # e.g. 127.0.0.1:9933
      # e.g. localhost:0
      #
      def self.located_at(location)
        return if location.nil? || location.downcase.strip !~ /.+:\d+/
        host, port = location.downcase.strip.split ':'
        configure(:host => host, :port => port.to_i)
      end

      # The port of the service on the destination server.
      #
      def self.port
        @_port ||= DEFAULT_PORT
      end

      # The port location setter.
      #
      def self.port=(new_port)
        @_port = new_port
      end

      # Define an rpc method with the given request and response types.
      # This methods is only used by the generated service definitions
      # and not useful for user code.
      #
      def self.rpc(method, request_type, response_type)
        rpcs[method] = RpcMethod.new(method, request_type, response_type)
      end

      # Hash containing the set of methods defined via `rpc`.
      #
      def self.rpcs
        @_rpcs ||= {}
      end

      # Check if the given method name is a known rpc endpoint.
      #
      def self.rpc_method?(name)
        rpcs.key?(name)
      end


      ##
      # Instance Methods
      #

      # Initialize a service with the rpc endpoint name and the bytes
      # for the request.
      def initialize(rpc, request_bytes)
        @rpc = rpc
        @request_bytes = request_bytes
      end

      # Register a failure callback for use when rpc_failed is invoked.
      #
      def on_rpc_failed(callable)
        @rpc_failed_callback ||= callable
      end

      # Response object for this rpc cycle. Not assignable.
      #
      def response
        @_response ||= rpcs[@rpc].response_type.new
      end

      # Convenience method to get back to class method.
      #
      def rpc_method?(name)
        self.class.rpc_method?(name)
      end

      # Convenience method to get back to class rpcs hash.
      #
      def rpcs
        self.class.rpcs
      end

      private

      # Request object for this rpc cycle. Not assignable.
      #
      def request
        @_request ||= rpcs[@rpc].request_type.new.parse_from_string(@request_bytes)
      rescue => e
        raise BadRequestProto, "Unable to parse request: #{e.message}"
      end

      # Sugar to make an rpc method feel like a controller method.
      # If this method is not called, the response will be the memoized
      # object returned by the response reader.
      #
      def respond_with(candidate)
        @_response = candidate
      end
      alias_method :return_from_whence_you_came, :respond_with

      # Automatically fail a service method.
      #
      def rpc_failed(message)
        @rpc_failed_callback.call(message)
      end

    end
  end
end
