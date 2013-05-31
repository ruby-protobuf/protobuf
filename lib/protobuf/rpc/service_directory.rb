require 'delegate'
require 'singleton'
require 'socket'
require 'thread'
require 'protobuf/rpc/dynamic_discovery.pb'

module Protobuf
  module Rpc
    class ServiceDirectory
      include ::Singleton
      include ::Protobuf::Logger::LogMethods

      DEFAULT_ADDRESS = "0.0.0.0"
      DEFAULT_PORT = 9398

      class Server < Delegator
        attr_reader :expires_at

        def initialize(server)
          @server = server
          @expires_at = Time.now.to_i + ttl
        end

        def current?
          !expired?
        end

        def expired?
          Time.now.to_i >= @expires_at
        end

        def __getobj__
          @server
        end
      end

      # Class Methods
      #
      def self.address
        @address ||= DEFAULT_ADDRESS
      end

      def self.address=(value)
        @address ||= value
      end

      def self.port
        @port ||= DEFAULT_PORT
      end

      def self.port=(value)
        @port ||= value.to_i
      end

      def self.start
        self.instance.start
      end

      # Instance Methods
      #
      def initialize
        @servers = {}
        @mutex = Mutex.new
      end

      def add_server(server)
        @mutex.synchronize do
          @servers[server.uuid] = Server.new(server)
        end
      end

      def find(service)
        log_debug { sign_message("searching for #{service}") }
        Thread.pass until server = random_server_for(service)
        log_debug { sign_message("found #{service} at #{server}") }

        [server.address, server.port]
      end

      def random_server_for(service)
        @mutex.synchronize do
          servers = @servers.values.select do |server|
            server.services.any? do |service_class|
              server.current? && service_class.to_s == service.to_s
            end
          end

          servers.sample
        end
      end

      def reap_expired_servers
        @mutex.synchronize do
          @servers.delete_if do |uuid, server|
            server.expired?
          end
        end
      end

      def remove_server(server)
        @mutex.synchronize do
          @servers.delete server.uuid
        end
      end

      def run
        loop do
          data, addr = @socket.recvfrom(1024)
          beacon = ::Protobuf::Rpc::DynamicDiscovery::Beacon.new
          beacon.parse_from_string(data) rescue nil

          log_debug { sign_message("received beacon: #{beacon.inspect}") }

          case beacon.beacon_type
          when ::Protobuf::Rpc::DynamicDiscovery::BeaconType::HEARTBEAT
            add_server(beacon.server)
          when ::Protobuf::Rpc::DynamicDiscovery::BeaconType::FLATLINE
            remove_server(beacon.server)
          end

          reap_expired_servers
        end
      end

      def running?
        @thread.try(:alive?)
      end

      def start
        unless running?
          log_debug { sign_message("starting service directory") }

          init_socket

          @thread = Thread.new do
            begin
              self.run
            rescue => e
              log_debug { sign_message("service directory failed: (#{e.class}) #{e.message}") }
              raise
            end
          end
        end

        self
      end

      private

      def init_socket
        @socket = UDPSocket.new
        @socket.bind(self.class.address, self.class.port)
      end
    end
  end
end
