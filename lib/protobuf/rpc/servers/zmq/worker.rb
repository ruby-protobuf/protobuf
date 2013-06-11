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
          init_shutdown_socket
        rescue
          teardown
          raise
        end

        ##
        # Instance Methods
        #
        def alive?
          @thread.try(:alive?) || false
        end

        def join
          @thread.try(:join)
        end

        def process_request
          @client_address, empty, @request_data = read_from_backend

          unless @request_data.nil?
            log_debug { sign_message("handling request") }
            handle_client
          end
        end

        def read_from_backend
          [].tap do |frames|
            zmq_error_check(@backend_socket.recv_strings(frames))
          end
        end

        def run
          poller = ::ZMQ::Poller.new
          poller.register_readable(@backend_socket)
          poller.register_readable(@shutdown_socket)

          # Send request to broker telling it we are ready
          write_to_backend([::Protobuf::Rpc::Zmq::WORKER_READY_MESSAGE])

          catch(:shutdown) do
            while poller.poll > 0
              poller.readables.each do |readable|
                case readable
                when @backend_socket
                  initialize_request!
                  process_request
                when @shutdown_socket
                  throw :shutdown
                end
              end
            end
          end
        ensure
          teardown
        end

        def send_data
          data = @response.serialize_to_string

          @stats.response_size = data.size

          write_to_backend([@client_address, "", data])
        end

        def shutdown_uri
          "inproc://#{object_id}"
        end

        def signal_shutdown
          socket = @zmq_context.socket ZMQ::PAIR
          zmq_error_check(socket.connect(shutdown_uri))
          zmq_error_check(socket.send_string("."))
          zmq_error_check(socket.close)
        end

        def start
          @thread = Thread.new do
            begin
              self.run
            rescue => e
              message = "Worker failed: #{e.inspect}\n #{e.backtrace.join($/)}"
              $stderr.puts(message)
              log_error { message }
            end
          end

          self
        end

        def teardown
          @backend_socket.try(:close)
          @shutdown_socket.try(:close)
          @zmq_context.try(:terminate)
        end

        def write_to_backend(frames)
          zmq_error_check(@backend_socket.send_strings(frames))
        end

        private

        def init_zmq_context
          @zmq_context = ZMQ::Context.new
        end

        def init_backend_socket
          @backend_socket = @zmq_context.socket(ZMQ::REQ)
          zmq_error_check(@backend_socket.connect(@server.backend_uri))
        end

        def init_shutdown_socket
          @shutdown_socket = @zmq_context.socket(ZMQ::PAIR)
          zmq_error_check(@shutdown_socket.bind(shutdown_uri))
        end
      end
    end
  end
end
