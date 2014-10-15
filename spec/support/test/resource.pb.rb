# encoding: utf-8

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
  class ResourceSleepRequest < ::Protobuf::Message; end
  class Resource < ::Protobuf::Message; end
  class ResourceWithRequiredField < ::Protobuf::Message; end
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
    required :string, :name, 1
    optional :bool, :active, 2
    repeated :string, :widgets, 3
    repeated :bytes, :widget_bytes, 4
  end

  class ResourceSleepRequest
    optional :int32, :sleep, 1
  end

  class Resource
    required :string, :name, 1
    optional :int64, :date_created, 2
    optional ::Test::StatusType, :status, 3
    repeated ::Test::StatusType, :repeated_enum, 4
    # Extension Fields
    extensions 100...536870912
    optional :bool, :ext_is_searchable, 100, :extension => true
    optional :bool, :ext_is_hidden, 101, :extension => true
    optional ::Test::Searchable::SearchType, :ext_search_type, 102, :default => ::Test::Searchable::SearchType::FLAT, :extension => true
    optional :bool, :ext_nested_in_level_one, 105, :extension => true
    optional :bool, :ext_dup_field, 106, :extension => true
  end

  class ResourceWithRequiredField
    required :string, :foo_is_required, 1
  end

  class MessageParent
    class MessageChild
      optional :string, :child1, 1
    end

  end

  class Nested
    class NestedLevelOne
      optional :bool, :level_one, 1, :default => true
      # Extension Fields
      extensions 100...102
      optional :bool, :ext_nested_level_one_outer, 101, :extension => true
      optional :bool, :ext_nested_level_one, 100, :extension => true
    end

    optional :string, :name, 1
    optional ::Test::Resource, :resource, 2
    repeated ::Test::Resource, :multiple_resources, 3
    optional ::Test::StatusType, :status, 4
    # Extension Fields
    extensions 100...111
    optional :string, :foo, 100, :extension => true
    optional :int64, :bar, 101, :extension => true
  end


  ##
  # Service Classes
  #
  class ResourceService < ::Protobuf::Rpc::Service
    rpc :find, ::Test::ResourceFindRequest, ::Test::Resource
    rpc :find_with_rpc_failed, ::Test::ResourceFindRequest, ::Test::Resource
    rpc :find_with_sleep, ::Test::ResourceSleepRequest, ::Test::Resource
    rpc :find_not_implemented, ::Test::ResourceFindRequest, ::Test::Resource
  end

end

