##
# This file is auto-generated. DO NOT EDIT!
#
require 'protobuf/message'
require 'protobuf/rpc/service'

module Test
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
  ::Test::StatusType.define :PENDING, 0
  ::Test::StatusType.define :ENABLED, 1
  ::Test::StatusType.define :DISABLED, 2
  ::Test::StatusType.define :DELETED, 3
  
  
  ##
  # Message Fields
  #
  ::Test::ResourceFindRequest.required(::Protobuf::Field::StringField, :name, 1)
  ::Test::ResourceFindRequest.optional(::Protobuf::Field::BoolField, :active, 2)
  
  ::Test::Resource.required(::Protobuf::Field::StringField, :name, 1)
  ::Test::Resource.optional(::Protobuf::Field::Int64Field, :date_created, 2)
  ::Test::Resource.optional(::Test::StatusType, :status, 3)
  ::Test::Resource.repeated(::Test::StatusType, :repeated_enum, 4)
  
  ::Test::Nested.optional(::Protobuf::Field::StringField, :name, 1)
  ::Test::Nested.optional(::Test::Resource, :resource, 2)
  ::Test::Nested.repeated(::Test::Resource, :multiple_resources, 3)
  ::Test::Nested.optional(::Test::StatusType, :status, 4)
  
  
  ##
  # Services
  #
  class ResourceService < ::Protobuf::Rpc::Service
    rpc :find, ::Test::ResourceFindRequest, ::Test::Resource
  end
end
