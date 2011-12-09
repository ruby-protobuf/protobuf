require 'protobuf/rpc/connectors/base'

module Protobuf
  module Rpc
    module Connectors
      class Socket < Base
        include Protobuf::Rpc::Connectors::Common
        include Protobuf::Logger::LogMethods
        
        def send_request
          check_async
          initialize_stats
          connect_to_rpc_server
          post_init # calls _send_request
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

        def read_data
          size_io = StringIO.new

          while((size_reader = @socket.getc) != "-")
            size_io << size_reader
          end
          str_size_io = size_io.string

          "#{str_size_io}-#{@socket.read(str_size_io.to_i)}"
        end

        def read_response
          @buffer << read_data 
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
