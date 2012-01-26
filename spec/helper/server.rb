require 'ostruct'
require 'protobuf/common/logger'
require 'protobuf/rpc/server'
require 'spec/proto/test_service_impl'

module StubProtobufServerFactory
  def self.build(delay)
    new_server = Class.new(Protobuf::Rpc::EventedServer) do
      class << self
        def sleep_interval
          @sleep_interval
        end

        def sleep_interval=(si)
          @sleep_interval = si
        end
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
        :port => 9939, 
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
      Protobuf::Rpc::SocketRunner.run(@options)
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
    end
    @running = false
  end
end
