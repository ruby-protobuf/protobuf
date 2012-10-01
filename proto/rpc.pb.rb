##
# This file is auto-generated. DO NOT EDIT!
#
require 'protobuf/message'

module Protobuf
  module Socketrpc
    ##
    # Enum Classes
    #
    class ErrorReason < ::Protobuf::Enum; end
    
    ##
    # Message Classes
    #
    class Request < ::Protobuf::Message; end
    class Response < ::Protobuf::Message; end
    
    ##
    # Enum Values
    #
    ::Protobuf::Socketrpc::ErrorReason.define :BAD_REQUEST_DATA, 0
    ::Protobuf::Socketrpc::ErrorReason.define :BAD_REQUEST_PROTO, 1
    ::Protobuf::Socketrpc::ErrorReason.define :SERVICE_NOT_FOUND, 2
    ::Protobuf::Socketrpc::ErrorReason.define :METHOD_NOT_FOUND, 3
    ::Protobuf::Socketrpc::ErrorReason.define :RPC_ERROR, 4
    ::Protobuf::Socketrpc::ErrorReason.define :RPC_FAILED, 5
    ::Protobuf::Socketrpc::ErrorReason.define :INVALID_REQUEST_PROTO, 6
    ::Protobuf::Socketrpc::ErrorReason.define :BAD_RESPONSE_PROTO, 7
    ::Protobuf::Socketrpc::ErrorReason.define :UNKNOWN_HOST, 8
    ::Protobuf::Socketrpc::ErrorReason.define :IO_ERROR, 9
    
    
    ##
    # Message Fields
    #
    ::Protobuf::Socketrpc::Request.required(::Protobuf::Field::StringField, :service_name, 1)
    ::Protobuf::Socketrpc::Request.required(::Protobuf::Field::StringField, :method_name, 2)
    ::Protobuf::Socketrpc::Request.required(::Protobuf::Field::BytesField, :request_proto, 3)
    
    ::Protobuf::Socketrpc::Response.optional(::Protobuf::Field::BytesField, :response_proto, 1)
    ::Protobuf::Socketrpc::Response.optional(::Protobuf::Field::StringField, :error, 2)
    ::Protobuf::Socketrpc::Response.optional(::Protobuf::Field::BoolField, :callback, 3, :default => false)
    ::Protobuf::Socketrpc::Response.optional(::Protobuf::Socketrpc::ErrorReason, :error_reason, 4)
    
    
  end
end
