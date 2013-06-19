
module Protobuf
  module Rpc
    module Zmq
      class Broker
        include ::Protobuf::Rpc::Zmq::Util

        def initialize(server)
          @server = server

          init_zmq_context
          init_backend_socket
          init_frontend_socket
          init_shutdown_socket
          init_poller
        rescue
          teardown
          raise
        end

        def join
          @thread.try(:join)
        end

        def run
          @idle_workers = []

          catch(:shutdown) do
            while @poller.poll > 0
              @poller.readables.each do |readable|
                case readable
                when @frontend_socket
                  process_frontend
                when @backend_socket
                  process_backend
                when @shutdown_socket
                  throw :shutdown
                end
              end
            end
          end
        ensure
          teardown
        end

        def start
          log_debug { sign_message("starting broker") }

          @thread = Thread.new { self.run }

          self
        end

        def shutdown_uri
          "inproc://#{object_id}"
        end

        def signal_shutdown
          socket = @zmq_context.socket(ZMQ::PAIR)
          zmq_error_check(socket.connect(shutdown_uri))
          zmq_error_check(socket.send_string ".")
          zmq_error_check(socket.close)
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

        def init_poller
          @poller = ZMQ::Poller.new
          @poller.register_readable(@frontend_socket)
          @poller.register_readable(@backend_socket)
          @poller.register_readable(@shutdown_socket)
        end

        def init_shutdown_socket
          @shutdown_socket = @zmq_context.socket(ZMQ::PAIR)
          zmq_error_check(@shutdown_socket.bind(shutdown_uri))
        end

        def init_zmq_context
          @zmq_context = ZMQ::Context.new
        end

        def process_backend
          worker, ignore, *frames = read_from_backend

          @idle_workers << worker

          unless frames == [::Protobuf::Rpc::Zmq::WORKER_READY_MESSAGE]
            write_to_frontend(frames)
          end
        end

        def process_frontend
          if @idle_workers.any?
            frames = read_from_frontend
            write_to_backend([@idle_workers.shift, ""] + frames)
          end
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
          @shutdown_socket.try(:close)
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
