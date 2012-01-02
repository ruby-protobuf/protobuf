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

          @threads = @threads.select do |t| 
            if t[:thread].alive? 
              true  
            else
              t[:thread].join
              @working.delete(t[:socket])
              false
            end
          end

          log_debug "[#{log_signature}] Thread cleanup - #{@threads.size} - complete"
        end

        def log_signature
          @log_signature ||= "server-#{self}"
        end

        def new_worker(socket)
          Thread.new(socket) do |sock|
            Protobuf::Rpc::SocketServer::Worker.new(sock) do |s|
              s.close
            end
          end
        end

        # TODO make listen/backlog part of config
        def run(host = "127.0.0.1", port = 9399, backlog = 100, thread_threshold = 100)
          log_debug "[#{log_signature}] Run"
          @running = true
          @threads = []
          @thread_threshold = thread_threshold
          @server = TCPServer.new(host, port)
          @server.listen(backlog)
          @working = []
          @listen_fds = [@server]

          while running?
            log_debug "[#{log_signature}] Waiting for connections"

            if ready_cnxns = IO.select(@listen_fds, [], [], 20)
              cnxns = ready_cnxns.first
              cnxns.each do |client|
                case 
                when !running? then
                  # no-op
                when client == @server then 
                  log_debug "[#{log_signature}] Accepted new connection"
                  client, sockaddr = @server.accept
                  @listen_fds << client
                else 
                  if !@working.include?(client)
                    @working << @listen_fds.delete(client)
                    log_debug "[#{log_signature}] Working" 
                    @threads << { :thread => new_worker(client), 
                                  :socket => client }

                    cleanup_threads if cleanup?
                  end
                end
              end
            else
              # Run a cleanup if select times out while waiting
              cleanup_threads if @threads.size > 1
            end
          end

        rescue 
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

        def initialize(sock, &complete_cb)
          @did_response = false
          @socket = sock
          @request = Protobuf::Socketrpc::Request.new
          @response = Protobuf::Socketrpc::Response.new
          @buffer = Protobuf::Rpc::Buffer.new(:read)
          @stats = Protobuf::Rpc::Stat.new(:SERVER, true)
          @complete_cb = complete_cb
          log_debug "[#{log_signature}] Post init, new read buffer created"

          @stats.client = Socket.unpack_sockaddr_in(@socket.getpeername)
          @buffer << read_data 
          log_debug "[#{log_signature}] handling request"
          handle_client if @buffer.flushed?
        end

        def log_signature
          @log_signature ||= "server-#{self.class}-#{object_id}"
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
          @socket.flush
          @complete_cb.call(@socket)
        end
      end
    end
  end
end
