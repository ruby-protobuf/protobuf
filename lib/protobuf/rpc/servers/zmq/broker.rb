require 'thread'

module Protobuf
  module Rpc
    module Zmq
      class Broker
        include ::Protobuf::Rpc::Zmq::Util

        attr_reader :local_queue

        def initialize(server)
          @server = server

          init_zmq_context
          init_local_queue
          init_backend_socket
          init_frontend_socket
          init_poller
        rescue
          teardown
          raise
        end

        def run
          @idle_workers = []

          loop do
            process_local_queue
            rc = @poller.poll(500)

            # The server was shutdown and no requests are pending
            break if rc == 0 && !running?
            # Something went wrong
            break if rc == -1

            process_backend if @poller.readables.include?(@backend_socket)
            process_local_queue # Fair ordering so queued requests get in before new requests
            process_frontend if @poller.readables.include?(@frontend_socket)
          end
        ensure
          teardown
        end

        def running?
          @server.running? || @server.workers.any?
        end

        private

        def init_backend_socket
          @backend_socket = @zmq_context.socket(ZMQ::ROUTER)
          zmq_error_check(@backend_socket.bind(@server.backend_uri))
        end

        def init_frontend_socket
          @frontend_socket = @zmq_context.socket(ZMQ::ROUTER)
          zmq_error_check(@frontend_socket.bind(@server.frontend_uri))
        end

        def init_local_queue
          @local_queue = []
        end

        def init_poller
          @poller = ZMQ::Poller.new
          @poller.register_readable(@frontend_socket)
          @poller.register_readable(@backend_socket)
        end

        def init_zmq_context
          if inproc?
            @zmq_context = @server.zmq_context
          else
            @zmq_context = ZMQ::Context.new
          end
        end

        def inproc?
          !!@server.try(:inproc?)
        end

        def local_queue_max_size
          @local_queue_max_size ||= [ENV["PB_ZMQ_SERVER_QUEUE_MAX_SIZE"].to_i, 5].max
        end

        def process_backend
          worker, ignore, *frames = read_from_backend

          @idle_workers << worker

          unless frames == [::Protobuf::Rpc::Zmq::WORKER_READY_MESSAGE]
            write_to_frontend(frames)
          end
        end

        def process_frontend
          address, _, message, *frames = read_from_frontend

          if message == ::Protobuf::Rpc::Zmq::CHECK_AVAILABLE_MESSAGE
            if local_queue.size < local_queue_max_size
              write_to_frontend([address, ::Protobuf::Rpc::Zmq::EMPTY_STRING, ::Protobuf::Rpc::Zmq::WORKERS_AVAILABLE])
            else
              write_to_frontend([address, ::Protobuf::Rpc::Zmq::EMPTY_STRING, ::Protobuf::Rpc::Zmq::NO_WORKERS_AVAILABLE])
            end
          else
            if @idle_workers.empty?
              local_queue << [address, ::Protobuf::Rpc::Zmq::EMPTY_STRING, message ].concat(frames)
            else
              write_to_backend([@idle_workers.shift, ::Protobuf::Rpc::Zmq::EMPTY_STRING].concat([address, ::Protobuf::Rpc::Zmq::EMPTY_STRING, message ]).concat(frames))
            end
          end
        end

        def process_local_queue
          return if local_queue.empty?
          return if @idle_workers.empty?

          write_to_backend([@idle_workers.shift, ::Protobuf::Rpc::Zmq::EMPTY_STRING].concat(local_queue.shift))
          process_local_queue
        end

        def read_from_backend
          frames = []
          zmq_error_check(@backend_socket.recv_strings(frames))
          frames
        end

        def read_from_frontend
          frames = []
          zmq_error_check(@frontend_socket.recv_strings(frames))
          frames
        end

        def teardown
          @frontend_socket.try(:close)
          @backend_socket.try(:close)
          @zmq_context.try(:terminate)
        end

        def write_to_backend(frames)
          zmq_error_check(@backend_socket.send_strings(frames))
        end

        def write_to_frontend(frames)
          zmq_error_check(@frontend_socket.send_strings(frames))
        end
      end
    end
  end
end
