require 'protobuf/rpc/server'
require 'pry'

module Protobuf
  module Rpc
    module ZmqUtil
      def zmq_error_check(return_code)
        raise "Last API call failed with \"#{ZMQ::Util.error_string}\"\n\n#{caller(1)}" unless return_code >= 0
      end
    end

    class ZmqServer
      include ::Protobuf::Logger::LogMethods

      def self.run(opts = {})
        broker = ZmqBroker.new(opts)
        local_worker_threads = opts.fetch(:threads, 10)

        dealer_options = opts.merge(:port => opts.fetch(:port, 9399) + 1)
        @threads = []
        local_worker_threads.times do
          @threads << Thread.new(dealer_options) { |options| ZmqWorker.new(options).run }
        end
        @running = true

        while @running do
          broker.poll
        end
      end

      def self.log_signature
        @log_signature ||= "server-#{self.class}-#{object_id}"
      end

      def self.running?
        @running
      end

      def self.stop
        # TODO: find a better way of exiting these threads
        #   joining on an endless loop doesn't work. This is very brute force though. Potential loss of data
        @threads.map{ |t| t.exit; t.join}
        @running = false
        puts @threads.inspect
      end
    end

    class ZmqBroker
      include ::Protobuf::Rpc::ZmqUtil
      attr_reader :frontend, :backend, :poller, :context

      def initialize(opts={})
        @context = ::ZMQ::Context.new
        @frontend = setup_frontend(opts)
        @backend = setup_backend(opts)
        @poller = setup_poller
      end

      def poll
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

      private
        def setup_frontend(opts={})
          host = opts.fetch(:host, "127.0.0.1")
          port = opts.fetch(:port, 9399)
          protocol = opts.fetch(:protocol, "tcp")

          zmq_frontend = context.socket(::ZMQ::ROUTER)
          zmq_error_check(zmq_frontend.bind("#{protocol}://#{resolve_ip(host)}:#{port}"))
          zmq_frontend
        end

        def setup_backend(opts={})
          dealer_options = opts.merge(:port => opts.fetch(:port, 9399) + 1)
          host = dealer_options.fetch(:host, "127.0.0.1")
          port = dealer_options.fetch(:port, 9400)
          protocol = dealer_options.fetch(:protocol, "tcp")

          zmq_backend = context.socket(::ZMQ::DEALER)
          zmq_error_check(zmq_backend.bind("#{protocol}://#{resolve_ip(host)}:#{port}"))
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

    class ZmqWorker
      include ::Protobuf::Rpc::Server
      include ::Protobuf::Logger::LogMethods
      include ::Protobuf::Rpc::ZmqUtil

      def initialize(options)
        @options = options
        host = @options.fetch(:host, "127.0.0.1")
        port = @options.fetch(:port, 9400)
        protocol = @options.fetch(:protocol, "tcp")
        @zmq_context = ::ZMQ::Context.new
        @socket = @zmq_context.socket(::ZMQ::REP)
        zmq_error_check(@socket.connect("#{protocol}://#{host}:#{port}"))
      end

      def run
        loop do
          initialize_buffers
          handle_request
          handle_client
        end
      ensure
        @socket.close
        @zmq_context.terminate
      end

      def handle_request
        zmq_error_check(@socket.recv_string(@request_buffer.data))
        @request_buffer.get_data_size
        log_debug { "[#{log_signature}] handling request" }
      end

      def initialize_buffers
        @did_respond = false
        @request = ::Protobuf::Socketrpc::Request.new
        @response = ::Protobuf::Socketrpc::Response.new
        @request_buffer = ::Protobuf::Rpc::Buffer.new(:read)
        @response_buffer = ::Protobuf::Rpc::Buffer.new(:write)
        @stats = ::Protobuf::Rpc::Stat.new(:SERVER, true)
        log_debug { "[#{log_signature}] Post init, new read buffer created" }
      end

      def send_data
        zmq_error_check(@socket.send_string(@response_buffer.write))
      end
    end
  end
end
