require 'protobuf/rpc/server'

module Protobuf
  module Rpc
    class SocketServer  
      include Protobuf::Rpc::Server
      include Protobuf::Logger::LogMethods

      class << self
        def run(host = "127.0.0.1", port = 9399)
          server = TCPServer.new(host, port)
          server.listen(100)

          loop do 
            Thread.new(server.accept) do |sock|
              service_worker = self.new(sock)
              sock.close 
            end
          end
        end
      end

      def initialize(sock)
        @did_response = false
        @socket = sock
        @request = Protobuf::Socketrpc::Request.new
        @response = Protobuf::Socketrpc::Response.new
        @buffer = Protobuf::Rpc::Buffer.new(:read)
        @stats = Protobuf::Rpc::Stat.new(:SERVER, true)

        @stats.client = Socket.unpack_sockaddr_in(sock.getpeername)
        @buffer << @socket.read
        handle_client
      end

    end
  end
end
