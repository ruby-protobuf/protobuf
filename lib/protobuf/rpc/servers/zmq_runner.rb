module Protobuf
  module Rpc
    class ZmqRunner

      def self.stop
        Protobuf::Rpc::ZmqServer.stop 
        Protobuf::Logger.info 'Shutdown complete'
      end

      def self.run(server)
        Protobuf::Logger.info "ZmqServer Running"
        server_config = case 
                        when server.is_a?(OpenStruct) then 
                          server.marshal_dump
                        when server.is_a?(Hash) then
                          server
                        when server.respond_to?(:to_hash) then
                          server.to_hash
                        else
                          raise "Cannot parser Zmq Server - server options"
                        end

        Protobuf::Rpc::ZmqServer.run(server_config)
      end
    end

  end
end
