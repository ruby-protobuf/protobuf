module Protobuf
  module Rpc
    class Connector

      # Returns a connector class for the pre-defined connector_type.
      def self.connector_for_client(reload = false)
        if reload || @_connector.nil?
          @_connector = case ::Protobuf.connector_type
                        when :evented then
                          ::Protobuf::Rpc::Connectors::EventMachine
                        when :zmq then
                          ::Protobuf::Rpc::Connectors::Zmq
                        else
                          ::Protobuf::Rpc::Connectors::Socket
                        end
        end

        return @_connector
      end

    end
  end
end
