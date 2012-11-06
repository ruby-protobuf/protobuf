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

          worker_options = options.merge(:port => options[:port] + 1)
          log_debug { sign_message("starting server workers") }
          local_worker_threads.times do
            @threads << Thread.new { ::Protobuf::Rpc::Zmq::Worker.new(worker_options).run }
          end
          @running = true

          log_debug { sign_message("server started") }
          while self.running? do
            @broker.poll
          end
        ensure
          @broker.teardown if @broker
        end

        def self.running?
          !!@running
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
