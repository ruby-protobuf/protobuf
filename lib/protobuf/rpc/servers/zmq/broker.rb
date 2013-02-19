require 'resolv'
require 'protobuf/rpc/servers/zmq/util'

module Protobuf
  module Rpc
    module Zmq
      class Broker
        include ::Protobuf::Rpc::Zmq::Util
        attr_reader :frontend, :backend, :poller, :context, :available_workers

        ##
        # Constructor
        #
        def initialize(options = {})
          @available_workers = []
          @context = ::ZMQ::Context.new
          @frontend = setup_frontend(options)
          @backend = setup_backend(options)
          @poller = ::ZMQ::Poller.new
          @poller.register(frontend, ::ZMQ::POLLIN)
          @poller.register(backend, ::ZMQ::POLLIN)
        end

        ##
        # Instance Methods
        #
        def poll
          if available_workers.size > 0
            poller.register(frontend, ::ZMQ::POLLIN) if poller.size < 2
          else
            poller.delete(frontend)
          end

          poller.poll(1000)
          poller.readables.each do |socket|
            case socket
            when frontend then
              move_to_backend(socket)
            when backend then
              move_to_frontend(socket)
            end
          end
        end

        def teardown
          frontend.close
          backend.close
          context.terminate
        end

        private

          def move_to_backend(socket)
            message_array = []
            zmq_error_check(socket.recv_strings(message_array))

            backend_message_set = [
              available_workers.shift, # Worker UUID for router
              "",
              message_array[0], # Client UUID for return value
              "",
              message_array[2] # Client Message payload (request)
            ]

            zmq_error_check(backend.send_strings(backend_message_set))
          end

          def move_to_frontend(socket)
            message_array = []
            zmq_error_check(socket.recv_strings(message_array))

            # Push UUID of socket on the available workers queue
            available_workers << message_array[0]

            # messages should be [ "uuid of socket", "", "READY_MESSAGE || uuid of client socket"]
            unless message_array[2] == ::Protobuf::Rpc::Zmq::WORKER_READY_MESSAGE
              frontend_message_set = [
                message_array[2], # client UUID
                "",
                message_array[4] # Reply payload
              ]

              zmq_error_check(frontend.send_strings(frontend_message_set))
            end
          end

          def setup_backend(options = {})
            dealer_options = options.merge(:port => options[:port] + 1)
            host = dealer_options[:host]
            port = dealer_options[:port]

            zmq_backend = context.socket(::ZMQ::ROUTER)
            zmq_error_check(zmq_backend.bind(bind_address(host, port)))
            zmq_backend
          end

          def setup_frontend(options = {})
            host = options[:host]
            port = options[:port]

            zmq_frontend = context.socket(::ZMQ::ROUTER)
            zmq_error_check(zmq_frontend.bind(bind_address(host, port)))
            zmq_frontend
          end

          def bind_address(host, port)
            "tcp://#{resolve_ip(host)}:#{port}"
          end
      end
    end
  end
end
