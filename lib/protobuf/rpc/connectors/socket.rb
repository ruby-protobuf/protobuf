require 'protobuf/rpc/connectors/base'

module Protobuf
  module Rpc
    module Connectors
      class Socket < Base
        include Protobuf::Rpc::Connectors::Common
        include ::Protobuf::Logging

        def send_request
          timeout_wrap do
            setup_connection
            connect_to_rpc_server
            post_init
            read_response
          end
        end

        private

        def close_connection
          @socket.close
          signed_logger.debug { 'Connector closed'  }
        end

        def connect_to_rpc_server
          @socket = TCPSocket.new(options[:host], options[:port])
          signed_logger.debug { "Connection established #{options[:host]}:#{options[:port]}"  }
        end

        # Method to determine error state, must be used with Connector api
        def error?
          return true if @error
          signed_logger.debug { "Error state : #{@socket.closed?}"  }
          @socket.closed?
        end

        def read_data
          size_io = StringIO.new

          until (size_reader = @socket.getc) == "-"
            size_io << size_reader
          end
          str_size_io = size_io.string

          "#{str_size_io}-#{@socket.read(str_size_io.to_i)}"
        end

        def read_response
          signed_logger.debug { "error? is #{error?}" }
          return if error?
          response_buffer = ::Protobuf::Rpc::Buffer.new(:read)
          response_buffer << read_data
          @response_data = response_buffer.data
          parse_response if response_buffer.flushed?
        end

        def send_data
          return if error?
          request_buffer = ::Protobuf::Rpc::Buffer.new(:write)
          request_buffer.set_data(@request_data)
          @socket.write(request_buffer.write)
          @socket.flush
          signed_logger.debug { "write closed" }
        end
      end
    end
  end
end
