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

      end

      def run
        @server = ::Protobuf::Rpc::Zmq::Server.new(@options)
        register_signals
        yield if block_given?
        @server.run
      end

      def running?
        @server.try :running?
      end

      def stop
        @server.try :stop
      end

      private

      def register_signals
        trap(:TTIN) do
          @server.add_worker
          log_info { "Increased worker size to: #{@server.total_workers}" }
        end

        trap(:TTOU) do
          log_info { "Current worker size: #{@server.workers.size}" }
        end
      end
    end
  end
end
