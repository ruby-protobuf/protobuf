require 'protobuf/rpc/server'
require 'protobuf/rpc/servers/zmq/util'

module Protobuf
  module Rpc
    module Zmq
      class Worker
        include ::Protobuf::Rpc::Server
        include ::Protobuf::Rpc::Zmq::Util

        ##
        # Constructor
        #
        def initialize(server)
          @server = server

          init_zmq_context
          init_backend_socket
        rescue
          teardown
          raise
        end

        ##
        # Instance Methods
        #
        def process_request
          @client_address, _, @request_data = read_from_backend

          unless @request_data.nil?
            log_debug { sign_message("handling request") }
            handle_client
          end
        end

        def run
          poller = ::ZMQ::Poller.new
          poller.register_readable(@backend_socket)
          poller.register_readable(@shutdown_socket)

          # Send request to broker telling it we are ready
          write_to_backend([::Protobuf::Rpc::Zmq::WORKER_READY_MESSAGE])

          loop do
            rc = poller.poll(500)

            # The server was shutdown and no requests are pending
            break if rc == 0 && !running?

            # Something went wrong
            break if rc == -1

            if rc > 0
              ::Thread.current.thread_variable_set(:busy, true)
              initialize_request!
              process_request
              ::Thread.current.thread_variable_set(:busy, false)
            end
          end
        ensure
          teardown
        end

        def running?
          @server.running?
        end

        def send_data
          data = @response.encode

          @stats.response_size = data.size

          write_to_backend([@client_address, "", data])
        end

        private

        def init_zmq_context
          @zmq_context = ZMQ::Context.new
        end

        def init_backend_socket
          @backend_socket = @zmq_context.socket(ZMQ::REQ)
          zmq_error_check(@backend_socket.connect(@server.backend_uri))
        end

        def read_from_backend
          frames = []
          zmq_error_check(@backend_socket.recv_strings(frames))
          frames
        end

        def teardown
          @backend_socket.try(:close)
          @zmq_context.try(:terminate)
        end

        def write_to_backend(frames)
          zmq_error_check(@backend_socket.send_strings(frames))
        end
      end
    end
  end
end
