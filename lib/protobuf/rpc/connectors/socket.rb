require 'protobuf/rpc/connectors/base'

module Protobuf
  module Rpc
    module Connectors
      class Socket < Base
        include Protobuf::Rpc::Connectors::Common
        include Protobuf::Logger::LogMethods

        def send_request
          check_async
          setup_connection
          connect_to_rpc_server
          post_init
          read_response
        end

        private

        def check_async
          if async?
            log_error { "[client-#{self.class}] Cannot run in async mode" }
            raise "Cannot use Socket client in async mode"
          end
        end

        def close_connection
          @socket.close
          log_debug { "[client-#{self.class}] Connector closed"  }
        end

        def connect_to_rpc_server
          return if(@error)
          @socket = TCPSocket.new(options[:host], options[:port])
          log_debug { "[client-#{self.class}] Connection established #{options[:host]}:#{options[:port]}"  }
        end

        # Method to determine error state, must be used with Connector api
        def error?
          return true if(@error)
          log_debug { "[client-#{self.class}] Error state : #{@socket.closed?}"  }
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
          return if(@error)
          response_buffer = ::Protobuf::Rpc::Buffer.new(:read)
          response_buffer << read_data
          @stats.response_size = response_buffer.size
          @response_data = response_buffer.write
          parse_response if response_buffer.flushed?
        end

        def send_data
          return if(@error)
          request_buffer = ::Protobuf::Rpc::Buffer.new(:write)
          request_buffer.set_data(request_wrapper)
          @socket.write(request_buffer.write)
          @socket.flush
          log_debug { "[client-#{self.class}] write closed"  }
        end

      end
    end
  end
end
