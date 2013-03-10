require 'ostruct'
require 'protobuf/logger'
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
    new_server = Class.new(Protobuf::Rpc::Evented::Server) do
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
  include Protobuf::Logger::LogMethods

  attr_accessor :options

  def initialize(options = {})
    @running = true
    @options = OpenStruct.new({ :host => "127.0.0.1",
                                :port => 9399,
                                :delay => 0,
                                :server => Protobuf::Rpc::Evented::Server }.merge(options))

    start
    yield self
  ensure
    stop if @running
  end

  def start
    case
    when @options.server == Protobuf::Rpc::Evented::Server then start_em_server
    when @options.server == Protobuf::Rpc::Zmq::Server then start_zmq_server
    else
      start_socket_server
    end
    log_debug { sign_message("Server started #{@options.host}:#{@options.port}") }
  rescue => ex
    if ex =~ /no acceptor/ # Means EM didn't shutdown in the next_tick yet
      stop
      retry
    end
  end

  def start_em_server
    @server_handle = EventMachine.start_server(@options.host, @options.port, StubProtobufServerFactory.build(@options.delay))
  end

  def start_socket_server
    @sock_server = Thread.new(@options) { |opt| Protobuf::Rpc::SocketRunner.run(opt) }
    @sock_server.abort_on_exception = true # Set for testing purposes
    Thread.pass until Protobuf::Rpc::Socket::Server.running?
  end

  def start_zmq_server
    @zmq_server = Thread.new(@options) { |opt| Protobuf::Rpc::ZmqRunner.run(opt) }
    Thread.pass until Protobuf::Rpc::Zmq::Server.running?
  end

  def stop
    case
    when @options.server == Protobuf::Rpc::Evented::Server then
      EventMachine.stop_server(@server_handle) if @server_handle
    when @options.server == Protobuf::Rpc::Zmq::Server then
      Protobuf::Rpc::ZmqRunner.stop
      @zmq_server.join if @zmq_server
    else
      Protobuf::Rpc::SocketRunner.stop
      @sock_server.join if @sock_server
    end

    @running = false
  end

  def log_signature
    @_log_signature ||= "[stub-server]"
  end
end
