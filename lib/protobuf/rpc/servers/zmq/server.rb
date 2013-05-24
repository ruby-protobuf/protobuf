require 'protobuf/rpc/servers/zmq/worker'
require 'protobuf/rpc/servers/zmq/util'

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
          init_backend_socket
          init_frontend_socket unless brokerless?
          init_shutdown_socket
          init_beacon_socket if broadcast_beacons?
        end

        def alive_workers
          @workers.count { |worker| worker.alive? }
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
          # TODO: create a flatline beacon from the proto
          flatline = "flatline"

          @beacon_socket.send flatline, 0
        end

        def broadcast_heartbeat
          # TODO: create a heartbeat beacon from the proto
          heartbeat = "heartbeat"

          @beacon_socket.send heartbeat, 0
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
            worker.alive?
          end
        end

        def reaping_interval
          5
        end

        def run
          @running = true

          start_missing_workers

          brokerless? ? wait_for_shutdown_signal : run_broker

          @workers.each do |t|
            t.join(5) || t.kill
          end

          teardown
        end

        def running?
          !!@running
        end

        def run_broker
          log_debug { sign_message("initializing broker") }

          timeout = 0
          next_beacon = 0
          next_reaping = 0
          next_cycle = Time.now.to_i + maintenance_interval
          poller = ZMQ::Poller.new
          available_workers = []

          poller.register_readable @frontend_socket
          poller.register_readable @backend_socket
          poller.register_readable @shutdown_socket

          while running? || @workers.any?
            poller.poll(timeout)
            poller.readables.each do |readable|
              if readable === @frontend_socket && available_workers.any?
                @frontend_socket.recv_strings frames = []
                @backend_socket.send_strings [available_workers.shift, ""] + frames
              elsif readable === @backend_socket
                @backend_socket.recv_strings frames = []
                available_workers << frames.shift(2)[0]
                unless frames == [::Protobuf::Rpc::Zmq::WORKER_READY_MESSAGE]
                  @frontend_socket.send_strings frames
                end
              elsif readable === @shutdown_socket
                broadcast_flatline if broadcast_beacons?
                poller.deregister_readable @frontend_socket
              end
            end

            if (time = Time.now.to_i) >= next_reaping
              reap_dead_workers
              start_missing_workers if running?
              next_reaping = time + reaping_interval
              next_cycle = [next_cycle, next_reaping].min
            end

            if broadcast_beacons? && time >= next_beacon
              running? ? broadcast_heartbeat : broadcast_flatline
              next_beacon = time + beacon_interval
              next_cycle = [next_cycle, next_beacon].min
            end

            timeout = [minimum_timeout, 1_000 * (next_cycle - time)].max
          end
        end

        def signal_shutdown
          @running = false
          socket = zmq_context.socket ZMQ::PAIR
          zmq_error_check(socket.connect shutdown_uri)
          zmq_error_check(socket.send_string "shutdown")
          zmq_error_check(socket.close)
        end

        def start_missing_workers
          missing_workers = total_workers - @workers.size

          if missing_workers > 0
            missing_workers.times { start_worker }
            log_debug { sign_message("#{total_workers} workers started") }
          end
        end

        def start_worker
          @workers << Thread.new(self) do |server|
            begin
              ::Protobuf::Rpc::Zmq::Worker.new(server).run
            rescue => e
              message = "Worker failed: #{e.inspect}\n #{e.backtrace.join($/)}"
              $stderr.puts message
              log_error { message }
            end
          end
        end

        def shutdown_uri
          "inproc://#{object_id}"
        end

        def stop
          signal_shutdown
        end

        def teardown
          @frontend_socket.try :close
          @backend_socket.try :close
          @shutdown_socket.try :close
          @beacon_socket.try :close
          @zmq_context.terminate
        end

        def total_workers
          @total_workers ||= @options[:threads]
        end

        def wait_for_shutdown_signal
          @shutdown_socket.recv_string shutdown = ""
        end

        private

        def default_options
          { :beacon_interval => 5 }
        end

        def init_backend_socket
          @backend_socket = @zmq_context.socket ZMQ::ROUTER
          zmq_error_check(@backend_socket.bind backend_uri)
        end

        def init_beacon_socket
          @beacon_socket = UDPSocket.new
          @beacon_socket.setsockopt Socket::SOL_SOCKET, Socket::SO_BROADCAST, true
          @beacon_socket.connect beacon_ip, beacon_port
        end

        def init_frontend_socket
          @frontend_socket = @zmq_context.socket ZMQ::ROUTER
          zmq_error_check(@frontend_socket.bind frontend_uri)
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
