require 'protobuf/rpc/connectors/base'

module Protobuf
  module Rpc
    module Connectors
      class Socket < Base
        include Protobuf::Rpc::Connectors::Common
        include Protobuf::Logger::LogMethods

        def send_request
          ::Timeout.timeout(options[:timeout]) do
            setup_connection
            connect_to_rpc_server
            post_init
            read_response
          end
        end

        def log_signature
          @_log_signature ||= "[client-#{self.class}]"
        end

        private

        def close_connection
          @socket.close
          log_debug { sign_message('Connector closed')  }
        end

        def connect_to_rpc_server
          @socket = TCPSocket.new(options[:host], options[:port])
          log_debug { sign_message("Connection established #{options[:host]}:#{options[:port]}")  }
        end

        # Method to determine error state, must be used with Connector api
        def error?
          return true if @error
          log_debug { sign_message("Error state : #{@socket.closed?}")  }
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
          log_debug { sign_message("error? is #{error?}") }
          return if error?
          response_buffer = ::Protobuf::Rpc::Buffer.new(:read)
          response_buffer << read_data
          @stats.response_size = response_buffer.size
          @response_data = response_buffer.data
          parse_response if response_buffer.flushed?
        end

        def send_data
          return if error?
          request_buffer = ::Protobuf::Rpc::Buffer.new(:write)
          request_buffer.set_data(@request_data)
          @socket.write(request_buffer.write)
          @socket.flush
          log_debug { sign_message("write closed") }
        end

      end
    end
  end
end
