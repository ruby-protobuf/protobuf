require 'protobuf/rpc/server'

module Protobuf
  module Rpc
    class EventedServer < ::EventMachine::Connection
      include ::Protobuf::Rpc::Server
      include ::Protobuf::Logger::LogMethods
      
      # Initialize a new read buffer for storing client request info
      def post_init
        log_debug { '[server] Post init, new read buffer created' }
        @stats = Protobuf::Rpc::Stat.new(:SERVER, true)
        @stats.client = Socket.unpack_sockaddr_in(get_peername)
        
        @response_buffer = Protobuf::Rpc::Buffer.new(:write)
        @request_buffer = Protobuf::Rpc::Buffer.new(:read)
        @did_respond = false
      end
      
      # Receive a chunk of data, potentially flushed to handle_client
      def receive_data(data)
        log_debug { '[server] receive_data: %s' % data }
        @request_buffer << data
        @request = ::Protobuf::Socketrpc::Request.new
        @response = ::Protobuf::Socketrpc::Response.new
        handle_client if @request_buffer.flushed?
      end

      def send_data
        super(@response_buffer.data)
      end
    end
  end
end
