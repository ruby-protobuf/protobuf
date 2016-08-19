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
          Protobuf::Socketrpc::ErrorReason::UNAUTHORIZED_REQUEST => 401,
          Protobuf::Socketrpc::ErrorReason::FORBIDDEN_REQUEST => 403,
          Protobuf::Socketrpc::ErrorReason::SERVICE_NOT_FOUND => 404,
          Protobuf::Socketrpc::ErrorReason::METHOD_NOT_FOUND => 404,
          Protobuf::Socketrpc::ErrorReason::DATA_NOT_FOUND => 404,
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
          if path_components.length < 2
            return protobuf_http_response 400,
              :error => "Expected path format /CLASS/METHOD",
              :reason => Protobuf::Socketrpc::ErrorReason::INVALID_REQUEST_PROTO
          end

          service_name = path_components[0..-2].join("::")
          method_name = path_components[-1]

          rpc_request = ::Protobuf::Socketrpc::Request.new(
            :service_name => service_name,
            :method_name => method_name,
            :request_proto => env['rack.input'].read,
            :caller => env['HTTP_X_PROTOBUF_CALLER'] || ''
          )

          encoded_request = rpc_request.encode()

          begin
            encoded_response = handle_request(encoded_request, env)
          rescue Exception => e
            return protobuf_http_response 500,
              :error => "Handle request failed: #{e.to_s}",
              :reason => Protobuf::Socketrpc::ErrorReason::RPC_ERROR
          end

          rpc_response = Protobuf::Socketrpc::Response.decode(encoded_response)

          if rpc_response[:error].length > 0
            status = HTTP_STATUSES[rpc_response[:error_reason]] or 500
            return protobuf_http_response status,
              :error => rpc_response[:error],
              :reason => rpc_response[:error_reason]
          end
          
          return protobuf_http_response 200, :body => rpc_response['response_proto']
        end

        def protobuf_http_response(status, options)
          response = [status, { 'Content-Type' => 'application/x-protobuf' }, []]
          response[1]['X-Protobuf-Error'] = options[:error] unless options[:error].nil?
          response[1]['X-Protobuf-Error-Reason'] = options[:reason].to_s unless options[:reason].nil?
          response[2] = [options[:body]] unless options[:body].nil?
          response
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
