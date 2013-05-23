module Protobuf
  module Rpc
    class SocketRunner

      def initialize(options)
        @options = case
                   when options.is_a?(OpenStruct) then
                     options.marshal_dump
                   when options.is_a?(Hash) then
                     options
                   when options.respond_to?(:to_hash) then
                     options.to_hash
                   else
                     raise "Cannot parser Socket Server - server options"
                   end

        @server = ::Protobuf::Rpc::Socket::Server.new(@options)
      end

      def register_signals
        # noop
      end

      def run
        yield if block_given?
        @server.run
      end

      def running?
        @server.running?
      end

      def stop
        @server.stop
      end
    end
  end
end
