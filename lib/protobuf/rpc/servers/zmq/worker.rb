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

          init_zmq_context
          init_backend_socket
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
        ensure
          teardown
        end

        def job_queue
          @server.job_queue
        end

        private

        def init_zmq_context
          if inproc?
            @zmq_context = @server.zmq_context
          else
            @zmq_context = ZMQ::Context.new
          end
        end

        def init_backend_socket
          @backend_socket = @zmq_context.socket(ZMQ::DEALER)
          zmq_error_check(@backend_socket.connect(@server.backend_uri))
        end

        def inproc?
          !!@server.try(:inproc?)
        end

        def read_from_backend
          frames = []
          zmq_error_check(@backend_socket.recv_strings(frames))
          frames
        end

        def teardown
          @backend_socket.try(:close)
          @zmq_context.try(:terminate) unless inproc?
        end

        def write_to_backend(frames)
          zmq_error_check(@backend_socket.send_strings(frames))
        end
      end
    end
  end
end
