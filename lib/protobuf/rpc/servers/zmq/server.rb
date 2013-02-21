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

          log_debug { sign_message("starting server workers") }

          local_worker_threads.times do
            self.start_worker
          end

          @running = true

          log_debug { sign_message("server started") }

          while self.running? do
            @broker.poll
          end
        end

        def self.running?
          !!@running
        end

        def self.start_worker
          @threads << Thread.new(@broker) { |broker|
            begin
              ::Protobuf::Rpc::Zmq::Worker.new(broker).run
            rescue => e
              if ::Protobuf::Rpc::Zmq::Server.running?
                message =  "Worker Failed, spawning new worker: #{e.inspect}\n #{e.backtrace.join("\n")}"
                $stderr.puts message
                log_error { message }
              end
            end
          }
        end

        def self.stop
          @running = false

          @threads.each do |t|
            t.join
          end

          @broker.teardown
        end

        @threads ||= []
      end
    end
  end
end
