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
          host = server.host
          port = server.worker_port

          @zmq_context = ::ZMQ::Context.new
          @socket = @zmq_context.socket(::ZMQ::REQ)
          zmq_error_check(@socket.connect("tcp://#{resolve_ip(host)}:#{port}"))

          @poller = ::ZMQ::Poller.new
          @poller.register(@socket, ::ZMQ::POLLIN)

          # Send request to broker telling it we are ready
          zmq_error_check(@socket.send_string(::Protobuf::Rpc::Zmq::WORKER_READY_MESSAGE))
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
          while @server.running? do
            # poll for 1_000 milliseconds then continue looping
            # This lets us see whether we need to die
            @poller.poll(1_000)
            @poller.readables.each do |socket|
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
      end

    end
  end
end
