require 'protobuf/rpc/connectors/base'

module Protobuf
  module Rpc
    module Connectors
      class Zmq < Base
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

        def assert(return_code)
          raise "Last API call failed at #{caller(1)}" unless return_code >= 0
        end

        def check_async
          if async?
            log_error "[client-#{self.class}] Cannot run in async mode"
            raise "Cannot use Zmq client in async mode" 
          else
            log_debug "[client-#{self.class}] Async check passed" 
          end
        end

        def close_connection
          @socket.close
          log_debug "[client-#{self.class}] Connector closed" 
        end

        def connect_to_rpc_server
          zmq_context = ZMQ::Context.new
          @socket = zmq_context.socket(ZMQ::REQ)
          assert(@socket.connect("tcp://#{options[:host]}:#{options[:port]}"))
          log_debug "[client-#{self.class}] Connection established #{options[:host]}:#{options[:port]}" 
        end

        # Method to determine error state, must be used with Connector api
        def error?
          false
        end

        def read_response
          assert(@socket.recv_string(@buffer.data))
          @buffer.size = @buffer.data.size
        end

        def send_data(data)
          assert(@socket.send_string(data.split("-")[1]))
          log_debug "[client-#{self.class}] write closed" 
        end

      end
    end
  end
end
