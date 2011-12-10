require 'protobuf/rpc/server'

module Protobuf
  module Rpc
    class SocketServer  
      include Protobuf::Rpc::Server
      include Protobuf::Logger::LogMethods

      class << self

        def cleanup? 
          # every 10 connections run a cleanup routine after closing the response
          @threads.size > (@thread_threshold - 1) && (@threads.size % @thread_threshold) == 0
        end

        def cleanup_threads
          log_debug "[#{log_signature}] Thread cleanup - #{@threads.size} - start"
          @threads = @threads.select{ |t| t.alive? ? true : (t.join; false) }
          log_debug "[#{log_signature}] Thread cleanup - #{@threads.size} - complete"
        end

        def log_signature
          @log_signature ||= "server-#{self}"
        end

        # TODO make listen/backlog part of config
        def run(host = "127.0.0.1", port = 9399, backlog = 100, thread_threshold = 10)
          log_debug "[#{log_signature}] Run"
          @running = true
          @threads = []
          @thread_threshold = thread_threshold
          @server = TCPServer.new(host, port)
          @server.listen(backlog)

          while true
            @threads << Thread.new(@server.accept) do |sock|
              log_debug "[#{log_signature}] Accepted new connection"
              Protobuf::Rpc::SocketServer::Worker.new(sock)
              sock.close 
            end

            cleanup_threads if cleanup? 
          end

        rescue Errno::EBADF
          # Closing the server causes the loop to raise an exception here
          raise if running?
        end

        def running?
          @running
        end

        def stop 
          @running = false
          @server.close
        end

      end

      class Worker 
        include Protobuf::Rpc::Server
        include Protobuf::Logger::LogMethods

        def initialize(sock)
          @did_response = false
          @socket = sock
          @request = Protobuf::Socketrpc::Request.new
          @response = Protobuf::Socketrpc::Response.new
          @buffer = Protobuf::Rpc::Buffer.new(:read)
          @stats = Protobuf::Rpc::Stat.new(:SERVER, true)
          log_debug "[#{log_signature}] Post init, new read buffer created"

          @stats.client = Socket.unpack_sockaddr_in(@socket.getpeername)
          @buffer << read_data 
          log_debug "[#{log_signature}] handling request"
          handle_client if @buffer.flushed?
        end

        def log_signature
          @log_signature ||= "server-#{self.class}"
        end

        def read_data
          size_io = StringIO.new

          while((size_reader = @socket.getc) != "-")
            size_io << size_reader
          end
          str_size_io = size_io.string

          "#{str_size_io}-#{@socket.read(str_size_io.to_i)}"
        end

        def send_data(data)
          log_debug "[#{log_signature}] sending data : %s" % data
          @socket.write(data)
          @socket.close_write
        end
      end
    end
  end
end
