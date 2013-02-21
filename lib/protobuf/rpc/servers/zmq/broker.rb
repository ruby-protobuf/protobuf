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
          @options = options
          @context = ::ZMQ::Context.new
          @frontend = setup_frontend
          @backend = setup_backend
          @poller = ::ZMQ::Poller.new
          @poller.register(frontend, ::ZMQ::POLLIN)
          @poller.register(backend, ::ZMQ::POLLIN)
        end

        ##
        # Instance Methods
        #
        def poll
          poller.poll(1000)
          poller.readables.each do |socket|
            case socket
            when frontend then
              zmq_error_check(frontend.recv_strings(messages = []))
              zmq_error_check(backend.send_strings(messages))
            when backend then
              zmq_error_check(backend.recv_strings(messages = []))
              zmq_error_check(frontend.send_strings(messages))
            end
          end
        end

        def teardown
          zmq_error_check(frontend.close)
          zmq_error_check(backend.close)
          context.terminate
        end

        def frontend_addr
          unless @frontend_addr
            host = @options[:host]
            port = @options[:port]

            @frontend_addr = "tcp://#{resolve_ip(host)}:#{port}"
          end

          @frontend_addr
        end

        def backend_addr
          "inproc://backend"
        end

        private
          def setup_backend
            zmq_backend = context.socket(::ZMQ::DEALER)
            zmq_error_check(zmq_backend.bind(backend_addr))
            zmq_backend
          end

          def setup_frontend
            zmq_frontend = context.socket(::ZMQ::ROUTER)
            zmq_error_check(zmq_frontend.bind(frontend_addr))
            zmq_frontend
          end

          def bind_address(host, port)
          end
      end
    end
  end
end
