require 'protobuf/rpc/connectors/base'

module Protobuf
  module Rpc
    module Connectors
      class Socket < Base
        include Protobuf::Rpc::Connectors::Common
        
        def send_request
          initialize_stats
          post_init
          check_async
          connect_to_rpc_server
          _send_request
          read_response
        end

        private

        def check_async
          raise "Cannot use Socket client in async mode" if async?
        end

        def close_connection
          @socket.close
        end

        def connect_to_rpc_server
          @socket = TCPSocket.new(options[:host], options[:port])
        end

        # Method to determine error state, must be used with Connector api
        def error?
          @socket.closed?
        end

        def read_response
          @buffer << @socket.read
          parse_response if @buffer.flushed?
        end

        def send_data(data)
          @socket.write(data)
          @socket.close_write
        end

      end
    end
  end
end
