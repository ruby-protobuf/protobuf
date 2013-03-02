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
          unless options[:workers_only]
            log_debug { sign_message("initializing broker") }
            @broker = ::Protobuf::Rpc::Zmq::Broker.new(options)
          end

          local_worker_threads = options[:threads]
          @worker_options = options.merge(:port => options[:port] + 1)
          log_debug { sign_message("starting server workers") }

          local_worker_threads.times do
            self.start_worker
          end

          @running = true
          log_debug { sign_message("server started") }
          while self.running? do
            if options[:workers_only]
              sleep 5
              Thread.pass
            else
              @broker.poll
            end
          end
        ensure
          @broker.teardown if @broker
        end

        def self.running?
          !!@running
        end

        def self.start_worker
          @threads << Thread.new(@worker_options) { |worker_options|
            begin
              ::Protobuf::Rpc::Zmq::Worker.new(worker_options).run
            rescue => e
              message =  "Worker Failed, spawning new worker: #{e.inspect}\n #{e.backtrace.join("\n")}"
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
