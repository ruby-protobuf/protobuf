require 'protobuf/rpc/server'
require 'protobuf/rpc/servers/zmq/util'
require 'thread'

module Protobuf
  module Rpc
    module Zmq
      class Worker
        include ::Protobuf::Rpc::Server
        include ::Protobuf::Rpc::Zmq::Util

        ##
        # Constructor
        #
        def initialize(server, broker)
          @server = server
          @broker = broker
        rescue
          teardown
          raise
        end

        ##
        # Instance Methods
        #
        def process_job(job)
          client_address, _, data = *job

          return unless data

          gc_pause do
            encoded_response = handle_request(data)
            @broker.enqueue_response([client_address, ::Protobuf::Rpc::Zmq::EMPTY_STRING, encoded_response])
          end
        end

        def run
          loop do
            job = job_queue.deq

            break if job === :shutdown

            ::Thread.current[:busy] = true
            process_job(job)
            ::Thread.current[:busy] = false
          end

          job_queue << :shutdown # propogate :shutdown to other workers
        end

        def job_queue
          @server.job_queue
        end

        private

        def inproc?
          !!@server.try(:inproc?)
        end
      end
    end
  end
end
