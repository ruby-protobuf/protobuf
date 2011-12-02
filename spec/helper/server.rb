require 'lib/protobuf/rpc/server'
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
  def initialize(delay = 0, port = 9191)
    @server_handle = EventMachine::start_server("127.0.0.1", port, StubProtobufServerFactory.build(delay)) 
  end

  def stop
    EventMachine.stop_server(@server_handle)
  end
end
