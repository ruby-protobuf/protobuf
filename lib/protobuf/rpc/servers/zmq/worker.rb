require 'protobuf/rpc/server'
require 'protobuf/rpc/servers/zmq/util'

module Protobuf
  module Rpc
    module Zmq
      class Worker
        include ::Protobuf::Rpc::Server
        include ::Protobuf::Rpc::Zmq::Util

        attr_reader :thread

        ##
        # Constructor
        #
        def initialize(server)
          @server = server
          init_zmq_context
          init_backend_socket
          init_shutdown_socket
        end

        ##
        # Instance Methods
        #
        def handle_request(socket)
          zmq_error_check(socket.recv_strings(frames = []))

          @client_address, empty, @request_data = *frames

          unless @request_data.nil?
            log_debug { sign_message("handling request") }
            handle_client
          end
        end

        def run
          running = true
          poller = ::ZMQ::Poller.new

          poller.register_readable(@backend_socket)
          poller.register_readable(@shutdown_socket)

          # Send request to broker telling it we are ready
          zmq_error_check(@backend_socket.send_string(::Protobuf::Rpc::Zmq::WORKER_READY_MESSAGE))

          while poller.poll > 0
            poller.readables.each do |readable|
              if readable === @backend_socket
                initialize_request!
                handle_request(@backend_socket)
              elsif readable === @shutdown_socket
                running = false
              end
            end

            break unless running
          end
        ensure
          teardown
        end

        def send_data
          response_data = @response.to_s # to_s is aliases as serialize_to_string in Message

          frames = [@client_address, "", response_data]

          @stats.response_size = response_data.size

          zmq_error_check(@backend_socket.send_strings(frames))
        end

        def shutdown_uri
          "inproc://#{object_id}"
        end

        def signal_shutdown
          socket = @zmq_context.socket ZMQ::PAIR
          zmq_error_check(socket.connect shutdown_uri)
          zmq_error_check(socket.send_string "shutdown")
          zmq_error_check(socket.close)
        end

        def start
          @thread = Thread.new do
            begin
              self.run
            rescue => e
              message = "Worker failed: #{e.inspect}\n #{e.backtrace.join($/)}"
              $stderr.puts message
              log_error { message }
            end
          end

          self
        end

        def teardown
          @backend_socket.try :close
          @shutdown_socket.try :close
          @zmq_context.try :terminate
        end

        private

        def init_zmq_context
          @zmq_context = ZMQ::Context.new
        end

        def init_backend_socket
          @backend_socket = @zmq_context.socket ZMQ::REQ
          zmq_error_check(@backend_socket.connect @server.backend_uri)
        end

        def init_shutdown_socket
          @shutdown_socket = @zmq_context.socket ZMQ::PAIR
          zmq_error_check(@shutdown_socket.bind shutdown_uri)
        end
      end
    end
  end
end
