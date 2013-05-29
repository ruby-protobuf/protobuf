require 'protobuf/rpc/servers/zmq/util'
require 'protobuf/rpc/servers/zmq/worker'
require 'protobuf/rpc/servers/zmq/broker'
require 'protobuf/rpc/dynamic_discovery.pb'
require 'securerandom'

STDOUT.sync = true

module Protobuf
  module Rpc
    module Zmq
      class Server
        include ::Protobuf::Rpc::Zmq::Util

        attr_accessor :options, :workers, :zmq_context

        def initialize(options)
          @options = default_options.merge(options)
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
          options[:worker_port]
        end

        def backend_uri
          "tcp://#{backend_ip}:#{backend_port}"
        end

        def beacon_interval
          [options[:beacon_interval].to_i, 1].max
        end

        def beacon_ip
          "255.255.255.255"
        end

        def beacon_port
          options[:beacon_port].to_i
        end

        def broadcast_beacons?
          !brokerless? && options[:dynamic_discovery]
        end

        def broadcast_flatline
          flatline = ::Protobuf::DynamicDiscovery::Beacon.new(
            :beacon_type => ::Protobuf::DynamicDiscovery::BeaconType::FLATLINE,
            :uuid => uuid,
            :address => frontend_ip,
            :port => frontend_port.to_s
          )

          @beacon_socket.send flatline.to_s, 0
        end

        def broadcast_heartbeat
          services = ::Protobuf::Rpc::Service.services
          heartbeat = ::Protobuf::DynamicDiscovery::Beacon.new(
            :beacon_type => ::Protobuf::DynamicDiscovery::BeaconType::HEARTBEAT,
            :uuid => uuid,
            :address => frontend_ip,
            :port => frontend_port.to_s,
            :ttl => beacon_interval * 3,
            :service_classes => services.map(&:name)
          )

          @beacon_socket.send heartbeat.to_s, 0
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

        def maintenance_interval
          [reaping_interval, beacon_interval].min
        end

        def minimum_timeout
          100
        end

        def reap_dead_workers
          @workers.keep_if do |worker|
            worker.alive? or worker.join && false
          end
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
          zmq_error_check(socket.send_string "blargh!")
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
          @workers.each &:signal_shutdown
          Thread.pass until reap_dead_workers.empty?
        end

        def teardown
          @shutdown_socket.try :close
          @beacon_socket.try :close
          @zmq_context.try :terminate
        end

        def total_workers
          @total_workers ||= @options[:threads]
        end

        def uuid
          @uuid ||= SecureRandom.uuid
        end

        def wait_for_shutdown_signal
          time = Time.now.to_i
          timeout = 0
          next_beacon = 0
          next_reaping = time + reaping_interval
          next_cycle = time + maintenance_interval
          poller = ZMQ::Poller.new

          poller.register_readable @shutdown_socket

          while poller.poll(timeout) >= 0
            break if poller.readables.any?

            time = Time.now.to_i

            if time >= next_reaping
              reap_dead_workers
              start_missing_workers
              next_reaping = time + reaping_interval
              next_cycle = [next_cycle, next_reaping].min
            end

            if broadcast_beacons? && time >= next_beacon
              broadcast_heartbeat
              next_beacon = time + beacon_interval
              next_cycle = [next_cycle, next_beacon].min
            end

            timeout = [minimum_timeout, 1000 * (next_cycle - time)].max
          end
        end

        private

        def default_options
          { :beacon_interval => 5  }
        end

        def init_beacon_socket
          @beacon_socket = UDPSocket.new
          @beacon_socket.setsockopt :SOCKET, :BROADCAST, true
          @beacon_socket.connect beacon_ip, beacon_port
        end

        def init_shutdown_socket
          @shutdown_socket = @zmq_context.socket ZMQ::PAIR
          @shutdown_socket.bind shutdown_uri
        end

        def init_zmq_context
          @zmq_context = ZMQ::Context.new
        end
      end
    end
  end
end
