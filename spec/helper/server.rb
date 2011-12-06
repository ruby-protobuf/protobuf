require 'ostruct'
require 'protobuf/rpc/server'
require 'spec/proto/test_service_impl'

module StubProtobufServerFactory
  def self.build(delay, server_class)
    new_server = Class.new(server_class) do
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
  def initialize(opts = {})
    @options = OpenStruct.new({
        :host => "127.0.0.1", 
        :port => 9191, 
        :delay => 0, 
        :server => Protobuf::Rpc::EventedServer
      }.merge(opts))

    if @options.server == Protobuf::Rpc::EventedServer
      start_em_server
    else
      Protobuf::Rpc::SocketRunner.run(@options)
    end
  end

  def start_em_server
    if !EM.reactor_running?
      Thread.new { EM.run }
      Thread.pass until EM.reactor_running?
    end

    @server_handle = EventMachine::start_server(@options.host, @options.port, StubProtobufServerFactory.build(@options.delay, @options.server)) 
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
