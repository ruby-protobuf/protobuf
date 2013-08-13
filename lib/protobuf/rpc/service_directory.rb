require 'delegate'
require 'singleton'
require 'socket'
require 'thread'
require 'timeout'

require 'protobuf/lifecycle'
require 'protobuf/rpc/dynamic_discovery.pb'

module Protobuf
  module Rpc
    class ServiceDirectory
      include ::Singleton
      include ::Protobuf::Logger::LogMethods

      DEFAULT_ADDRESS = "0.0.0.0"
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
          @mutex.synchronize do
            action = @listings.key?(server.uuid) ? :updated : :added
            log_debug { sign_message("#{action} server: #{server.inspect}") }

            listing = Listing.new(server)
            @listings[server.uuid] = listing
            trigger(action, listing)
          end
        else
          log_info { sign_message("Cannot add server without uuid: #{server.inspect}") }
        end
      end

      def each_listing(&block)
        @listings.each_value(&block)
      end

      def lookup(service)
        if running?
          @mutex.synchronize do
            listings = @listings.values.select do |listing|
              listing.services.any? do |listed_service|
                listing.current? && listed_service == service.to_s
              end
            end

            listings.sample
          end
        end
      end

      def remove_expired_listings
        @mutex.synchronize do
          @listings.delete_if do |uuid, listing|
            if listing.expired?
              trigger(:removed, listing)
              true
            else
              false
            end
          end
        end
      end

      def remove_listing_for(server)
        if server && server.uuid
          log_debug { sign_message("Removing server: #{server.inspect}") }

          @mutex.synchronize do
            deleted_listing = @listings.delete(server.uuid)
            trigger(:removed, deleted_listing)
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

      private

      def init_socket
        @socket = UDPSocket.new
        @socket.setsockopt(::Socket::SOL_SOCKET, ::Socket::SO_REUSEADDR, true)

        if defined?(::Socket::SO_REUSEPORT)
          @socket.setsockopt(::Socket::SOL_SOCKET, ::Socket::SO_REUSEPORT, true)
        end

        @socket.bind(self.class.address, self.class.port.to_i)
      end

      def process_beacon(beacon)
        case beacon.beacon_type
        when ::Protobuf::Rpc::DynamicDiscovery::BeaconType::HEARTBEAT
          add_listing_for(beacon.server)
        when ::Protobuf::Rpc::DynamicDiscovery::BeaconType::FLATLINE
          remove_listing_for(beacon.server)
        end
      end

      def run
        loop do
          beacon = wait_for_beacon
          process_beacon(beacon)
          remove_expired_listings
        end
      rescue => e
        log_debug { sign_message("error: (#{e.class}) #{e.message}") }
        retry
      end

      def trigger(action, listing)
        ::Protobuf::Lifecycle.trigger("directory.listing.#{action}", listing)
      end

      def wait_for_beacon
        data, addr = @socket.recvfrom(2048)

        beacon = ::Protobuf::Rpc::DynamicDiscovery::Beacon.new
        beacon.parse_from_string(data)

        # Favor the address captured by the socket
        beacon.try(:server).try(:address=, addr[3])

        beacon
      end
    end
  end
end
