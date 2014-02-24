require 'ostruct'
require 'protobuf/rpc/server'
require 'protobuf/rpc/servers/socket/server'
require 'protobuf/rpc/servers/socket_runner'
require 'protobuf/rpc/servers/zmq/server'
require 'protobuf/rpc/servers/zmq_runner'
require 'spec/support/test/resource_service'

# Want to abort if server dies?
Thread.abort_on_exception = true

module StubProtobufServerFactory
  def self.build(delay)
    new_server = Class.new(Protobuf::Rpc::Socket::Server) do
      def self.sleep_interval
        @sleep_interval
      end

      def self.sleep_interval=(si)
        @sleep_interval = si
      end

      def post_init
        sleep self.class.sleep_interval
        super
      end
    end

    new_server.sleep_interval = delay
    return new_server
  end
end

class StubServer
  include ::Protobuf::Logging

  attr_accessor :options

  def initialize(options = {})
    @running = true
    @options = OpenStruct.new({ :host => "127.0.0.1",
                                :port => 9399,
                                :worker_port => 9400,
                                :delay => 0,
                                :server => Protobuf::Rpc::Socket::Server }.merge(options))

    start
    yield self
  ensure
    stop if @running
  end

  def start
    case
    when @options.server == Protobuf::Rpc::Zmq::Server
      start_zmq_server
    else
      start_socket_server
    end
    signed_logger.debug { "Server started #{@options.host}:#{@options.port}" }
  end

  def start_socket_server
    @sock_runner = ::Protobuf::Rpc::SocketRunner.new(options)
    @sock_thread = Thread.new(@sock_runner) { |runner| runner.run }
    @sock_thread.abort_on_exception = true # Set for testing purposes
    Thread.pass until @sock_runner.running?
  end

  def start_zmq_server
    @zmq_runner = ::Protobuf::Rpc::ZmqRunner.new(options)
    @zmq_thread = Thread.new(@zmq_runner) { |runner| runner.run }
    @zmq_thread.abort_on_exception = true # Set for testing purposes
    Thread.pass until @zmq_runner.running?
  end

  def stop
    case
    when @options.server == Protobuf::Rpc::Zmq::Server then
      @zmq_runner.try :stop
      @zmq_thread.join if @zmq_thread
    else
      @sock_runner.stop
      @sock_thread.join if @sock_thread
    end

    @running = false
  end

  def log_signature
    @_log_signature ||= "[stub-server]"
  end
end
