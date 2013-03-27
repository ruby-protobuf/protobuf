require 'protobuf/rpc/servers/zmq/broker'
require 'protobuf/rpc/servers/zmq/worker'
require 'protobuf/rpc/servers/zmq/util'

module Protobuf
  module Rpc
    module Zmq
      class Server
        include ::Protobuf::Rpc::Zmq::Util

        attr_accessor :threads, :options

        def initialize(options)
          @options = options
          @threads = []
        end

        def host
          @options[:host]
        end

        def run
          @running = true

          unless @options[:workers_only]
            log_debug { sign_message("initializing broker") }
            @broker = ::Protobuf::Rpc::Zmq::Broker.new(@options)
          end

          local_worker_threads = @options[:threads]
          log_debug { sign_message("starting server workers") }


          local_worker_threads.times do
            self.start_worker
          end

          log_debug { sign_message("server started") }

          while self.running? do
            if @options[:workers_only]
              sleep 5
              Thread.pass
            else
              @broker.poll
            end
          end
        ensure
          @broker.teardown if @broker
        end

        def running?
          !!@running
        end

        def start_worker
          @threads << Thread.new(self) { |server|
            begin
              ::Protobuf::Rpc::Zmq::Worker.new(server).run
            rescue => e
              message =  "Worker Failed, spawning new worker: #{e.inspect}\n #{e.backtrace.join($/)}"
              $stderr.puts message
              log_error { message }

              retry if self.running?
            end
          }
        end

        def stop
          @running = false

          @threads.each do |t|
            t.join(5) || t.kill
          end
        end

        def worker_port
          @options[:worker_port]
        end
      end
    end
  end
end
