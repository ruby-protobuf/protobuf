require 'protobuf/rpc/server'

module Protobuf
  module Rpc
    module Evented
      class Server < ::EventMachine::Connection
        include ::Protobuf::Rpc::Server
        include ::Protobuf::Logger::LogMethods

        # Initialize a new read buffer for storing client request info
        def post_init
          log_debug { '[server] Post init, new read buffer created' }
          @stats = Protobuf::Rpc::Stat.new(:SERVER, true)
          @stats.client = ::Socket.unpack_sockaddr_in(get_peername)
          @request_buffer = Protobuf::Rpc::Buffer.new(:read)
          @request = ::Protobuf::Socketrpc::Request.new
          @response = ::Protobuf::Socketrpc::Response.new

          @did_respond = false
        end

        # Receive a chunk of data, potentially flushed to handle_client
        def receive_data(data)
          log_debug { '[server] receive_data: %s' % data }

          @request_buffer << data
          @request_data = @request_buffer.data
          @stats.request_size = @request_buffer.size

          handle_client if @request_buffer.flushed?
        end

        def send_data
          response_buffer = Protobuf::Rpc::Buffer.new(:write)
          response_buffer.set_data(@response)
          @stats.response_size = response_buffer.size
          log_debug { "[#{log_signature}] sending data: #{response_buffer.inspect}" }
          super(response_buffer.write)
        end
      end
    end
  end
end
