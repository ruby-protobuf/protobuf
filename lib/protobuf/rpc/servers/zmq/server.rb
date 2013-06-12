require 'protobuf/rpc/servers/zmq/util'
require 'protobuf/rpc/servers/zmq/worker'
require 'protobuf/rpc/servers/zmq/broker'
require 'protobuf/rpc/dynamic_discovery.pb'
require 'securerandom'

module Protobuf
  module Rpc
    module Zmq
      class Server
        include ::Protobuf::Rpc::Zmq::Util

        DEFAULT_OPTIONS = {
          :beacon_interval => 5,
          :broadcast_beacons => false
        }

        attr_accessor :options

        def initialize(options)
          @options = DEFAULT_OPTIONS.merge(options)
          @workers = []

          init_zmq_context
          init_beacon_socket if broadcast_beacons?
          init_shutdown_socket
        rescue
          teardown
          raise
        end

        def backend_ip
          frontend_ip
        end

        def backend_port
          options[:worker_port] || frontend_port + 1
        end

        def backend_uri
          "tcp://#{backend_ip}:#{backend_port}"
        end

        def beacon_interval
          [options[:beacon_interval].to_i, 1].max
        end

        def beacon_ip
          unless @beacon_ip
            unless address = options[:beacon_address]
              address = ::Protobuf::Rpc::ServiceDirectory.address
            end

            @beacon_ip = resolve_ip(address)
          end

          @beacon_ip
        end

        def beacon_port
          unless @beacon_port
            unless port = options[:beacon_port]
              port = ::Protobuf::Rpc::ServiceDirectory.port
            end

            @beacon_port = port.to_i
          end

          @beacon_port
        end

        def beacon_uri
          "udp://#{beacon_ip}:#{beacon_port}"
        end

        def broadcast_beacons?
          !brokerless? && options[:broadcast_beacons]
        end

        def broadcast_flatline
          flatline = ::Protobuf::Rpc::DynamicDiscovery::Beacon.new(
            :beacon_type => ::Protobuf::Rpc::DynamicDiscovery::BeaconType::FLATLINE,
            :server => self.to_proto
          )

          @beacon_socket.send flatline.serialize_to_string, 0
        end

        def broadcast_heartbeat
          @last_beacon = Time.now.to_i

          heartbeat = ::Protobuf::Rpc::DynamicDiscovery::Beacon.new(
            :beacon_type => ::Protobuf::Rpc::DynamicDiscovery::BeaconType::HEARTBEAT,
            :server => self.to_proto
          )

          @beacon_socket.send(heartbeat.serialize_to_string, 0)

          log_debug { sign_message("sent heartbeat to #{beacon_uri}") }
        end

        def broadcast_heartbeat?
          Time.now.to_i >= next_beacon && broadcast_beacons?
        end

        def brokerless?
          !!options[:workers_only]
        end

        def frontend_ip
          @frontend_ip ||= resolve_ip(options[:host])
        end

        def frontend_port
          options[:port]
        end

        def frontend_uri
          "tcp://#{frontend_ip}:#{frontend_port}"
        end

        def maintenance_timeout
          1_000 * (next_maintenance - Time.now.to_i)
        end

        def next_maintenance
          cycles = [next_reaping]
          cycles << next_beacon if broadcast_beacons?

          cycles.min
        end

        def minimum_timeout
          100
        end

        def next_beacon
          if @last_beacon.nil?
            0
          else
            @last_beacon + beacon_interval
          end
        end

        def next_reaping
          if @last_reaping.nil?
            0
          else
            @last_reaping + reaping_interval
          end
        end

        def reap_dead_workers
          @last_reaping = Time.now.to_i

          @workers.keep_if do |worker|
            worker.alive? or worker.join && false
          end
        end

        def reap_dead_workers?
          Time.now.to_i >= next_reaping
        end

        def reaping_interval
          5
        end

        def run
          @running = true

          start_broker unless brokerless?
          start_missing_workers
          wait_for_shutdown_signal
          broadcast_flatline if broadcast_beacons?
          stop_workers
          stop_broker unless brokerless?
        ensure
          @running = false
          teardown
        end

        def running?
          !!@running
        end

        def shutdown_uri
          "inproc://#{object_id}"
        end

        def signal_shutdown
          socket = @zmq_context.socket ZMQ::PAIR
          zmq_error_check(socket.connect shutdown_uri)
          zmq_error_check(socket.send_string ".")
          zmq_error_check(socket.close)
        end

        def start_broker
          @broker = ::Protobuf::Rpc::Zmq::Broker.new(self).start
        end

        def start_missing_workers
          missing_workers = total_workers - @workers.size

          if missing_workers > 0
            missing_workers.times { start_worker }
            log_debug { sign_message("#{total_workers} workers started") }
          end
        end

        def start_worker
          @workers << ::Protobuf::Rpc::Zmq::Worker.new(self).start
        end

        def stop
          signal_shutdown
        end

        def stop_broker
          @broker.signal_shutdown
          @broker.join
        end

        def stop_workers
          @workers.each(&:signal_shutdown)
          Thread.pass until reap_dead_workers.empty?
        end

        def teardown
          @shutdown_socket.try(:close)
          @beacon_socket.try(:close)
          @zmq_context.try(:terminate)
          @last_reaping = @last_beacon = @timeout = nil
        end

        def total_workers
          @total_workers ||= [@options[:threads].to_i, 1].max
        end

        def timeout
          if @timeout.nil?
            @timeout = 0
          else
            @timeout = [minimum_timeout, maintenance_timeout].max
          end
        end

        def to_proto
          @proto ||= ::Protobuf::Rpc::DynamicDiscovery::Server.new(
            :uuid => uuid,
            :address => frontend_ip,
            :port => frontend_port.to_s,
            :ttl => (beacon_interval * 1.5).ceil,
            :services => ::Protobuf::Rpc::Service.implemented_services
          )
        end

        def uuid
          @uuid ||= SecureRandom.uuid
        end

        def wait_for_shutdown_signal
          poller = ZMQ::Poller.new
          poller.register_readable(@shutdown_socket)

          # If the poller returns 1, a shutdown signal has been received.
          # If the poller returns -1, something went wrong.
          while poller.poll(timeout) === 0
            if reap_dead_workers?
              reap_dead_workers
              start_missing_workers
            end

            broadcast_heartbeat if broadcast_heartbeat?
          end
        end

        private

        def init_beacon_socket
          @beacon_socket = UDPSocket.new
          @beacon_socket.setsockopt(::Socket::SOL_SOCKET, ::Socket::SO_BROADCAST, true)
          @beacon_socket.connect(beacon_ip, beacon_port)
        end

        def init_shutdown_socket
          @shutdown_socket = @zmq_context.socket(ZMQ::PAIR)
          zmq_error_check(@shutdown_socket.bind shutdown_uri)
        end

        def init_zmq_context
          @zmq_context = ZMQ::Context.new
        end
      end
    end
  end
end
