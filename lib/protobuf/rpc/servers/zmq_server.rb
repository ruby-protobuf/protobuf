require 'protobuf/rpc/server'
require 'pry'

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

        zmq_error_check(sock.recv_string(@request_buffer.data))
        @request_buffer.size = @request_buffer.data.size

        log_debug "[#{log_signature}] handling request"
        handle_client
      end

      def send_data(data_buffer)
        zmq_error_check(@socket.send_string(data_buffer.data)) 
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

        @zmq_context ||= ZMQ::Context.new(8)
        @socket = @zmq_context.socket(ZMQ::REP)
        zmq_error_check(@socket.setsockopt(ZMQ::SNDHWM, 1000))
        zmq_error_check(@socket.setsockopt(ZMQ::RCVHWM, 1000))
        zmq_error_check(@socket.bind("tcp://#{host}:#{port}"))
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
