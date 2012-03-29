require 'protobuf/rpc/server'

module Protobuf
  module Rpc
    class ZmqServer 
      include Protobuf::Rpc::Server
      include Protobuf::Logger::LogMethods

      def self.run(opts = {})
        @running = true
        host = opts.fetch(:host, "127.0.0.1")
        port = opts.fetch(:port, 9399)

        context = ZMQ::Context.new
        @socket = context.socket(ZMQ::REP)
        @socket.bind("tcp://#{host}:#{port}")

        while running?

        end
      end

      def self.running?
        @running
      end

      def self.stop
        @running = false
      end

    end

    class Worker 
      include Protobuf::Rpc::Server
      include Protobuf::Logger::LogMethods

      def initialize(sock, &complete_cb)
        @did_response = false
        @socket = sock
        @request = Protobuf::Socketrpc::Request.new
        @response = Protobuf::Socketrpc::Response.new
        @buffer = Protobuf::Rpc::Buffer.new(:read)
        @stats = Protobuf::Rpc::Stat.new(:SERVER, true)
        @complete_cb = complete_cb
        log_debug "[#{log_signature}] Post init, new read buffer created"

        @socket.recv_string(@buffer.data)
        @buffer.size = @buffer.data.size

        log_debug "[#{log_signature}] handling request"
        handle_client
      end

      def log_signature
        @log_signature ||= "server-#{self.class}-#{object_id}"
      end

      def send_data(data)
        log_debug "[#{log_signature}] sending data : %s" % data
        @socket.send_string(data.split("-")[1])
        @complete_cb.call(@socket)
      end
    end
  end
end
