require 'protobuf/rpc/server'
require 'protobuf/rpc/servers/socket/worker'

module Protobuf
  module Rpc
    module Socket

      class Server
        include ::Protobuf::Rpc::Server
        include ::Protobuf::Logger::LogMethods

        AUTO_COLLECT_TIMEOUT = 5 # seconds

        def initialize(options)
          @options = options
        end

        def cleanup?
          # every 10 connections run a cleanup routine after closing the response
          @threads.size > (@threshold - 1) && (@threads.size % @threshold) == 0
        end

        def cleanup_threads
          log_debug { sign_message("Thread cleanup - #{@threads.size} - start") }

          @threads = @threads.select do |t|
            if t[:thread].alive?
              true
            else
              t[:thread].join
              @working.delete(t[:socket])
              false
            end
          end

          log_debug { sign_message("Thread cleanup - #{@threads.size} - complete") }
        end

        def log_signature
          @_log_signature ||= "server-#{self.class.name}"
        end

        def new_worker(socket)
          Thread.new(socket) do |sock|
            ::Protobuf::Rpc::Socket::Worker.new(sock) do |s|
              s.close
            end
          end
        end

        def run
          log_debug { sign_message("Run") }
          host = @options[:host]
          port = @options[:port]
          backlog = @options[:backlog]
          @threshold = @options[:threshold]

          @threads = []
          @server = ::TCPServer.new(host, port)
          raise "The server was unable to start properly." if @server.closed?

          @server.listen(backlog)
          @working = []
          @listen_fds = [@server]
          @running = true

          while running?
            log_debug { sign_message("Waiting for connections") }

            if ready_cnxns = IO.select(@listen_fds, [], [], AUTO_COLLECT_TIMEOUT)
              cnxns = ready_cnxns.first
              cnxns.each do |client|
                case
                when !running? then
                  # no-op
                when client == @server then
                  log_debug { sign_message("Accepted new connection") }
                  client, sockaddr = @server.accept
                  @listen_fds << client
                else
                  unless @working.include?(client)
                    @working << @listen_fds.delete(client)
                    log_debug { sign_message("Working")  }
                    @threads << { :thread => new_worker(client), :socket => client }

                    cleanup_threads if cleanup?
                  end
                end
              end
            else
              # Run a cleanup if select times out while waiting
              cleanup_threads if @threads.size > 1
            end
          end

        rescue Errno::EADDRINUSE
          raise
        rescue
          # Closing the server causes the loop to raise an exception here
          raise #if running?
        end

        def running?
          !!@running
        end

        def stop
          @running = false
          @server.try :close
        end
      end
    end
  end
end
