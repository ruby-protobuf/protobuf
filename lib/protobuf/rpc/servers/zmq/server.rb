require 'protobuf/rpc/servers/zmq/broker'
require 'protobuf/rpc/servers/zmq/worker'
require 'protobuf/rpc/servers/zmq/util'

module Protobuf
  module Rpc
    module Zmq
      class Server
        include ::Protobuf::Rpc::Zmq::Util

        ##
        # Class Methods
        #
        def self.run(options = {})
          log_debug { sign_message("initializing broker") }
          @broker = ::Protobuf::Rpc::Zmq::Broker.new(options)
          local_worker_threads = options[:threads]

          @worker_options = options.merge(:port => options[:port] + 1)
          log_debug { sign_message("starting server workers") }

          local_worker_threads.times do
            self.start_worker
          end

          @running = true
          log_debug { sign_message("server started") }

          self.register_signals

          while self.running? do
            @broker.poll
          end
        ensure
          @broker.teardown if @broker
        end

        def self.register_signals
          trap(:TTIN) do
            log_info { sign_message('TTIN received: Starting new worker') }
            self.start_worker
            log_info { sign_message("Worker Thread count = #{@threads.count}") }
          end
        end

        def self.running?
          !!@running
        end

        def self.start_worker
          @threads << Thread.new(@worker_options) { |worker_options|
            begin
              ::Protobuf::Rpc::Zmq::Worker.new(worker_options).run
            rescue => e
              message = "Worker Failed, spawning new worker: #{e.inspect}#{$/} #{e.backtrace.join($/)}"
              $stderr.puts message
              log_error { message }

              retry if ::Protobuf::Rpc::Zmq::Server.running?
            end
          }
        end

        def self.stop
          @running = false

          @threads.each do |t|
            t.join
          end
        end

        @threads ||= []
      end
    end
  end
end
