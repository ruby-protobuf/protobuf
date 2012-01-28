module Protobuf
  module Rpc
    class SocketRunner 

      def self.stop
        Protobuf::Rpc::SocketServer.stop 
        Protobuf::Logger.info 'Shutdown complete'
      end

      def self.run(server)
        Protobuf::Logger.info "SocketServer Running"
        Protobuf::Rpc::SocketServer.run(server.host, server.port, server.backlog, server.threshold)
      end
    end

  end
end
