require 'protobuf/rpc/connectors/eventmachine'
require 'protobuf/rpc/connectors/socket'

module Protobuf
  module Rpc
    class Connector
      
      def self.connector_for_client
        if defined?(Protobuf::ConnectorType)
          case Protobuf::ConnectorType 
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
