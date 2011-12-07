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

  def initialize(opts = {})
    @options = OpenStruct.new({
        :host => "127.0.0.1", 
        :port => 9939, 
        :delay => 0, 
        :server => Protobuf::Rpc::EventedServer
      }.merge(opts))

    if @options.server == Protobuf::Rpc::EventedServer
      start_em_server
    else
      Protobuf::Rpc::SocketRunner.run(@options)
    end
    log_debug "[stub-server] Server started #{@options.host}:#{@options.port}"
  end

  def start_em_server
    if !EM.reactor_running?
      Thread.new { EM.run }
      Thread.pass until EM.reactor_running?
    end

    @server_handle = EventMachine::start_server(@options.host, @options.port, StubProtobufServerFactory.build(@options.delay))
  end

  def stop
    case 
    when @options.server == Protobuf::Rpc::EventedServer then
      EventMachine.stop_server(@server_handle)
    else
      Protobuf::Rpc::SocketRunner.stop
    end
  end
end
