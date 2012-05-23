require 'protobuf/rpc/server'
require 'protobuf/rpc/servers/zmq/util'
module Protobuf
  module Rpc
    module Zmq

      class Worker
        include ::Protobuf::Rpc::Server
        include ::Protobuf::Rpc::Zmq::Util

        def initialize
          @zmq_context = ::ZMQ::Context.new
          @poller = ::ZMQ::Poller.new
          @socket = @zmq_context.socket(::ZMQ::REP)
          # needs a unique name that matches the DEALER's name
          zmq_error_check(@socket.connect("ipc://backend.ipc"))
          @poller.register(@socket, ::ZMQ::POLLIN)
        end

        def run
          while(Thread.current[:running])
            # poll for 100 milliseconds then continue looping
            # This lets us see whether we need to die
            @poller.poll(100)
            @poller.readables.each do |socket|
              initialize_buffers
              handle_request(socket)
              handle_client unless(@request_buffer.data.nil?)
            end
          end
        ensure
          @socket.close
          @zmq_context.terminate
        end

        def handle_request(socket)
          zmq_error_check(socket.recv_string(@request_buffer.data))
          @request_buffer.get_data_size
          log_debug { "[#{log_signature}] handling request" } if(!@request_buffer.data.nil?)
        end

        def initialize_buffers
          @did_respond = false
          @request = ::Protobuf::Socketrpc::Request.new
          @response = ::Protobuf::Socketrpc::Response.new
          @request_buffer = ::Protobuf::Rpc::Buffer.new(:read)
          @response_buffer = ::Protobuf::Rpc::Buffer.new(:write)
          @stats = ::Protobuf::Rpc::Stat.new(:SERVER, true)
          log_debug { "[#{log_signature}] Post init, new read buffer created" }
        end

        def send_data
          zmq_error_check(@socket.send_string(@response_buffer.write))
        end
      end

    end
  end
end