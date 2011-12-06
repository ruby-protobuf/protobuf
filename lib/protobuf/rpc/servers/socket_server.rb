require 'protobuf/rpc/server'

module Protobuf
  module Rpc
    class SocketServer  
      include Protobuf::Rpc::Server
      include Protobuf::Logger::LogMethods

      class << self

        def stop 
          @running = false
          @server.close
        end

        # TODO make listen/backlog part of config
        def run(host = "127.0.0.1", port = 9399, backlog = 100)
          @running = true
          @server = TCPServer.new(host, port)
          @server.listen(backlog)

          while (sock = @server.accept)
            self.new(sock)
            sock.close 
          end

        rescue Errno::EBADF
          # Closing the server causes the loop to raise an exception here
          raise if running?
        end

        def running?
          @running
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
        handle_client if @buffer.flushed?
      end

      def send_data(data)
        @socket.write(data)
      end

    end
  end
end
