##
# This file is auto-generated. DO NOT EDIT!
#
require 'protobuf/message'
require 'protobuf/rpc/service'

module Test

  ##
  # Enum Classes
  #
  class StatusType < ::Protobuf::Enum
    define :PENDING, 0
    define :ENABLED, 1
    define :DISABLED, 2
    define :DELETED, 3
  end
  
  
  ##
  # Message Classes
  #
  class ResourceFindRequest < ::Protobuf::Message; end
  class Resource < ::Protobuf::Message; end
  class Searchable < ::Protobuf::Message
    class SearchType < ::Protobuf::Enum
      define :FLAT, 1
      define :NESTED, 2
    end
    
  end
  class MessageParent < ::Protobuf::Message
    class MessageChild < ::Protobuf::Message; end
  end
  class Nested < ::Protobuf::Message
    class NestedLevelOne < ::Protobuf::Message; end
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
    
    # Extension Fields
    extensions 100...536870912
    optional ::Protobuf::Field::BoolField, :ext_is_searchable, 100, :extension => true
    optional ::Protobuf::Field::BoolField, :ext_is_hidden, 101, :extension => true
    optional ::Test::Searchable::SearchType, :ext_search_type, 102, :default => ::Test::Searchable::SearchType::FLAT, :extension => true
    optional ::Protobuf::Field::BoolField, :ext_nested_in_level_one, 105, :extension => true
    optional ::Protobuf::Field::BoolField, :ext_dup_field, 106, :extension => true
    optional ::Protobuf::Field::BoolField, :ext_dup_field, 107, :extension => true
  end
  
  class MessageParent
    class MessageChild
      optional ::Protobuf::Field::StringField, :child1, 1
    end
    
  end
  
  class Nested
    class NestedLevelOne
      optional ::Protobuf::Field::BoolField, :level_one, 1, :default => true
      
      # Extension Fields
      extensions 100...102
      optional ::Protobuf::Field::BoolField, :ext_nested_level_one_outer, 101, :extension => true
      optional ::Protobuf::Field::BoolField, :ext_nested_level_one, 100, :extension => true
    end
    
    optional ::Protobuf::Field::StringField, :name, 1
    optional ::Test::Resource, :resource, 2
    repeated ::Test::Resource, :multiple_resources, 3
    optional ::Test::StatusType, :status, 4
    
    # Extension Fields
    extensions 100...111
    optional ::Protobuf::Field::StringField, :foo, 100, :extension => true
    optional ::Protobuf::Field::Int64Field, :bar, 101, :extension => true
  end
  
  
  ##
  # Services
  #
  class ResourceService < ::Protobuf::Rpc::Service
    rpc :find, ::Test::ResourceFindRequest, ::Test::Resource
  end
end

