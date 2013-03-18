require 'resolv'
require 'protobuf/rpc/servers/zmq/util'

module Protobuf
  module Rpc
    module Zmq
      class Broker
        include ::Protobuf::Rpc::Zmq::Util
        attr_reader :frontend, :backend, :poller, :context, :available_workers, :options, :expected_worker_count

        ##
        # Constructor
        #
        def initialize(options = {})
          @available_workers = []
          @options = options.deep_dup
          @expected_worker_count = @options[:threads]
          @context = ::ZMQ::Context.new
          @poller = ::ZMQ::Poller.new
          setup_backend
        end

        ##
        # Instance Methods
        #
        def poll
          if frontend.nil?
            if local_workers_have_started?            
              # only open the front end when the workers are done booting
              log_info { "Starting frontend socket in broker, all workers ready!" }
              setup_frontend 
            end
          else
            # Start checking the poller after startup
            if available_workers.size > 0
              poller.register(frontend, ::ZMQ::POLLIN) if poller.size < 2
            else
              poller.delete(frontend)
            end
          end

          poller.poll(1000)
          poller.readables.each do |socket|
            case socket
            when backend then
              move_to_frontend(socket)
            when frontend then
              move_to_backend(socket)
            end
          end
        end

        def setup_backend
          host = options[:host]
          port = options[:worker_port]

          zmq_backend = context.socket(::ZMQ::ROUTER)
          zmq_error_check(zmq_backend.bind(bind_address(host, port)))

          @backend = zmq_backend
          @poller.register(@backend, ::ZMQ::POLLIN)
        end

        def setup_frontend
          host = options[:host]
          port = options[:port]

          zmq_frontend = context.socket(::ZMQ::ROUTER)
          zmq_error_check(zmq_frontend.bind(bind_address(host, port)))

          @frontend = zmq_frontend
          @poller.register(@frontend, ::ZMQ::POLLIN)
        end

        def teardown
          frontend.try(:close)
          backend.try(:close)
          context.try(:terminate)
        end

        private

          def local_workers_have_started?
            @local_workers_have_started ||= available_workers.size >= expected_worker_count
          end

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
            if message_array[2] == ::Protobuf::Rpc::Zmq::WORKER_READY_MESSAGE
              log_info { "Worker #{available_workers.size} of #{expected_worker_count} ready!" }
            else
              frontend_message_set = [
                message_array[2], # client UUID
                "",
                message_array[4] # Reply payload
              ]

              zmq_error_check(frontend.send_strings(frontend_message_set))
            end
          end

          def bind_address(host, port)
            "tcp://#{resolve_ip(host)}:#{port}"
          end
      end
    end
  end
end
