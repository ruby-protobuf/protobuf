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
        def initialize(options = {})
          host = options[:host]
          port = options[:port]

          @zmq_context = ::ZMQ::Context.new
          @socket = @zmq_context.socket(::ZMQ::REQ)
          zmq_error_check(@socket.connect("tcp://#{resolve_ip(host)}:#{port}"), :socket_connect)

          @poller = ::ZMQ::Poller.new
          @poller.register(@socket, ::ZMQ::POLLIN)

          # Send request to broker telling it we are ready
          zmq_error_check(@socket.send_string(::Protobuf::Rpc::Zmq::WORKER_READY_MESSAGE), :socket_send_string)
        end

        ##
        # Instance Methods
        #
        def handle_request(socket)
          message_array = []
          zmq_error_check(socket.recv_strings(message_array), :socket_recv_strings)

          @request_data = message_array[2]
          @client_address = message_array[0]
          log_debug { sign_message("handling request") } unless @request_data.nil?
        end

        def run
          while ::Protobuf::Rpc::Zmq::Server.running? do
            # poll for 1_000 milliseconds then continue looping
            # This lets us see whether we need to die
            @poller.poll(1_000)
            @poller.readables.each do |socket|
              initialize_request!
              handle_request(socket)
              handle_client unless @request_data.nil?
            end
          end
        ensure
          @socket.close
          @zmq_context.terminate
        end

        def send_data
          response_data = @response.serialize_to_string

          response_message_set = [
            @client_address, # client uuid address
            "",
            response_data
          ]

          @stats.response_size = response_data.size
          zmq_error_check(@socket.send_strings(response_message_set), :socket_send_strings)
        end
      end

    end
  end
end
