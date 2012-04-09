require 'protobuf/rpc/server'

module Protobuf
  module Rpc
    class ZmqServer 
      include Protobuf::Rpc::Server
      include Protobuf::Logger::LogMethods

      def initialize(sock)
        @request = Protobuf::Socketrpc::Request.new
        @response = Protobuf::Socketrpc::Response.new
        @request_buffer = Protobuf::Rpc::Buffer.new(:read)
        @response_buffer = Protobuf::Rpc::Buffer.new(:write)
        @stats = Protobuf::Rpc::Stat.new(:SERVER, true)
        @socket = sock
        log_debug "[#{log_signature}] Post init, new read buffer created"

        zmq_error_check(@socket.recv_string(@request_buffer.data))
        @request_buffer.size = @request_buffer.data.size

        log_debug "[#{log_signature}] handling request"
        handle_client
      end

      def send_data
        zmq_error_check(@socket.send_string(@response_buffer.data)) 
      end

      def zmq_error_check(return_code)
        self.class.zmq_error_check(return_code)
      end

      def self.zmq_error_check(return_code)
        raise "Last API call failed at #{caller(1)}" unless return_code >= 0
      end

      def self.run(opts = {})
        host = opts.fetch(:host, "127.0.0.1")
        port = opts.fetch(:port, 9399)

        @zmq_context ||= ZMQ::Context.new
        @socket = @zmq_context.socket(ZMQ::REP)
        zmq_error_check(@socket.setsockopt(ZMQ::SNDHWM, 1000))
        zmq_error_check(@socket.setsockopt(ZMQ::RCVHWM, 1000))
        zmq_error_check(@socket.bind("tcp://#{host}:#{port}"))

#        @frontend = @zmq_context.socket(ZMQ::ROUTER)
#        zmq_error_check(@frontend.setsockopt(ZMQ::SNDHWM, 1000))
#        zmq_error_check(@frontend.setsockopt(ZMQ::RCVHWM, 1000))
#        zmq_error_check(@frontend.bind("tcp://#{host}:#{port}"))
#
#        @backend = @zmq_context.socket(ZMQ::DEALER)
#        zmq_error_check(@backend.setsockopt(ZMQ::SNDHWM, 1000))
#        zmq_error_check(@backend.setsockopt(ZMQ::RCVHWM, 1000))
#        zmq_error_check(@backend.bind("tcp://#{host}:#{port + 1}"))
#
#        @frontend.identity = "frontend"
#        @backend.identity = "backend"
#
#        @poller = ZMQ::Poller.new
        @running = true

        loop do
          new(@socket)
        end
      end

      def self.log_signature
        @log_signature ||= "server-#{self.class}-#{object_id}"
      end

      def self.running?
        @running
      end

      def self.stop
        @socket.close
        @zmq_context.terminate
        @running = false
      end
    end
  end
end
