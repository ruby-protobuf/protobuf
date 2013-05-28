
module Protobuf
  module Rpc
    module Zmq
      class Broker
        include ::Protobuf::Rpc::Zmq::Util

        attr_reader :server

        def initialize(server)
          @server = server

          init_zmq_context
          init_backend_socket
          init_frontend_socket
          init_shutdown_socket
          init_poller
        end

        def join
          @thread.try :join
        end

        def minimum_timeout
          100
        end

        def run
          idle_workers = []

          catch(:shutdown) do
            while @poller.poll > 0
              @poller.readables.each do |readable|
                case readable
                when @frontend_socket
                  if idle_workers.any?
                    @frontend_socket.recv_strings frames = []
                    @backend_socket.send_strings [idle_workers.shift, ""] + frames
                  end
                when @backend_socket
                  @backend_socket.recv_strings frames = []
                  idle_workers << frames.shift(2)[0]
                  unless frames == [::Protobuf::Rpc::Zmq::WORKER_READY_MESSAGE]
                    @frontend_socket.send_strings frames
                  end
                when @shutdown_socket
                  throw :shutdown
                end
              end
            end
          end

          teardown
        end

        def start
          log_debug { sign_message("starting broker") }

          @thread = Thread.new do
            self.run
          end

          self
        end

        def shutdown_uri
          "inproc://#{object_id}"
        end

        def signal_shutdown
          socket = @zmq_context.socket ZMQ::PAIR
          zmq_error_check(socket.connect shutdown_uri)
          zmq_error_check(socket.send_string "")
          zmq_error_check(socket.close)
        end

        def teardown
          @frontend_socket.close
          @backend_socket.close
          @shutdown_socket.close
          @zmq_context.terminate
        end

        private

        def init_backend_socket
          @backend_socket = @zmq_context.socket ZMQ::ROUTER
          zmq_error_check(@backend_socket.bind server.backend_uri)
        end

        def init_frontend_socket
          @frontend_socket = @zmq_context.socket ZMQ::ROUTER
          zmq_error_check(@frontend_socket.bind server.frontend_uri)
        end

        def init_poller
          @poller = ZMQ::Poller.new
          @poller.register_readable @frontend_socket
          @poller.register_readable @backend_socket
          @poller.register_readable @shutdown_socket
        end

        def init_shutdown_socket
          @shutdown_socket = @zmq_context.socket ZMQ::PAIR
          zmq_error_check(@shutdown_socket.bind shutdown_uri)
        end

        def init_zmq_context
          @zmq_context = ZMQ::Context.new
        end
      end
    end
  end
end
