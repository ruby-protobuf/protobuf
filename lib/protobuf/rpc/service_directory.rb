require 'delegate'
require 'singleton'
require 'socket'
require 'set'
require 'thread'
require 'timeout'

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
          update(server)
        end

        def current?
          !expired?
        end

        def eql?(other)
          uuid.eql?(other.uuid)
        end

        def expired?
          Time.now.to_i >= @expires_at
        end

        def hash
          uuid.hash
        end

        def ttl
          [super.to_i, 1].max
        end

        def update(server)
          @server = server
          @expires_at = Time.now.to_i + ttl
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

      #
      # Instance Methods
      #
      def initialize
        reset
      end

      def all_listings_for(service)
        if running? && @listings_by_service.key?(service.to_s)
          @listings_by_service[service.to_s].entries.shuffle
        else
          []
        end
      end

      def each_listing(&block)
        @listings_by_uuid.each_value(&block)
      end

      def lookup(service)
        if running?
          if @listings_by_service.key?(service.to_s)
            @listings_by_service[service.to_s].entries.sample
          end
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

        @thread.try(:kill).try(:join)
        @socket.try(:close)

        reset
      end

      private

      def add_or_update_listing(uuid, server)
        listing = @listings_by_uuid[uuid]

        if listing
          action = :updated
          listing.update(server)
        else
          action = :added
          listing = Listing.new(server)
          @listings_by_uuid[uuid] = listing
        end

        listing.services.each do |service|
          @listings_by_service[service] << listing
        end

        trigger(action, listing)
        log_debug { sign_message("#{action} server: #{server.inspect}") }
      end

      def init_socket
        @socket = UDPSocket.new
        @socket.setsockopt(::Socket::SOL_SOCKET, ::Socket::SO_REUSEADDR, true)

        if defined?(::Socket::SO_REUSEPORT)
          @socket.setsockopt(::Socket::SOL_SOCKET, ::Socket::SO_REUSEPORT, true)
        end

        @socket.bind(self.class.address, self.class.port.to_i)
      end

      def process_beacon(beacon)
        server = beacon.server
        uuid = server.try(:uuid)

        if server && uuid
          case beacon.beacon_type
          when ::Protobuf::Rpc::DynamicDiscovery::BeaconType::HEARTBEAT
            add_or_update_listing(uuid, server)
          when ::Protobuf::Rpc::DynamicDiscovery::BeaconType::FLATLINE
            remove_listing(uuid)
          end
        else
          log_info { sign_message("Ignoring incomplete beacon: #{beacon.inspect}") }
        end
      end

      def read_beacon
        data, addr = @socket.recvfrom(2048)

        beacon = ::Protobuf::Rpc::DynamicDiscovery::Beacon.decode(data)

        # Favor the address captured by the socket
        beacon.try(:server).try(:address=, addr[3])

        beacon
      end

      def remove_expired_listings
        log_debug { sign_message("Removing expired listings") }
        @listings_by_uuid.each do |uuid, listing|
          remove_listing(uuid) if listing.expired?
        end
      end

      def remove_listing(uuid)
        listing = @listings_by_uuid[uuid] or return

        log_debug { sign_message("Removing listing: #{listing.inspect}") }

        @listings_by_service.each do |service, listings|
          listings.delete(listing)
        end

        trigger(:removed, @listings_by_uuid.delete(uuid))
      end

      def reset
        @thread = nil
        @socket = nil
        @listings_by_uuid = {}
        @listings_by_service = Hash.new { |h, k| h[k] = Set.new }
      end

      def run
        sweep_interval = 1 # sweep expired listings every 1 second
        next_sweep = Time.now.to_i + sweep_interval

        loop do
          timeout = [next_sweep - Time.now.to_i, 0.1].max
          readable = IO.select([@socket], nil, nil, timeout)
          process_beacon(read_beacon) if readable

          if Time.now.to_i >= next_sweep
            remove_expired_listings
            next_sweep = Time.now.to_i + sweep_interval
          end
        end
      rescue => e
        log_debug { sign_message("ERROR: (#{e.class}) #{e.message}\n#{e.backtrace.join("\n")}") }
        retry
      end

      def trigger(action, listing)
        ::ActiveSupport::Notifications.instrument("directory.listing.#{action}", :listing => listing)
      end
    end
  end
end
