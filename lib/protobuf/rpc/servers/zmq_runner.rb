module Protobuf
  module Rpc
    class ZmqRunner

      def self.register_signals
        trap(:TTIN) do 
          log_info { "TTIN received: Starting new worker" }
          ::Protobuf::Rpc::Zmq::Server.start_worker
          log_info { "Worker count : #{::Protobuf::Rpc::Zmq::Server.threads.size}" }
        end
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

      def self.stop
        Protobuf::Rpc::Zmq::Server.stop
      end

    end
  end
end
