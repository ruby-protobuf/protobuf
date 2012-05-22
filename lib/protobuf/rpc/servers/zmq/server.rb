require 'protobuf/rpc/servers/zmq/worker'
require 'protobuf/rpc/servers/zmq/broker'
require 'protobuf/rpc/servers/zmq/util'
require 'pry'

module Protobuf
  module Rpc
    module Zmq
      class Server
        include ::Protobuf::Rpc::Zmq::Util

        def self.run(opts = {})
          log_debug { "[#{log_signature}] initializing broker" }
          @broker = ::Protobuf::Rpc::Zmq::Broker.new(opts)
          local_worker_threads = opts.fetch(:threads, 10)

          dealer_options = opts.merge(:port => opts.fetch(:port, 9399) + 1)
          log_debug { "[#{log_signature}] starting server workers" }
          @threads = []
          local_worker_threads.times do
            @threads << Thread.new(dealer_options) { |options| Thread.current[:running] = true; sleep 1; ::Protobuf::Rpc::Zmq::Worker.new.run }
          end
          @running = true

          while @running do
            log_debug { "[#{log_signature}] server started" }
            @broker.poll
          end

        ensure
          @broker.teardown if(@broker)
        end

        def self.running?
          @running
        end

        def self.stop
          @threads.each do |t|
            t[:running] = false
            t.join
          end if(@threads)

          @running = false
        end
      end
    end
  end
end
