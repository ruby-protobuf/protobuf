require 'protobuf/rpc/server'

module Protobuf
  module Rpc
    class ZmqServer 
      include ::Protobuf::Logger::LogMethods

      def self.zmq_error_check(return_code)
        raise "Last API call failed at #{caller(1)}" unless return_code >= 0
      end

      def self.run(opts = {})
        host = opts.fetch(:host, "127.0.0.1")
        port = opts.fetch(:port, 9399)
        protocol = opts.fetch(:protocol, "tcp")
        local_worker_threads = opts.fetch(:threads, 10)

        @zmq_context = ::ZMQ::Context.new
        @frontend = @zmq_context.socket(::ZMQ::ROUTER)
        zmq_error_check(@frontend.bind("#{protocol}://#{host}:#{port}"))

        dealer_options = opts.merge(:port => opts.fetch(:port, 9399) + 1)
        dealer_host = dealer_options.fetch(:host, "127.0.0.1")
        dealer_port = dealer_options.fetch(:port, 9400)
        dealer_protocol = dealer_options.fetch(:protocol, "tcp")
        @backend = @zmq_context.socket(::ZMQ::DEALER)
        zmq_error_check(@backend.bind("#{dealer_protocol}://#{dealer_host}:#{dealer_port}"))

        @poller = ::ZMQ::Poller.new
        @poller.register(@frontend, ::ZMQ::POLLIN)
        @poller.register(@backend, ::ZMQ::POLLIN)

        @threads = []
        local_worker_threads.times do 
          @threads << Thread.new(dealer_options) { |options| ZmqWorker.new(options).run }
        end
        @running = true

        while @running do
          @poller.poll(:blocking)
          @poller.readables.each do |socket|
            more = true

            case socket
            when @frontend then
              while more do
                socket.recv_string(message = '')
                more = socket.more_parts?
                @backend.send_string(message, more ? ::ZMQ::SNDMORE : 0)
              end
            when @backend then
              while more do
                socket.recv_string(message = '')
                more = socket.more_parts?
                @frontend.send_string(message, more ? ::ZMQ::SNDMORE : 0)
              end
            end
          end  
        end
      end

      def self.log_signature
        @log_signature ||= "server-#{self.class}-#{object_id}"
      end

      def self.running?
        @running
      end

      def self.stop
        @threads.map{ |t| t.join }
        @running = false
      end
    end

    class ZmqWorker
      include ::Protobuf::Rpc::Server
      include ::Protobuf::Logger::LogMethods

      def initialize(options)
        @options = options
        host = @options.fetch(:host, "127.0.0.1")
        port = @options.fetch(:port, 9400)
        protocol = @options.fetch(:protocol, "tcp")
        @zmq_context = ::ZMQ::Context.new
        @socket = @zmq_context.socket(::ZMQ::REP)
        zmq_error_check(@socket.connect("#{protocol}://#{host}:#{port}"))
      end

      def self.zmq_error_check(return_code)
        raise "Last API call failed at #{caller(1)}" unless return_code >= 0
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
        @request_buffer.size = @request_buffer.data.size
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
        zmq_error_check(@socket.send_string(@response_buffer.data)) 
      end

      def zmq_error_check(return_code)
        self.class.zmq_error_check(return_code)
      end
    end
  end
end
