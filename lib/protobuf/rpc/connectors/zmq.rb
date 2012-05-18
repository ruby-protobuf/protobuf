require 'protobuf/rpc/connectors/base'

module Protobuf
  module Rpc
    module Connectors
      class Zmq < Base
        include Protobuf::Rpc::Connectors::Common
        include Protobuf::Logger::LogMethods

        def send_request
          check_async
          setup_connection
          connect_to_rpc_server
          post_init
          read_response
        ensure
          @socket.close if @socket
          @zmq_context.terminate if @zmq_context
          @zmq_context = nil
        end

        private

        def check_async
          if async?
            log_error { "[client-#{self.class}] Cannot run in async mode" }
            raise "Cannot use Zmq client in async mode" 
          end
        end

        def close_connection
          zmq_error_check(@socket.close)
          zmq_error_check(@zmq_context.terminate)
          log_debug { "[client-#{self.class}] Connector closed"  }
        end

        def connect_to_rpc_server
          @zmq_context = ZMQ::Context.new
          @socket = @zmq_context.socket(ZMQ::REQ)
          zmq_error_check(@socket.connect("tcp://#{options[:host]}:#{options[:port]}"))
          log_debug { "[client-#{self.class}] Connection established #{options[:host]}:#{options[:port]}" }
        end

        # Method to determine error state, must be used with Connector api
        def error?
          false
        end

        def read_response
          zmq_error_check(@socket.recv_string(@response_buffer.data))
          @response_buffer.get_data_size
          parse_response
        end

        def send_data
          log_debug { "[#{log_signature}] Sending Request: %s" % @request_buffer.write }
          @stats.request_size = @request_buffer.size
          zmq_error_check(@socket.send_string(@request_buffer.write))
          log_debug { "[client-#{self.class}] write closed" }
        end

        def zmq_error_check(return_code)
          raise "Last API call failed at #{caller(1)}" unless return_code >= 0
        end
      end
    end
  end
end
