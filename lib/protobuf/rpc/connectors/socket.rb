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
          if async?
            log_error "[client-#{self.class}] Cannot run in async mode"
            raise "Cannot use Socket client in async mode" 
          else
            log_debug "[client-#{self.class}] Async check passed" 
         end
        end

        def close_connection
          @socket.close
          log_debug "[client-#{self.class}] Connector closed" 
        end

        def connect_to_rpc_server
          @socket = TCPSocket.new(options[:host], options[:port])
          log_debug "[client-#{self.class}] Connection established #{options[:host]}:#{options[:port]}" 
        end

        # Method to determine error state, must be used with Connector api
        def error?
          @socket.closed?
          log_debug "[client-#{self.class}] Error state : #{@socket.closed?}" 
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
          log_debug "[client-#{self.class}] Write closed." 
        end

      end
    end
  end
end
