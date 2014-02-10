require 'protobuf/rpc/rpc.pb'

module Protobuf
  module Rpc
    ClientError = Struct.new("ClientError", :code, :message)

    # Base PbError class for client and server errors
    class PbError < StandardError
      attr_reader :error_type

      def initialize(message='An unknown RpcError occurred', error_type='RPC_ERROR')
        @error_type = error_type.is_a?(String) ? Socketrpc::ErrorReason.const_get(error_type) : error_type
        super message
      end

      def to_response(response=nil)
        if response
$stderr.puts <<-WARN
  [DEPRECATED] Passing response wrappers when converting errors to responses is deprecated.
               Versions >= 3.0 will no longer provide this interface and will simply
               initialize a response wrapper and return it.
WARN
        else
          response = Socketrpc::Response.new
        end

        response.error = message
        response.error_reason = error_type
        response
      end
    end
  end
end

require 'protobuf/rpc/error/server_error'
require 'protobuf/rpc/error/client_error'
