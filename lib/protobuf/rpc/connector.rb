module Protobuf
  module Rpc
    class Connector
      
      def self.connector_for_client
        if defined?(Protobuf::ClientType)
          case Protobuf::ClientType 
          when "Socket" then 
            ::Protobuf::Rpc::Connectors::Socket
          else
            ::Protobuf::Rpc::Connectors::EventMachine
          end
        else
          ::Protobuf::Rpc::Connectors::EventMachine
        end
      end
      
    end
  end
end
