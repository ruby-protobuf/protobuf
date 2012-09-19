module Protobuf
  module Rpc
    class SocketRunner 

      def self.stop
        ::Protobuf::Rpc::Socket::Server.stop 
        ::Protobuf::Logger.info { 'Shutdown complete' }
      end

      def self.run(server)
        ::Protobuf::Logger.info { "Socket::Server Running" }
        server_config = case 
                        when server.is_a?(OpenStruct) then 
                          server.marshal_dump
                        when server.is_a?(Hash) then
                          server
                        when server.respond_to?(:to_hash) then
                          server.to_hash
                        else
                          raise "Cannot parser Socket Server - server options"
                        end

        ::Protobuf::Rpc::Socket::Server.run(server_config)
      end

    end
  end
end
