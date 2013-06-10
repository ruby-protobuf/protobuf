require 'delegate'
require 'singleton'
require 'socket'
require 'thread'
require 'timeout'

require 'protobuf/rpc/dynamic_discovery.pb'

module Protobuf
  module Rpc
    class ServiceDirectory
      include ::Singleton
      include ::Protobuf::Logger::LogMethods

      DEFAULT_ADDRESS = "255.255.255.255"
      DEFAULT_PORT = 53000
      DEFAULT_TIMEOUT = 1

      class Listing < Delegator
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

        def ttl
          [super.to_i, 3].max
        end

        def __getobj__
          @server
        end
      end

      # Class Methods
      #
      class << self
        attr_writer :address, :port
      end

      def self.address
        @address ||= DEFAULT_ADDRESS
      end

      def self.port
        @port ||= DEFAULT_PORT
      end

      def self.start
        yield(self) if block_given?
        self.instance.start
      end

      def self.stop
        self.instance.stop
      end

      # Instance Methods
      #
      def initialize
        @listings = {}
        @mutex = Mutex.new
      end

      def add_listing_for(server)
        if server && server.uuid

          log_debug do
            action = @listings[server.uuid] ? "Updating" : "Adding";
            sign_message("#{action} server: #{server.inspect}")
          end

          @mutex.synchronize do
            @listings[server.uuid] = Listing.new(server)
          end

        else
          log_info { sign_message("Cannot add server without uuid: #{server.inspect}") }
        end
      end

      def lookup(service)
        @mutex.synchronize do
          listings = @listings.values.select do |listing|
            listing.services.any? do |listed_service|
              listing.current? && listed_service == service.to_s
            end
          end

          listings.sample
        end
      end

      def remove_expired_listings
        @mutex.synchronize do
          @listings.delete_if do |uuid, listing|
            listing.expired?
          end
        end
      end

      def remove_listing_for(server)
        if server && server.uuid
          log_debug { sign_message("Removing server: #{server.inspect}") }

          @mutex.synchronize do
            @listings.delete(server.uuid)
          end

        else
          log_info { sign_message("Cannot remove server without uuid: #{server.inspect}") }
        end
      end

      def restart
        stop
        start
      end

      def running?
        !!@thread.try(:alive?)
      end

      def start
        unless running?
          init_socket
          log_info { sign_message("listening to udp://#{self.class.address}:#{self.class.port}") }
          @thread = Thread.new { self.send(:run) }
        end

        self
      end

      def stop
        log_info { sign_message("Stopping directory") }

        @mutex.synchronize do
          @thread.try(:kill)
          @thread = nil
          @listings = {}
        end

        @socket.try(:close)
        @socket = nil
      end

      def wait_for(service, timeout = DEFAULT_TIMEOUT)
        log_debug { sign_message("waiting for #{service}") }
        Timeout.timeout(timeout) do
          sleep(timeout / 10.0) until listing = lookup(service)
          listing
        end
      rescue
        log_info { sign_message("no listing found for #{service}") }
        nil
      end

      private

      def init_socket
        @socket = UDPSocket.new
        @socket.setsockopt(::Socket::SOL_SOCKET, ::Socket::SO_REUSEADDR, true)
        @socket.bind(self.class.address, self.class.port.to_i)
      end

      def run
        begin
          data, addr = @socket.recvfrom(2048)
          beacon = ::Protobuf::Rpc::DynamicDiscovery::Beacon.new
          beacon.parse_from_string(data) rescue nil

          # Favor the address captured by the socket
          beacon.try(:server).try(:address=, addr[3])

          case beacon.beacon_type
          when ::Protobuf::Rpc::DynamicDiscovery::BeaconType::HEARTBEAT
            add_listing_for(beacon.server)
          when ::Protobuf::Rpc::DynamicDiscovery::BeaconType::FLATLINE
            remove_listing_for(beacon.server)
          end

          remove_expired_listings
        rescue => e
          log_debug { sign_message("error: (#{e.class}) #{e.message}") }
        end while true
      end
    end
  end
end
