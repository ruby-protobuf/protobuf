require 'protobuf/rpc/server'

require 'rack'
require 'rack/server'

module Protobuf
  module Rpc
    module Http
      class Server
        include ::Protobuf::Rpc::Server
        include ::Protobuf::Logger::LogMethods

        # TODO: more comprehensive mapping?
        HTTP_STATUSES = {
          Protobuf::Socketrpc::ErrorReason::BAD_REQUEST_DATA => 400,
          Protobuf::Socketrpc::ErrorReason::BAD_REQUEST_PROTO => 400,
          Protobuf::Socketrpc::ErrorReason::SERVICE_NOT_FOUND => 404,
          Protobuf::Socketrpc::ErrorReason::METHOD_NOT_FOUND => 404,
          Protobuf::Socketrpc::ErrorReason::RPC_ERROR => 500,
          Protobuf::Socketrpc::ErrorReason::RPC_FAILED => 500,
          Protobuf::Socketrpc::ErrorReason::INVALID_REQUEST_PROTO => 500,
          Protobuf::Socketrpc::ErrorReason::BAD_RESPONSE_PROTO => 500,
          Protobuf::Socketrpc::ErrorReason::UNKNOWN_HOST => 500,
          Protobuf::Socketrpc::ErrorReason::IO_ERROR => 500
        }

        def initialize(options = {})
          @options = options
        end

        def log_signature
          @_log_signature ||= "[http-server-#{self.class.name}]"
        end

        def call(env)
          path_components = env['PATH_INFO'].split("/").map{ |x| CGI::unescape(x) }.compact.reject{ |x| x.empty? }
          if path_components.length != 2
            headers = {
              'Content-Type' => 'application/x-protobuf',
              'X-Protobuf-Error' => "Expected 2 path components, got #{path_components.length.to_s}",
              'X-Protobuf-Error-Reason' => Protobuf::Socketrpc::ErrorReason::INVALID_REQUEST_PROTO.to_s
            }
            return [400, headers, []]
          end

          rpc_request = ::Protobuf::Socketrpc::Request.new(
            :service_name => path_components[0],
            :method_name => path_components[1],
            :request_proto => env['rack.input'].read,
            :caller => env['HTTP_X_PROTOBUF_CALLER'] || ''
          )

          encoded_request = rpc_request.encode()
          encoded_response = handle_request(encoded_request)

          rpc_response = Protobuf::Socketrpc::Response.decode(encoded_response)

          status = 200
          headers = {
            'Content-Type' => 'application/x-protobuf',
          }

          if rpc_response[:error].length > 0
            headers['X-Protobuf-Error'] = rpc_response[:error]
            headers['X-Protobuf-Error-Reason'] = rpc_response[:error_reason].to_s
            status = HTTP_STATUSES[rpc_response[:error_reason]] or 500
          end
          
          [status, headers, [rpc_response['response_proto']]]
        end

        def run
          Rack::Server.start(
            :app => self,
            :Host => @options[:host],
            :Port => @options[:port]
          )
          @running = true
        end

        def running?
          !!@running
        end

        def stop
        end
      end
    end
  end
end
