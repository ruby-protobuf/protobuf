require 'protobuf/rpc/connectors/base'
require 'protobuf/rpc/service_directory'

module Protobuf
  module Rpc
    module Connectors
      class Zmq < Base
        include Protobuf::Rpc::Connectors::Common
        include Protobuf::Logger::LogMethods

        def send_request
          timeout_wrap do
            setup_connection
            connect_to_rpc_server
            post_init
            read_response
          end
        ensure
          @socket.try :close
          @zmq_context.try :terminate
          @zmq_context = nil
        end

        def log_signature
          @_log_signature ||= "[client-#{self.class}]"
        end

        def service_directory
          ::Protobuf::Rpc::ServiceDirectory.instance
        end

        def service_uri
          if service_directory.running?
            address, port = service_directory.find options[:service]
          else
            address, port = options[:host], options[:port]
          end

          "tcp://#{address}:#{port}"
        end

        private

        def close_connection
          return if @error
          zmq_error_check(@socket.close)
          zmq_error_check(@zmq_context.terminate)
          log_debug { sign_message("Connector closed")  }
        end

        def connect_to_rpc_server
          return if @error
          log_debug { sign_message("Establishing connection: #{service_uri}") }
          @zmq_context = ::ZMQ::Context.new
          @socket = @zmq_context.socket(::ZMQ::REQ)
          zmq_error_check(@socket.connect(service_uri))
          log_debug { sign_message("Connection established #{service_uri}") }
        end

        # Method to determine error state, must be used with Connector api
        def error?
          !!@error
        end

        def read_response
          return if @error
          @response_data = ''
          zmq_error_check(@socket.recv_string(@response_data))
          parse_response
        end

        def send_data
          return if @error
          log_debug { sign_message("Sending Request: #{@request_data}") }
          @stats.request_size = @request_data.size
          zmq_error_check(@socket.send_string(@request_data))
          log_debug { sign_message("write closed") }
        end

        def zmq_error_check(return_code)
          raise "Last API call failed at #{caller(1)}" unless return_code >= 0
        end
      end
    end
  end
end
