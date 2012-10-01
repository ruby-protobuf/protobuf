##
# This file is auto-generated. DO NOT EDIT!
#
require 'protobuf/message'
require 'protobuf/rpc/service'

module Spec
  module Proto
    ##
    # Enum Classes
    #
    class StatusType < ::Protobuf::Enum; end
    
    ##
    # Message Classes
    #
    class ResourceFindRequest < ::Protobuf::Message; end
    class Resource < ::Protobuf::Message; end
    class Nested < ::Protobuf::Message; end
    
    ##
    # Enum Values
    #
    ::Spec::Proto::StatusType.define :PENDING, 0
    ::Spec::Proto::StatusType.define :ENABLED, 1
    ::Spec::Proto::StatusType.define :DISABLED, 2
    ::Spec::Proto::StatusType.define :DELETED, 3
    
    
    ##
    # Message Fields
    #
    ::Spec::Proto::ResourceFindRequest.required(::Protobuf::Field::StringField, :name, 1)
    ::Spec::Proto::ResourceFindRequest.optional(::Protobuf::Field::BoolField, :active, 2)
    
    ::Spec::Proto::Resource.required(::Protobuf::Field::StringField, :name, 1)
    ::Spec::Proto::Resource.optional(::Protobuf::Field::Int64Field, :date_created, 2)
    ::Spec::Proto::Resource.optional(::Spec::Proto::StatusType, :status, 3)
    ::Spec::Proto::Resource.repeated(::Spec::Proto::StatusType, :repeated_enum, 4)
    
    ::Spec::Proto::Nested.optional(::Protobuf::Field::StringField, :name, 1)
    ::Spec::Proto::Nested.optional(::Spec::Proto::Resource, :resource, 2)
    ::Spec::Proto::Nested.repeated(::Spec::Proto::Resource, :multiple_resources, 3)
    ::Spec::Proto::Nested.optional(::Spec::Proto::StatusType, :status, 4)
    
    
    ##
    # Services
    #
    class TestService < ::Protobuf::Rpc::Service
      rpc :find, ::Spec::Proto::ResourceFindRequest, ::Spec::Proto::Resource
    end
  end
end
