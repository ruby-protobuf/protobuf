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

      DEFAULT_ADDRESS = "0.0.0.0"
      DEFAULT_PORT = 9398
      DEFAULT_TIMEOUT = 5

      ServiceNotFound = Class.new(RuntimeError)

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

        def __getobj__
          @server
        end
      end

      # Class Methods
      #
      class << self
        attr_writer :address, :port, :timeout
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

      def self.timeout
        @timeout ||= DEFAULT_TIMEOUT
      end

      # Instance Methods
      #
      def initialize
        @listings = {}
        @mutex = Mutex.new
      end

      def add_listing_for(server)
        @mutex.synchronize do
          @listings[server.uuid] = Listing.new(server)
        end
      end

      def find(service)
        listing = nil
        log_debug { sign_message("searching for #{service}") }

        Timeout.timeout(self.class.timeout, ServiceNotFound) do
          Thread.pass until listing = random_listing_for(service)
        end

        log_debug { sign_message("found #{service} at #{listing.inspect}") }

        [listing.address, listing.port]
      end

      def listing_count
        @mutex.synchronize do
          @listings.count
        end
      end

      def random_listing_for(service)
        @mutex.synchronize do
          listings = @listings.values.select do |listing|
            listing.services.any? do |listed_service|
              listing.current? && listed_service.to_s == service.to_s
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
        @mutex.synchronize do
          @listings.delete(server.uuid)
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
            add_listing_for(beacon.server)
          when ::Protobuf::Rpc::DynamicDiscovery::BeaconType::FLATLINE
            remove_listing_for(beacon.server)
          end

          remove_expired_listings
        end
      end

      def running?
        !!@thread.try(:alive?)
      end

      def start
        unless running?
          log_debug { sign_message("starting service directory") }

          init_socket

          @thread = Thread.new do
            begin
              self.run
            rescue => e
              log_debug { sign_message("error: (#{e.class}) #{e.message}") }
              raise
            end
          end
        end

        self
      end

      def stop
        @mutex.synchronize do
          @thread.try(:kill)
          @listings = {}
        end

        @socket.try(:close)
      end

      private

      def init_socket
        @socket = UDPSocket.new
        @socket.bind(self.class.address, self.class.port)
      end
    end
  end
end
