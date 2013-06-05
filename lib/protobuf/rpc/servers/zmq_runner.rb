require 'ostruct'

module Protobuf
  module Rpc
    class ZmqRunner
      include ::Protobuf::Logger::LogMethods

      def initialize(options)
        @options = case
                   when options.is_a?(OpenStruct) then
                     options.marshal_dump
                   when options.respond_to?(:to_hash) then
                     options.to_hash
                   else
                     raise "Cannot parser Zmq Server - server options"
                   end

        @server = ::Protobuf::Rpc::Zmq::Server.new(@options)
      end

      def run
        register_signals
        yield if block_given?
        @server.run
      end

      def running?
        @server.running?
      end

      def stop
        @server.stop
      end

      private

      def register_signals
        trap(:TTIN) do
          log_info { "TTIN received: Starting new worker" }
          @server.start_worker
          log_info { "Worker count : #{::Protobuf::Rpc::Zmq::Server.threads.size}" }
        end
      end
    end
  end
end
