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
        def initialize(broker)
          @zmq_context = broker.context
          @socket = @zmq_context.socket(::ZMQ::REP)

          zmq_error_check(@socket.connect(broker.backend_addr))

          @poller = ::ZMQ::Poller.new
          @poller.register(@socket, ::ZMQ::POLLIN)
        end

        ##
        # Instance Methods
        #
        def handle_request(socket)
          zmq_error_check(socket.recv_strings(@request_data = ""))
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
          @poller.deregister_readable(@socket)
          @socket.close
        end

        def send_data
          response_data = @response.to_s # to_s is aliases as serialize_to_string in Message

          @stats.response_size = response_data.size
          zmq_error_check(@socket.send_string(response_data))
        end
      end

    end
  end
end
