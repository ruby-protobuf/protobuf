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
  class Extended < ::Protobuf::Message; end
  class Nested < ::Protobuf::Message; end
  
  ##
  # Enum Values
  #
  class StatusType
    define :PENDING, 0
    define :ENABLED, 1
    define :DISABLED, 2
    define :DELETED, 3
  end
  
  ##
  # Message Fields
  #
  class ResourceFindRequest
    required ::Protobuf::Field::StringField, :name, 1
    optional ::Protobuf::Field::BoolField, :active, 2
  end
  
  class Resource
    required ::Protobuf::Field::StringField, :name, 1
    optional ::Protobuf::Field::Int64Field, :date_created, 2
    optional ::Test::StatusType, :status, 3
    repeated ::Test::StatusType, :repeated_enum, 4
  end
  
  class Nested
    optional ::Protobuf::Field::StringField, :name, 1
    optional ::Test::Resource, :resource, 2
    repeated ::Test::Resource, :multiple_resources, 3
    optional ::Test::StatusType, :status, 4
  end
  
  ##
  # Services
  #
  class ResourceService < ::Protobuf::Rpc::Service
    rpc :find, ::Test::ResourceFindRequest, ::Test::Resource
  end
end
