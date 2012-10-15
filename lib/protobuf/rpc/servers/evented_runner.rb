module Protobuf
  module Rpc
    class EventedRunner

      def self.stop
        ::EventMachine.stop_event_loop if ::EventMachine.reactor_running?
      end

      def self.run(server)
        # Startup and run the rpc server
        ::EventMachine.schedule do
          ::EventMachine.start_server(server.host, server.port, ::Protobuf::Rpc::Evented::Server)
        end

        # Join or start the reactor
				yield if block_given?
        ::EM.reactor_running? ? ::EM.reactor_thread.join : ::EM.run
      end
    end
  end
end
