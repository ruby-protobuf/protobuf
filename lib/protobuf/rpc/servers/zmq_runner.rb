module Protobuf
  module Rpc
    class ZmqRunner

      def self.stop
        Protobuf::Rpc::Zmq::Server.stop
      end

      def self.run(server)
        server_config = case
                        when server.is_a?(OpenStruct) then
                          server.marshal_dump
                        when server.respond_to?(:to_hash) then
                          server.to_hash
                        else
                          raise "Cannot parser Zmq Server - server options"
                        end

				yield if block_given?
        Protobuf::Rpc::Zmq::Server.run(server_config)
      end
    end

  end
end
