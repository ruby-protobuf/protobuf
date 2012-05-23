require 'protobuf/rpc/servers/zmq/broker'
require 'protobuf/rpc/servers/zmq/worker'
require 'protobuf/rpc/servers/zmq/util'
require 'pry'

module Protobuf
  module Rpc
    module Zmq
      class Server
        include ::Protobuf::Rpc::Zmq::Util

        ##
        # Class Methods
        #
        def self.run(opts = {})
          log_debug { "[#{log_signature}] initializing broker" }
          @broker = ::Protobuf::Rpc::Zmq::Broker.new(opts)
          local_worker_threads = opts.fetch(:threads, 10)

          log_debug { "[#{log_signature}] starting server workers" }
          local_worker_threads.times do
            @threads << Thread.new { ::Protobuf::Rpc::Zmq::Worker.new.run }
          end
          @running = true

          while self.running? do
            log_debug { "[#{log_signature}] server started" }
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
