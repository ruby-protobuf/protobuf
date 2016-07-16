require "net/http"
require "uri"
require "protobuf/rpc/connectors/base"

module Protobuf
  module Rpc
    module Connectors
      class HTTP < Base
        include Protobuf::Rpc::Connectors::Common

        def send_request
          setup_connection
          send_over_http
          parse_response
        end

      private

        def send_over_http
          uri = URI.parse("http://#{options[:host]}:#{options[:port]}/")
          http = Net::HTTP.new(uri.host, uri.port)
          request = Net::HTTP::Post.new("/")
          request["Accept"] = "application/x-protobuf"
          request["Content-Type"] = "application/x-protobuf"
          request.body = @request_data
          response = http.request(request)
          @response_data = response.body
        end

        def close_connection
          # no-op
        end

      end
    end
  end
end
