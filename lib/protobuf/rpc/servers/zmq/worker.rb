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
        def initialize(server)
          @server = server

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
            write_to_backend([client_address, ::Protobuf::Rpc::Zmq::EMPTY_STRING, encoded_response])
          end
        end

        def run
          poller = ::ZMQ::Poller.new
          poller.register_readable(@backend_socket)

          loop do
            job = job_queue.deq

            ::Thread.current[:busy] = true
            process_job(job)
            ::Thread.current[:busy] = false
          end
        rescue ::Interrupt
          # Graceful shutdown
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
          @backend_socket = @zmq_context.socket(ZMQ::REQ)
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
