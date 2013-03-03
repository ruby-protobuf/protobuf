module Protobuf
  module Rpc
    class SocketRunner

      def self.register_signals
        # noop
      end

      def self.run(server)
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

				yield if block_given?
        ::Protobuf::Rpc::Socket::Server.run(server_config)
      end

      def self.stop
        ::Protobuf::Rpc::Socket::Server.stop
      end

    end
  end
end
