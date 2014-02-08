require 'protobuf/rpc/server'

module Protobuf
  module Rpc
    module Evented
      class Server < ::EventMachine::Connection
        include ::Protobuf::Rpc::Server
        include ::Protobuf::Logger::LogMethods

        # Initialize a new read buffer for storing client request info
        def post_init
          initialize_request!
          @request_buffer = Protobuf::Rpc::Buffer.new(:read)
        end

        # Receive a chunk of data, potentially flushed to handle_client
        def receive_data(data)
          log_debug { sign_message("receive_data: #{data}") }

          @request_buffer << data
          @request_data = @request_buffer.data

          if @request_buffer.flushed?
            gc_pause do
              @response = handle_client
              send_data
            end
          end
        end

        def send_data
          response_buffer = Protobuf::Rpc::Buffer.new(:write)
          response_buffer.set_data(@response)
          @stats.response_size = response_buffer.size
          log_debug { sign_message("sending data: #{response_buffer.inspect}") }
          super(response_buffer.write)
        end
      end
    end
  end
end
