require 'ostruct'
require 'protobuf/common/logger'
require 'protobuf/rpc/server'
require 'protobuf/rpc/servers/socket_server'
require 'protobuf/rpc/servers/socket_runner'
require 'spec/proto/test_service_impl'

module StubProtobufServerFactory
  def self.build(delay)
    new_server = Class.new(Protobuf::Rpc::EventedServer) do
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

  def initialize(opts = {})
    @running = true
    @options = OpenStruct.new({
        :host => "127.0.0.1", 
        :port => 9399, 
        :delay => 0, 
        :server => Protobuf::Rpc::EventedServer
      }.merge(opts))

    start
    yield self
  ensure
    stop if @running
  end

  def start
    if @options.server == Protobuf::Rpc::EventedServer
      start_em_server
    else
      @sock_server = Thread.new(@options) { |opt| Protobuf::Rpc::SocketRunner.run(opt) }
      @sock_server.abort_on_exception = true # Set for testing purposes
      Thread.pass until Protobuf::Rpc::SocketServer.running?
    end
    log_debug "[stub-server] Server started #{@options.host}:#{@options.port}"
  rescue => ex
    if ex =~ /no acceptor/ # Means EM didn't shutdown in the next_tick yet
      stop
      retry
    end
  end

  def start_em_server
    @server_handle = EventMachine::start_server(@options.host, @options.port, StubProtobufServerFactory.build(@options.delay))
  end

  def stop
    if @options.server == Protobuf::Rpc::EventedServer
      EventMachine.stop_server(@server_handle) if @server_handle
    else
      Protobuf::Rpc::SocketRunner.stop
      Thread.kill(@sock_server) if @sock_server
    end
    @running = false
  end
end
