module Protobuf
  module Rpc
    module Socket

      class Server
        include ::Protobuf::Rpc::Server
        include ::Protobuf::Logger::LogMethods

        def self.cleanup?
          # every 10 connections run a cleanup routine after closing the response
          @threads.size > (@thread_threshold - 1) && (@threads.size % @thread_threshold) == 0
        end

        def self.cleanup_threads
          log_debug { "[#{log_signature}] Thread cleanup - #{@threads.size} - start" }

          @threads = @threads.select do |t|
            if t[:thread].alive?
              true
            else
              t[:thread].join
              @working.delete(t[:socket])
              false
            end
          end

          log_debug { "[#{log_signature}] Thread cleanup - #{@threads.size} - complete" }
        end

        def self.log_signature
          @log_signature ||= "server-#{self}"
        end

        def self.new_worker(socket)
          Thread.new(socket) do |sock|
            ::Protobuf::Rpc::SocketServer::Worker.new(sock) do |s|
              s.close
            end
          end
        end

        def self.run(opts = {})
          log_debug { "[#{log_signature}] Run" }
          host = opts.fetch(:host, "127.0.0.1")
          port = opts.fetch(:port, 9399)
          backlog = opts.fetch(:backlog, 100)
          thread_threshold = opts.fetch(:thread_threshold, 100)
          auto_collect_timeout = opts.fetch(:auto_collect_timeout, 20)

          @threads = []
          @thread_threshold = thread_threshold
          @server = ::TCPServer.new(host, port)
          @server.listen(backlog)
          @working = []
          @listen_fds = [@server]
          @running = true

          while running?
            log_debug { "[#{log_signature}] Waiting for connections" }

            if ready_cnxns = IO.select(@listen_fds, [], [], auto_collect_timeout)
              cnxns = ready_cnxns.first
              cnxns.each do |client|
                case
                when !running? then
                  # no-op
                when client == @server then
                  log_debug { "[#{log_signature}] Accepted new connection" }
                  client, sockaddr = @server.accept
                  @listen_fds << client
                else
                  if !@working.include?(client)
                    @working << @listen_fds.delete(client)
                    log_debug { "[#{log_signature}] Working"  }
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
          raise if running?
        end

        def self.running?
          @running
        end

        def self.stop
          @running = false
          @server.close if @server
        end
      end

    end
  end
end
