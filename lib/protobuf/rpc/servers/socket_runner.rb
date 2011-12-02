module Protobuf
  module Rpc
    class SocketRunner 

      class << self

        def stop
          Protobuf::Rpc::SocketServer.stop 
          Protobuf::Logger.info 'Shutdown complete'
          $stdout.puts 'Shutdown complete'
        end

        def run(server)
          Protobuf::Logger.info "SocketServer Running"
          Protobuf::Rpc::SocketServer.run(server.host, server.port) if !Protobuf::Rpc::SocketServer.running?
        end

      end
    end
  end
end
