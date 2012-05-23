require 'protobuf/rpc/servers/zmq/util'
module Protobuf
  module Rpc
    module Zmq
      class Broker
        include ::Protobuf::Rpc::Zmq::Util
        attr_reader :frontend, :backend, :poller, :context

        def initialize(opts={})
          @context = ::ZMQ::Context.new
          @frontend = setup_frontend(opts)
          @backend = setup_backend
          @poller = setup_poller
        end

        def poll
          log_debug { "[#{log_signature}] polling for data" }
          poller.poll(:blocking)
          poller.readables.each do |socket|
            more = true

            case socket
            when frontend then
              while more do
                socket.recv_string(message = '')
                more = socket.more_parts?
                backend.send_string(message, more ? ::ZMQ::SNDMORE : 0)
              end
            when backend then
              while more do
                socket.recv_string(message = '')
                more = socket.more_parts?
                frontend.send_string(message, more ? ::ZMQ::SNDMORE : 0)
              end
            end
          end
        end

        def teardown
          frontend.close
          backend.close
          context.terminate
        end

        private
          def setup_frontend(opts={})
            host = opts.fetch(:host, "127.0.0.1")
            port = opts.fetch(:port, 9399)
            protocol = opts.fetch(:protocol, "tcp")

            zmq_frontend = context.socket(::ZMQ::ROUTER)
            zmq_error_check(zmq_frontend.bind("#{protocol}://#{resolve_ip(host)}:#{port}"))
            zmq_frontend
          end

          def setup_backend
            zmq_backend = context.socket(::ZMQ::DEALER)
            # needs a unique name
            zmq_error_check(zmq_backend.bind("ipc://backend.ipc"))
            zmq_backend
          end

          def setup_poller
            zmq_poller = ::ZMQ::Poller.new
            zmq_poller.register(frontend, ::ZMQ::POLLIN)
            zmq_poller.register(backend, ::ZMQ::POLLIN)
            zmq_poller
          end

          def resolve_ip(hostname)
            Socket.getaddrinfo(hostname, nil).select{|type| type[0] == 'AF_INET'}[0][3]
          end
      end
    end
  end
end