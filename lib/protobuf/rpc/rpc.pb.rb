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
    class ErrorReason
      define :BAD_REQUEST_DATA, 0
      define :BAD_REQUEST_PROTO, 1
      define :SERVICE_NOT_FOUND, 2
      define :METHOD_NOT_FOUND, 3
      define :RPC_ERROR, 4
      define :RPC_FAILED, 5
      define :INVALID_REQUEST_PROTO, 6
      define :BAD_RESPONSE_PROTO, 7
      define :UNKNOWN_HOST, 8
      define :IO_ERROR, 9
    end
    
    ##
    # Message Fields
    #
    class Request
      required ::Protobuf::Field::StringField, :service_name, 1
      required ::Protobuf::Field::StringField, :method_name, 2
      optional ::Protobuf::Field::BytesField, :request_proto, 3
      optional ::Protobuf::Field::StringField, :caller, 4
    end
    
    class Response
      optional ::Protobuf::Field::BytesField, :response_proto, 1
      optional ::Protobuf::Field::StringField, :error, 2
      optional ::Protobuf::Field::BoolField, :callback, 3, :default => false
      optional ::Protobuf::Socketrpc::ErrorReason, :error_reason, 4
    end
    
  end
end
