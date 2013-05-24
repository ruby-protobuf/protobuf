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
          init_socket
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
          poller = ::ZMQ::Poller.new
          poller.register(@socket, ::ZMQ::POLLIN)

          # Send request to broker telling it we are ready
          zmq_error_check(@socket.send_string(::Protobuf::Rpc::Zmq::WORKER_READY_MESSAGE))

          # poll for 1 second then continue looping
          # This lets us see whether we need to die
          while @server.running? && poller.poll(1_000) >= 0
            poller.readables.each do |socket|
              initialize_request!
              handle_request(socket)
            end
          end
        ensure
          @socket.close
          @zmq_context.terminate
        end

        def send_data
          response_data = @response.to_s # to_s is aliases as serialize_to_string in Message

          response_message_set = [
            @client_address, # client uuid address
            "",
            response_data
          ]

          @stats.response_size = response_data.size
          zmq_error_check(@socket.send_strings(response_message_set))
        end

        private

        def init_zmq_context
          @zmq_context = ZMQ::Context.new
        end

        def init_socket
          @socket = @zmq_context.socket ZMQ::REQ
          zmq_error_check(@socket.connect @server.backend_uri)
        end
      end
    end
  end
end
