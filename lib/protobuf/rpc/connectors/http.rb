require 'protobuf/rpc/connectors/base'
require 'cgi'
require 'faraday'

module Protobuf
  module Rpc
    module Connectors
      class Http < Base
        include Protobuf::Rpc::Connectors::Common
        include Protobuf::Logger::LogMethods

        def send_request
          timeout_wrap do
            setup_connection
            post_init
          end
        end

        def log_signature
          @_log_signature ||= "[http-client-#{self.class.name}]"
        end

        # private

        def close_connection
          log_debug { sign_message('Connector closed')  }
        end

        # Method to determine error state, must be used with Connector api
        def error?
          log_debug { sign_message("Error state : #{@error}")  }
          if @error
            true
          else
            false
          end
        end

        def host
          'http://' + options[:host] + ':' + options[:port].to_s
        end

        def base
          options[:base] or ''
        end

        def client
          @_client ||= Faraday.new(:url => host)
        end

        def send_data
          rpc_request = ::Protobuf::Socketrpc::Request.decode(@request_data)

          http_response = client.post do |http_request|
            path_components = [''] + rpc_request[:service_name].split('::') + [rpc_request[:method_name]]
            http_request.url base + path_components.map{ |x| CGI::escape(x) }.join('/')
            http_request.headers['Content-Type'] = 'application/x-protobuf'
            http_request.headers['X-Protobuf-Caller'] = rpc_request[:caller] || ''
            http_request.body = rpc_request[:request_proto]
          end

          # Server returns protobuf response with no error
          if http_response.status == 200 and http_response.headers['x-protobuf-error'].nil?
            rpc_response = Protobuf::Socketrpc::Response.new(
              :response_proto => http_response.body
            )
          # Server returns protobuf error
          elsif http_response.status != 200 and not http_response.headers['x-protobuf-error'].nil?
            rpc_response = Protobuf::Socketrpc::Response.new(
              :response_proto => http_response.body,
              :error => http_response.headers['x-protobuf-error'],
              :error_reason => http_response.headers['x-protobuf-error-reason'].to_i
            )
          # Server didn't return a response or error
          else
            rpc_response = Protobuf::Socketrpc::Response.new(
              :response_proto => http_response.body,
              :error => "Bad response from the server.",
              :error_reason => Protobuf::Socketrpc::ErrorReason::BAD_RESPONSE_PROTO
            )
          end

          @response_data = rpc_response.encode()

          parse_response
        end
      end
    end
  end
end
