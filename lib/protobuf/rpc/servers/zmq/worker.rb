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
        def initialize(opts={})
          @options = opts
          host = @options.fetch(:host, "127.0.0.1")
          port = @options.fetch(:port, 9400)
          protocol = @options.fetch(:protocol, "tcp")

          @zmq_context = ::ZMQ::Context.new
          @socket = @zmq_context.socket(::ZMQ::REP)
          zmq_error_check(@socket.connect("#{protocol}://#{resolve_ip(host)}:#{port}"))

          @poller = ::ZMQ::Poller.new
          @poller.register(@socket, ::ZMQ::POLLIN)
        end

        ##
        # Instance Methods
        #
        def handle_request(socket)
          @request_data = ''
          zmq_error_check(socket.recv_string(@request_data))
          log_debug { "[#{log_signature}] handling request" } if(!@request_data.nil?)
        end

        def initialize_buffers
          @did_respond = false
          @request = ::Protobuf::Socketrpc::Request.new
          @response = ::Protobuf::Socketrpc::Response.new
          @stats = ::Protobuf::Rpc::Stat.new(:SERVER, true)
          log_debug { "[#{log_signature}] Post init" }
        end

        def run
          while ::Protobuf::Rpc::Zmq::Server.running? do
            # poll for 1_000 milliseconds then continue looping
            # This lets us see whether we need to die
            @poller.poll(1_000)
            @poller.readables.each do |socket|
              initialize_buffers
              handle_request(socket)
              handle_client unless(@request_data.nil?)
            end
          end
        ensure
          @socket.close
          @zmq_context.terminate
        end

        def send_data
          response_data = @response.is_a?(::Protobuf::Message) ? @response.serialize_to_string : @response.to_s
          @stats.response_size = response_data.size
          zmq_error_check(@socket.send_string(response_data))
          @did_respond = true
        end
      end

    end
  end
end
