module Protobuf
  module Rpc
    class EventedRunner 

      def self.stop
        EventMachine.stop_event_loop if EventMachine.reactor_running?
        Protobuf::Logger.info 'Shutdown complete'
      end

      def self.run(server)
        # Ensure errors thrown within EM are caught and logged appropriately
        EventMachine.error_handler do |error|
          if error.message == 'no acceptor'
            raise 'Failed binding to %s:%d (%s)' % [server.host, server.port, error.message]
          else
            Protobuf::Logger.error error.message
            Protobuf::Logger.error error.backtrace.join("\n")
          end
        end

        # Startup and run the rpc server
        EM.schedule do
          EventMachine.start_server(server.host, server.port, Protobuf::Rpc::EventedServer) && \
            Protobuf::Logger.info('RPC Server listening at %s:%d in %s' % [server.host, server.port, server.env])
        end

        # Join or start the reactor
        EM.reactor_running? ? EM.reactor_thread.join : EM.run
      end
    end
  end
end
