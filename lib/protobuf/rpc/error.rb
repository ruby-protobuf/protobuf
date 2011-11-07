require 'protobuf/rpc/rpc.pb'

module Protobuf
  module Rpc
    
    autoload :BadRequestData, 'protobuf/rpc/error/server_error'
    autoload :BadRequestProto, 'protobuf/rpc/error/server_error'
    autoload :ServiceNotFound, 'protobuf/rpc/error/server_error'
    autoload :MethodNotFound, 'protobuf/rpc/error/server_error'
    autoload :RpcError, 'protobuf/rpc/error/server_error'
    autoload :RpcFailed, 'protobuf/rpc/error/server_error'
    
    autoload :InvalidRequestProto, 'protobuf/rpc/error/client_error'
    autoload :BadResponseProto, 'protobuf/rpc/error/client_error'
    autoload :UnknownHost, 'protobuf/rpc/error/client_error'
    autoload :IOError, 'protobuf/rpc/error/client_error'
    
    # Base RpcError class for client and server errors
    class PbError < StandardError
      attr_reader :error_type
      
      def initialize message='An unknown RpcError occurred', error_type='RPC_ERROR'
        @error_type = error_type.is_a?(String) ? Protobuf::Socketrpc::ErrorReason.const_get(error_type) : error_type
        super message
      end
      
      def to_response response
        response.error = message
        response.error_reason = @error_type
      end
    end
    
  end
end