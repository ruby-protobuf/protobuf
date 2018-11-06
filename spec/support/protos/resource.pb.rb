# encoding: utf-8

##
# This file is auto-generated. DO NOT EDIT!
#
require 'protobuf'
require 'protobuf/rpc/service'


##
# Imports
#
require 'google/protobuf/descriptor.pb'

module Test
  ::Protobuf::Optionable.inject(self) { ::Google::Protobuf::FileOptions }

  ##
  # Enum Classes
  #
  class StatusType < ::Protobuf::Enum
    set_option :allow_alias, true
    set_option :".test.enum_option", -789

    define :PENDING, 0
    define :ENABLED, 1
    define :DISABLED, 2
    define :DELETED, 3
    define :ALIASED, 3
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
  # File Options
  #
  set_option :cc_generic_services, true
  set_option :".test.file_option", 9876543210


  ##
  # Message Fields
  #
  class ResourceFindRequest
    required :string, :name, 1
    
    def _protobuf_message_set_field_1_bytes(bytes)
      _protobuf_message_set_field_1(::Protobuf::Field::StringField.decode(bytes), true)
    end
    alias_method :_protobuf_message_set_field_name_bytes, :_protobuf_message_set_field_1_bytes
    
    def _protobuf_message_set_field_1(value, ignore_nil_for_repeated)
      if value.nil? # rubocop:disable Style/IfInsideElse
        @values.delete(:name)
      else
        @values[:name] = ::Protobuf::Field::BytesField.coerce!(value)
      end
    end
    alias_method :_protobuf_message_set_field_name, :_protobuf_message_set_field_1
    
    def _protobuf_message_encode_1_to_stream(value, stream)
      stream << [10].pack('C*') << ::Protobuf::Field::StringField.encode(value)
    end
    alias_method :_protobuf_message_encode_name_to_stream, :_protobuf_message_encode_1_to_stream
    
    optional :bool, :active, 2
    
    def _protobuf_message_set_field_2_bytes(bytes)
      _protobuf_message_set_field_2(::Protobuf::Field::BoolField.decode(bytes), true)
    end
    alias_method :_protobuf_message_set_field_active_bytes, :_protobuf_message_set_field_2_bytes
    
    def _protobuf_message_set_field_2(value, ignore_nil_for_repeated)
      if value.nil? # rubocop:disable Style/IfInsideElse
        @values.delete(:active)
      else
        @values[:active] = ::Protobuf::Field::BoolField.coerce!(value)
      end
    end
    alias_method :_protobuf_message_set_field_active, :_protobuf_message_set_field_2
    
    def _protobuf_message_encode_2_to_stream(value, stream)
      stream << [16].pack('C*') << ::Protobuf::Field::BoolField.encode(value)
    end
    alias_method :_protobuf_message_encode_active_to_stream, :_protobuf_message_encode_2_to_stream
    
    repeated :string, :widgets, 3
    
    def _protobuf_message_set_field_3_bytes(bytes)
      _protobuf_message_set_field_3(::Protobuf::Field::StringField.decode(bytes), true)
    end
    alias_method :_protobuf_message_set_field_widgets_bytes, :_protobuf_message_set_field_3_bytes
    
    def _protobuf_message_set_field_3(field, value, ignore_nil_for_repeated)
      if value.nil? && ignore_nil_for_repeated
        ::Protobuf.deprecator.deprecation_warning("[:widgets]=nil", "use an empty array instead of nil")
        return
      end
      unless value.is_a?(Array)
        fail TypeError, <<-TYPE_ERROR
            Expected repeated value of type :string
            Got #{value.class} for repeated protobuf field :widgets
        TYPE_ERROR
      end
    
      value = value.compact
    
      if value.empty?
        @values.delete(:widgets)
      else
        @values[:widgets] ||= ::Protobuf::Field::FieldArray.new(field)
        @values[:widgets].replace(value)
      end
    end
    alias_method :_protobuf_message_set_field_widgets, :_protobuf_message_set_field_3
    
    
    def _protobuf_message_encode_3_to_stream(_value, stream)
      _value.each do |value|
        stream << [26].pack('C*') << ::Protobuf::Field::StringField.encode(value)
      end
    end
    alias_method :_protobuf_message_encode_widgets_to_stream, :_protobuf_message_encode_3_to_stream
    
    repeated :bytes, :widget_bytes, 4
    
    def _protobuf_message_set_field_4_bytes(bytes)
      _protobuf_message_set_field_4(::Protobuf::Field::BytesField.decode(bytes), true)
    end
    alias_method :_protobuf_message_set_field_widget_bytes_bytes, :_protobuf_message_set_field_4_bytes
    
    def _protobuf_message_set_field_4(field, value, ignore_nil_for_repeated)
      if value.nil? && ignore_nil_for_repeated
        ::Protobuf.deprecator.deprecation_warning("[:widget_bytes]=nil", "use an empty array instead of nil")
        return
      end
      unless value.is_a?(Array)
        fail TypeError, <<-TYPE_ERROR
            Expected repeated value of type :bytes
            Got #{value.class} for repeated protobuf field :widget_bytes
        TYPE_ERROR
      end
    
      value = value.compact
    
      if value.empty?
        @values.delete(:widget_bytes)
      else
        @values[:widget_bytes] ||= ::Protobuf::Field::FieldArray.new(field)
        @values[:widget_bytes].replace(value)
      end
    end
    alias_method :_protobuf_message_set_field_widget_bytes, :_protobuf_message_set_field_4
    
    
    def _protobuf_message_encode_4_to_stream(_value, stream)
      _value.each do |value|
        stream << [34].pack('C*') << ::Protobuf::Field::BytesField.encode(value)
      end
    end
    alias_method :_protobuf_message_encode_widget_bytes_to_stream, :_protobuf_message_encode_4_to_stream
    
  end

  class ResourceSleepRequest
    optional :int32, :sleep, 1
    
    def _protobuf_message_set_field_1_bytes(bytes)
      _protobuf_message_set_field_1(::Protobuf::Field::Int32Field.decode(bytes), true)
    end
    alias_method :_protobuf_message_set_field_sleep_bytes, :_protobuf_message_set_field_1_bytes
    
    def _protobuf_message_set_field_1(value, ignore_nil_for_repeated)
      if value.nil? # rubocop:disable Style/IfInsideElse
        @values.delete(:sleep)
      else
        @values[:sleep] = ::Protobuf::Field::Int32Field.coerce!(value)
      end
    end
    alias_method :_protobuf_message_set_field_sleep, :_protobuf_message_set_field_1
    
    def _protobuf_message_encode_1_to_stream(value, stream)
      stream << [8].pack('C*') << ::Protobuf::Field::Int32Field.encode(value)
    end
    alias_method :_protobuf_message_encode_sleep_to_stream, :_protobuf_message_encode_1_to_stream
    
  end

  class Resource
    # Message Options
    #set_option :map_entry, false
    #set_option :".test.message_option", -56

    required :string, :name, 1, :ctype => ::Google::Protobuf::FieldOptions::CType::CORD, :".test.field_option" => 8765432109
    
    def _protobuf_message_set_field_1_bytes(bytes)
      _protobuf_message_set_field_1(::Protobuf::Field::StringField.decode(bytes), true)
    end
    alias_method :_protobuf_message_set_field_name_bytes, :_protobuf_message_set_field_1_bytes
    
    def _protobuf_message_set_field_1(value, ignore_nil_for_repeated)
      if value.nil? # rubocop:disable Style/IfInsideElse
        @values.delete(:name)
      else
        @values[:name] = ::Protobuf::Field::BytesField.coerce!(value)
      end
    end
    alias_method :_protobuf_message_set_field_name, :_protobuf_message_set_field_1
    
    def _protobuf_message_encode_1_to_stream(value, stream)
      stream << [10].pack('C*') << ::Protobuf::Field::StringField.encode(value)
    end
    alias_method :_protobuf_message_encode_name_to_stream, :_protobuf_message_encode_1_to_stream
    
    optional :int64, :date_created, 2
    
    def _protobuf_message_set_field_2_bytes(bytes)
      _protobuf_message_set_field_2(::Protobuf::Field::Int64Field.decode(bytes), true)
    end
    alias_method :_protobuf_message_set_field_date_created_bytes, :_protobuf_message_set_field_2_bytes
    
    def _protobuf_message_set_field_2(value, ignore_nil_for_repeated)
      if value.nil? # rubocop:disable Style/IfInsideElse
        @values.delete(:date_created)
      else
        @values[:date_created] = ::Protobuf::Field::Int64Field.coerce!(value)
      end
    end
    alias_method :_protobuf_message_set_field_date_created, :_protobuf_message_set_field_2
    
    def _protobuf_message_encode_2_to_stream(value, stream)
      stream << [16].pack('C*') << ::Protobuf::Field::Int64Field.encode(value)
    end
    alias_method :_protobuf_message_encode_date_created_to_stream, :_protobuf_message_encode_2_to_stream
    
    optional ::Test::StatusType, :status, 3
    
    def _protobuf_message_set_field_3_bytes(bytes)
      _protobuf_message_set_field_3(::Test::StatusType.fetch(::Protobuf::Field::IntegerField::decode(bytes)), true)
    end
    alias_method :_protobuf_message_set_field_status_bytes, :_protobuf_message_set_field_3_bytes
    
    def _protobuf_message_set_field_3(value, ignore_nil_for_repeated)
      if value.nil? # rubocop:disable Style/IfInsideElse
        @values.delete(:status)
      else
        @values[:status] = value
      end
    end
    alias_method :_protobuf_message_set_field_status, :_protobuf_message_set_field_3
    
    def _protobuf_message_encode_3_to_stream(value, stream)
      stream << [24].pack('C*') << ::Protobuf::Field::IntegerField::encode(value.to_i)
    end
    alias_method :_protobuf_message_encode_status_to_stream, :_protobuf_message_encode_3_to_stream
    
    repeated ::Test::StatusType, :repeated_enum, 4
    
    def _protobuf_message_set_field_4_bytes(bytes)
      _protobuf_message_set_field_4(::Test::StatusType.fetch(::Protobuf::Field::IntegerField::decode(bytes)), true)
    end
    alias_method :_protobuf_message_set_field_repeated_enum_bytes, :_protobuf_message_set_field_4_bytes
    
    def _protobuf_message_set_field_4(field, value, ignore_nil_for_repeated)
      if value.nil? && ignore_nil_for_repeated
        ::Protobuf.deprecator.deprecation_warning("[:repeated_enum]=nil", "use an empty array instead of nil")
        return
      end
      unless value.is_a?(Array)
        fail TypeError, <<-TYPE_ERROR
            Expected repeated value of type ::Test::StatusType
            Got #{value.class} for repeated protobuf field :repeated_enum
        TYPE_ERROR
      end
    
      value = value.compact
    
      if value.empty?
        @values.delete(:repeated_enum)
      else
        @values[:repeated_enum] ||= ::Protobuf::Field::FieldArray.new(field)
        @values[:repeated_enum].replace(value)
      end
    end
    alias_method :_protobuf_message_set_field_repeated_enum, :_protobuf_message_set_field_4
    
    
    def _protobuf_message_encode_4_to_stream(_value, stream)
      _value.each do |value|
        stream << [32].pack('C*') << ::Protobuf::Field::IntegerField::encode(value.to_i)
      end
    end
    alias_method :_protobuf_message_encode_repeated_enum_to_stream, :_protobuf_message_encode_4_to_stream
    
    # Extension Fields
#    extensions 100...536870912
#    optional :bool, :".test.Searchable.ext_is_searchable", 100, :extension => true
#    
#    def _protobuf_message_set_field_100_bytes(bytes)
#      _protobuf_message_set_field_100(::Protobuf::Field::BoolField.decode(bytes), true)
#    end
#    alias_method :_protobuf_message_set_field__test_Searchable_ext_is_searchable_bytes, :_protobuf_message_set_field_100_bytes
#    
#    def _protobuf_message_set_field_100(value, ignore_nil_for_repeated)
#      if value.nil? # rubocop:disable Style/IfInsideElse
#        @values.delete(:".test.Searchable.ext_is_searchable")
#      else
#        @values[:".test.Searchable.ext_is_searchable"] = ::Protobuf::Field::BoolField.coerce!(value)
#      end
#    end
#    alias_method :_protobuf_message_set_field__test_Searchable_ext_is_searchable, :_protobuf_message_set_field_100
#    
#    def _protobuf_message_encode_100_to_stream(value, stream)
#      stream << [160, 6].pack('C*') << ::Protobuf::Field::BoolField.encode(value)
#    end
#    alias_method :_protobuf_message_encode__test_Searchable_ext_is_searchable_to_stream, :_protobuf_message_encode_100_to_stream
#    
#    optional :bool, :".test.Searchable.ext_is_hidden", 101, :extension => true
#    
#    def _protobuf_message_set_field_101_bytes(bytes)
#      _protobuf_message_set_field_101(::Protobuf::Field::BoolField.decode(bytes), true)
#    end
#    alias_method :_protobuf_message_set_field__test_Searchable_ext_is_hidden_bytes, :_protobuf_message_set_field_101_bytes
#    
#    def _protobuf_message_set_field_101(value, ignore_nil_for_repeated)
#      if value.nil? # rubocop:disable Style/IfInsideElse
#        @values.delete(:".test.Searchable.ext_is_hidden")
#      else
#        @values[:".test.Searchable.ext_is_hidden"] = ::Protobuf::Field::BoolField.coerce!(value)
#      end
#    end
#    alias_method :_protobuf_message_set_field__test_Searchable_ext_is_hidden, :_protobuf_message_set_field_101
#    
#    def _protobuf_message_encode_101_to_stream(value, stream)
#      stream << [168, 6].pack('C*') << ::Protobuf::Field::BoolField.encode(value)
#    end
#    alias_method :_protobuf_message_encode__test_Searchable_ext_is_hidden_to_stream, :_protobuf_message_encode_101_to_stream
#    
#    optional ::Test::Searchable::SearchType, :".test.Searchable.ext_search_type", 102, :default => ::Test::Searchable::SearchType::FLAT, :extension => true
#    
#    def _protobuf_message_set_field_102_bytes(bytes)
#      _protobuf_message_set_field_102(::Test::Searchable::SearchType.fetch(::Protobuf::Field::IntegerField::decode(bytes)), true)
#    end
#    alias_method :_protobuf_message_set_field__test_Searchable_ext_search_type_bytes, :_protobuf_message_set_field_102_bytes
#    
#    def _protobuf_message_set_field_102(value, ignore_nil_for_repeated)
#      if value.nil? # rubocop:disable Style/IfInsideElse
#        @values.delete(:".test.Searchable.ext_search_type")
#      else
#        @values[:".test.Searchable.ext_search_type"] = value
#      end
#    end
#    alias_method :_protobuf_message_set_field__test_Searchable_ext_search_type, :_protobuf_message_set_field_102
#    
#    def _protobuf_message_encode_102_to_stream(value, stream)
#      stream << [176, 6].pack('C*') << ::Protobuf::Field::IntegerField::encode(value.to_i)
#    end
#    alias_method :_protobuf_message_encode__test_Searchable_ext_search_type_to_stream, :_protobuf_message_encode_102_to_stream
#    
#    optional :bool, :".test.Nested.NestedLevelOne.ext_nested_in_level_one", 105, :extension => true
#    
#    def _protobuf_message_set_field_105_bytes(bytes)
#      _protobuf_message_set_field_105(::Protobuf::Field::BoolField.decode(bytes), true)
#    end
#    alias_method :_protobuf_message_set_field__test_Nested_NestedLevelOne_ext_nested_in_level_one_bytes, :_protobuf_message_set_field_105_bytes
#    
#    def _protobuf_message_set_field_105(value, ignore_nil_for_repeated)
#      if value.nil? # rubocop:disable Style/IfInsideElse
#        @values.delete(:".test.Nested.NestedLevelOne.ext_nested_in_level_one")
#      else
#        @values[:".test.Nested.NestedLevelOne.ext_nested_in_level_one"] = ::Protobuf::Field::BoolField.coerce!(value)
#      end
#    end
#    alias_method :_protobuf_message_set_field__test_Nested_NestedLevelOne_ext_nested_in_level_one, :_protobuf_message_set_field_105
#    
#    def _protobuf_message_encode_105_to_stream(value, stream)
#      stream << [200, 6].pack('C*') << ::Protobuf::Field::BoolField.encode(value)
#    end
#    alias_method :_protobuf_message_encode__test_Nested_NestedLevelOne_ext_nested_in_level_one_to_stream, :_protobuf_message_encode_105_to_stream
#    
#    optional :bool, :".test.Nested.NestedLevelOne.ext_dup_field", 106, :extension => true
#    
#    def _protobuf_message_set_field_106_bytes(bytes)
#      _protobuf_message_set_field_106(::Protobuf::Field::BoolField.decode(bytes), true)
#    end
#    alias_method :_protobuf_message_set_field__test_Nested_NestedLevelOne_ext_dup_field_bytes, :_protobuf_message_set_field_106_bytes
#    
#    def _protobuf_message_set_field_106(value, ignore_nil_for_repeated)
#      if value.nil? # rubocop:disable Style/IfInsideElse
#        @values.delete(:".test.Nested.NestedLevelOne.ext_dup_field")
#      else
#        @values[:".test.Nested.NestedLevelOne.ext_dup_field"] = ::Protobuf::Field::BoolField.coerce!(value)
#      end
#    end
#    alias_method :_protobuf_message_set_field__test_Nested_NestedLevelOne_ext_dup_field, :_protobuf_message_set_field_106
#    
#    def _protobuf_message_encode_106_to_stream(value, stream)
#      stream << [208, 6].pack('C*') << ::Protobuf::Field::BoolField.encode(value)
#    end
#    alias_method :_protobuf_message_encode__test_Nested_NestedLevelOne_ext_dup_field_to_stream, :_protobuf_message_encode_106_to_stream
    
  end

  class ResourceWithRequiredField
    required :string, :foo_is_required, 1
    
    def _protobuf_message_set_field_1_bytes(bytes)
      _protobuf_message_set_field_1(::Protobuf::Field::StringField.decode(bytes), true)
    end
    alias_method :_protobuf_message_set_field_foo_is_required_bytes, :_protobuf_message_set_field_1_bytes
    
    def _protobuf_message_set_field_1(value, ignore_nil_for_repeated)
      if value.nil? # rubocop:disable Style/IfInsideElse
        @values.delete(:foo_is_required)
      else
        @values[:foo_is_required] = ::Protobuf::Field::BytesField.coerce!(value)
      end
    end
    alias_method :_protobuf_message_set_field_foo_is_required, :_protobuf_message_set_field_1
    
    def _protobuf_message_encode_1_to_stream(value, stream)
      stream << [10].pack('C*') << ::Protobuf::Field::StringField.encode(value)
    end
    alias_method :_protobuf_message_encode_foo_is_required_to_stream, :_protobuf_message_encode_1_to_stream
    
  end

  class MessageParent
    class MessageChild
      optional :string, :child1, 1
      
      def _protobuf_message_set_field_1_bytes(bytes)
        _protobuf_message_set_field_1(::Protobuf::Field::StringField.decode(bytes), true)
      end
      alias_method :_protobuf_message_set_field_child1_bytes, :_protobuf_message_set_field_1_bytes
      
      def _protobuf_message_set_field_1(value, ignore_nil_for_repeated)
        if value.nil? # rubocop:disable Style/IfInsideElse
          @values.delete(:child1)
        else
          @values[:child1] = ::Protobuf::Field::BytesField.coerce!(value)
        end
      end
      alias_method :_protobuf_message_set_field_child1, :_protobuf_message_set_field_1
      
      def _protobuf_message_encode_1_to_stream(value, stream)
        stream << [10].pack('C*') << ::Protobuf::Field::StringField.encode(value)
      end
      alias_method :_protobuf_message_encode_child1_to_stream, :_protobuf_message_encode_1_to_stream
      
    end

  end

  class Nested
    class NestedLevelOne
      optional :bool, :level_one, 1, :default => true
      
      def _protobuf_message_set_field_1_bytes(bytes)
        _protobuf_message_set_field_1(::Protobuf::Field::BoolField.decode(bytes), true)
      end
      alias_method :_protobuf_message_set_field_level_one_bytes, :_protobuf_message_set_field_1_bytes
      
      def _protobuf_message_set_field_1(value, ignore_nil_for_repeated)
        if value.nil? # rubocop:disable Style/IfInsideElse
          @values.delete(:level_one)
        else
          @values[:level_one] = ::Protobuf::Field::BoolField.coerce!(value)
        end
      end
      alias_method :_protobuf_message_set_field_level_one, :_protobuf_message_set_field_1
      
      def _protobuf_message_encode_1_to_stream(value, stream)
        stream << [8].pack('C*') << ::Protobuf::Field::BoolField.encode(value)
      end
      alias_method :_protobuf_message_encode_level_one_to_stream, :_protobuf_message_encode_1_to_stream
      
      # Extension Fields
      extensions 100...102
      optional :bool, :".test.ext_nested_level_one_outer", 101, :extension => true
      
      def _protobuf_message_set_field_101_bytes(bytes)
        _protobuf_message_set_field_101(::Protobuf::Field::BoolField.decode(bytes), true)
      end
      alias_method :_protobuf_message_set_field__test_ext_nested_level_one_outer_bytes, :_protobuf_message_set_field_101_bytes
      
      def _protobuf_message_set_field_101(value, ignore_nil_for_repeated)
        if value.nil? # rubocop:disable Style/IfInsideElse
          @values.delete(:".test.ext_nested_level_one_outer")
        else
          @values[:".test.ext_nested_level_one_outer"] = ::Protobuf::Field::BoolField.coerce!(value)
        end
      end
      alias_method :_protobuf_message_set_field__test_ext_nested_level_one_outer, :_protobuf_message_set_field_101
      
      def _protobuf_message_encode_101_to_stream(value, stream)
        stream << [168, 6].pack('C*') << ::Protobuf::Field::BoolField.encode(value)
      end
      alias_method :_protobuf_message_encode__test_ext_nested_level_one_outer_to_stream, :_protobuf_message_encode_101_to_stream
      
      optional :bool, :".test.Nested.ext_nested_level_one", 100, :extension => true
      
      def _protobuf_message_set_field_100_bytes(bytes)
        _protobuf_message_set_field_100(::Protobuf::Field::BoolField.decode(bytes), true)
      end
      alias_method :_protobuf_message_set_field__test_Nested_ext_nested_level_one_bytes, :_protobuf_message_set_field_100_bytes
      
      def _protobuf_message_set_field_100(value, ignore_nil_for_repeated)
        if value.nil? # rubocop:disable Style/IfInsideElse
          @values.delete(:".test.Nested.ext_nested_level_one")
        else
          @values[:".test.Nested.ext_nested_level_one"] = ::Protobuf::Field::BoolField.coerce!(value)
        end
      end
      alias_method :_protobuf_message_set_field__test_Nested_ext_nested_level_one, :_protobuf_message_set_field_100
      
      def _protobuf_message_encode_100_to_stream(value, stream)
        stream << [160, 6].pack('C*') << ::Protobuf::Field::BoolField.encode(value)
      end
      alias_method :_protobuf_message_encode__test_Nested_ext_nested_level_one_to_stream, :_protobuf_message_encode_100_to_stream
      
    end

    optional :string, :name, 1
    
    def _protobuf_message_set_field_1_bytes(bytes)
      _protobuf_message_set_field_1(::Protobuf::Field::StringField.decode(bytes), true)
    end
    alias_method :_protobuf_message_set_field_name_bytes, :_protobuf_message_set_field_1_bytes
    
    def _protobuf_message_set_field_1(value, ignore_nil_for_repeated)
      if value.nil? # rubocop:disable Style/IfInsideElse
        @values.delete(:name)
      else
        @values[:name] = ::Protobuf::Field::BytesField.coerce!(value)
      end
    end
    alias_method :_protobuf_message_set_field_name, :_protobuf_message_set_field_1
    
    def _protobuf_message_encode_1_to_stream(value, stream)
      stream << [10].pack('C*') << ::Protobuf::Field::StringField.encode(value)
    end
    alias_method :_protobuf_message_encode_name_to_stream, :_protobuf_message_encode_1_to_stream
    
    optional ::Test::Resource, :resource, 2
    
    def _protobuf_message_set_field_2_bytes(bytes)
      _protobuf_message_set_field_2(::Test::Resource.decode(bytes), true)
    end
    alias_method :_protobuf_message_set_field_resource_bytes, :_protobuf_message_set_field_2_bytes
    
    def _protobuf_message_set_field_2(value, ignore_nil_for_repeated)
      if value.nil? # rubocop:disable Style/IfInsideElse
        @values.delete(:resource)
      else
        @values[:resource] = value
      end
    end
    alias_method :_protobuf_message_set_field_resource, :_protobuf_message_set_field_2
    
    def _protobuf_message_encode_2_to_stream(value, stream)
      stream << [18].pack('C*') << ::Test::Resource.encode(value)
    end
    alias_method :_protobuf_message_encode_resource_to_stream, :_protobuf_message_encode_2_to_stream
    
    repeated ::Test::Resource, :multiple_resources, 3
    
    def _protobuf_message_set_field_3_bytes(bytes)
      _protobuf_message_set_field_3(::Test::Resource.decode(bytes), true)
    end
    alias_method :_protobuf_message_set_field_multiple_resources_bytes, :_protobuf_message_set_field_3_bytes
    
    def _protobuf_message_set_field_3(field, value, ignore_nil_for_repeated)
      if value.nil? && ignore_nil_for_repeated
        ::Protobuf.deprecator.deprecation_warning("[:multiple_resources]=nil", "use an empty array instead of nil")
        return
      end
      unless value.is_a?(Array)
        fail TypeError, <<-TYPE_ERROR
            Expected repeated value of type ::Test::Resource
            Got #{value.class} for repeated protobuf field :multiple_resources
        TYPE_ERROR
      end
    
      value = value.compact
    
      if value.empty?
        @values.delete(:multiple_resources)
      else
        @values[:multiple_resources] ||= ::Protobuf::Field::FieldArray.new(field)
        @values[:multiple_resources].replace(value)
      end
    end
    alias_method :_protobuf_message_set_field_multiple_resources, :_protobuf_message_set_field_3
    
    
    def _protobuf_message_encode_3_to_stream(_value, stream)
      _value.each do |value|
        stream << [26].pack('C*') << ::Test::Resource.encode(value)
      end
    end
    alias_method :_protobuf_message_encode_multiple_resources_to_stream, :_protobuf_message_encode_3_to_stream
    
    optional ::Test::StatusType, :status, 4
    
    def _protobuf_message_set_field_4_bytes(bytes)
      _protobuf_message_set_field_4(::Test::StatusType.fetch(::Protobuf::Field::IntegerField::decode(bytes)), true)
    end
    alias_method :_protobuf_message_set_field_status_bytes, :_protobuf_message_set_field_4_bytes
    
    def _protobuf_message_set_field_4(value, ignore_nil_for_repeated)
      if value.nil? # rubocop:disable Style/IfInsideElse
        @values.delete(:status)
      else
        @values[:status] = value
      end
    end
    alias_method :_protobuf_message_set_field_status, :_protobuf_message_set_field_4
    
    def _protobuf_message_encode_4_to_stream(value, stream)
      stream << [32].pack('C*') << ::Protobuf::Field::IntegerField::encode(value.to_i)
    end
    alias_method :_protobuf_message_encode_status_to_stream, :_protobuf_message_encode_4_to_stream
    
    # Extension Fields
    extensions 100...111
    optional :string, :".test.foo", 100, :extension => true
    
    def _protobuf_message_set_field_100_bytes(bytes)
      _protobuf_message_set_field_100(::Protobuf::Field::StringField.decode(bytes), true)
    end
    alias_method :_protobuf_message_set_field__test_foo_bytes, :_protobuf_message_set_field_100_bytes
    
    def _protobuf_message_set_field_100(value, ignore_nil_for_repeated)
      if value.nil? # rubocop:disable Style/IfInsideElse
        @values.delete(:".test.foo")
      else
        @values[:".test.foo"] = ::Protobuf::Field::BytesField.coerce!(value)
      end
    end
    alias_method :_protobuf_message_set_field__test_foo, :_protobuf_message_set_field_100
    
    def _protobuf_message_encode_100_to_stream(value, stream)
      stream << [162, 6].pack('C*') << ::Protobuf::Field::StringField.encode(value)
    end
    alias_method :_protobuf_message_encode__test_foo_to_stream, :_protobuf_message_encode_100_to_stream
    
    optional :int64, :".test.bar", 101, :extension => true
    
    def _protobuf_message_set_field_101_bytes(bytes)
      _protobuf_message_set_field_101(::Protobuf::Field::Int64Field.decode(bytes), true)
    end
    alias_method :_protobuf_message_set_field__test_bar_bytes, :_protobuf_message_set_field_101_bytes
    
    def _protobuf_message_set_field_101(value, ignore_nil_for_repeated)
      if value.nil? # rubocop:disable Style/IfInsideElse
        @values.delete(:".test.bar")
      else
        @values[:".test.bar"] = ::Protobuf::Field::Int64Field.coerce!(value)
      end
    end
    alias_method :_protobuf_message_set_field__test_bar, :_protobuf_message_set_field_101
    
    def _protobuf_message_encode_101_to_stream(value, stream)
      stream << [168, 6].pack('C*') << ::Protobuf::Field::Int64Field.encode(value)
    end
    alias_method :_protobuf_message_encode__test_bar_to_stream, :_protobuf_message_encode_101_to_stream
    
  end


  ##
  # Extended Message Fields
  #
  class ::Google::Protobuf::FileOptions < ::Protobuf::Message
    optional :uint64, :".test.file_option", 9585869, :extension => true
    
    def _protobuf_message_set_field_9585869_bytes(bytes)
      _protobuf_message_set_field_9585869(::Protobuf::Field::Uint64.decode(bytes), true)
    end
    alias_method :_protobuf_message_set_field__test_file_option_bytes, :_protobuf_message_set_field_9585869_bytes
    
    def _protobuf_message_set_field_9585869(value, ignore_nil_for_repeated)
      if value.nil? # rubocop:disable Style/IfInsideElse
        @values.delete(:".test.file_option")
      else
        @values[:".test.file_option"] = ::Protobuf::Field::Uint64Field.coerce!(value)
      end
    end
    alias_method :_protobuf_message_set_field__test_file_option, :_protobuf_message_set_field_9585869
    
    def _protobuf_message_encode_9585869_to_stream(value, stream)
      stream << [232, 204, 200, 36].pack('C*') << ::Protobuf::Field::Uint64.encode(value)
    end
    alias_method :_protobuf_message_encode__test_file_option_to_stream, :_protobuf_message_encode_9585869_to_stream
    
  end

  class ::Google::Protobuf::FieldOptions < ::Protobuf::Message
    optional :uint64, :".test.field_option", 858769, :extension => true
    
    def _protobuf_message_set_field_858769_bytes(bytes)
      _protobuf_message_set_field_858769(::Protobuf::Field::Uint64.decode(bytes), true)
    end
    alias_method :_protobuf_message_set_field__test_field_option_bytes, :_protobuf_message_set_field_858769_bytes
    
    def _protobuf_message_set_field_858769(value, ignore_nil_for_repeated)
      if value.nil? # rubocop:disable Style/IfInsideElse
        @values.delete(:".test.field_option")
      else
        @values[:".test.field_option"] = ::Protobuf::Field::Uint64Field.coerce!(value)
      end
    end
    alias_method :_protobuf_message_set_field__test_field_option, :_protobuf_message_set_field_858769
    
    def _protobuf_message_encode_858769_to_stream(value, stream)
      stream << [136, 169, 163, 3].pack('C*') << ::Protobuf::Field::Uint64.encode(value)
    end
    alias_method :_protobuf_message_encode__test_field_option_to_stream, :_protobuf_message_encode_858769_to_stream
    
  end

  class ::Google::Protobuf::EnumOptions < ::Protobuf::Message
    optional :int64, :".test.enum_option", 590284, :extension => true
    
    def _protobuf_message_set_field_590284_bytes(bytes)
      _protobuf_message_set_field_590284(::Protobuf::Field::Int64Field.decode(bytes), true)
    end
    alias_method :_protobuf_message_set_field__test_enum_option_bytes, :_protobuf_message_set_field_590284_bytes
    
    def _protobuf_message_set_field_590284(value, ignore_nil_for_repeated)
      if value.nil? # rubocop:disable Style/IfInsideElse
        @values.delete(:".test.enum_option")
      else
        @values[:".test.enum_option"] = ::Protobuf::Field::Int64Field.coerce!(value)
      end
    end
    alias_method :_protobuf_message_set_field__test_enum_option, :_protobuf_message_set_field_590284
    
    def _protobuf_message_encode_590284_to_stream(value, stream)
      stream << [224, 156, 160, 2].pack('C*') << ::Protobuf::Field::Int64Field.encode(value)
    end
    alias_method :_protobuf_message_encode__test_enum_option_to_stream, :_protobuf_message_encode_590284_to_stream
    
  end

  class ::Google::Protobuf::MessageOptions < ::Protobuf::Message
    optional :int64, :".test.message_option", 485969, :extension => true
    
    def _protobuf_message_set_field_485969_bytes(bytes)
      _protobuf_message_set_field_485969(::Protobuf::Field::Int64Field.decode(bytes), true)
    end
    alias_method :_protobuf_message_set_field__test_message_option_bytes, :_protobuf_message_set_field_485969_bytes
    
    def _protobuf_message_set_field_485969(value, ignore_nil_for_repeated)
      if value.nil? # rubocop:disable Style/IfInsideElse
        @values.delete(:".test.message_option")
      else
        @values[:".test.message_option"] = ::Protobuf::Field::Int64Field.coerce!(value)
      end
    end
    alias_method :_protobuf_message_set_field__test_message_option, :_protobuf_message_set_field_485969
    
    def _protobuf_message_encode_485969_to_stream(value, stream)
      stream << [136, 165, 237, 1].pack('C*') << ::Protobuf::Field::Int64Field.encode(value)
    end
    alias_method :_protobuf_message_encode__test_message_option_to_stream, :_protobuf_message_encode_485969_to_stream
    
  end

  class ::Google::Protobuf::ServiceOptions < ::Protobuf::Message
    optional :int64, :".test.service_option", 5869607, :extension => true
    
    def _protobuf_message_set_field_5869607_bytes(bytes)
      _protobuf_message_set_field_5869607(::Protobuf::Field::Int64Field.decode(bytes), true)
    end
    alias_method :_protobuf_message_set_field__test_service_option_bytes, :_protobuf_message_set_field_5869607_bytes
    
    def _protobuf_message_set_field_5869607(value, ignore_nil_for_repeated)
      if value.nil? # rubocop:disable Style/IfInsideElse
        @values.delete(:".test.service_option")
      else
        @values[:".test.service_option"] = ::Protobuf::Field::Int64Field.coerce!(value)
      end
    end
    alias_method :_protobuf_message_set_field__test_service_option, :_protobuf_message_set_field_5869607
    
    def _protobuf_message_encode_5869607_to_stream(value, stream)
      stream << [184, 130, 178, 22].pack('C*') << ::Protobuf::Field::Int64Field.encode(value)
    end
    alias_method :_protobuf_message_encode__test_service_option_to_stream, :_protobuf_message_encode_5869607_to_stream
    
  end

  class ::Google::Protobuf::MethodOptions < ::Protobuf::Message
    optional :int64, :".test.method_option", 7893233, :extension => true
    
    def _protobuf_message_set_field_7893233_bytes(bytes)
      _protobuf_message_set_field_7893233(::Protobuf::Field::Int64Field.decode(bytes), true)
    end
    alias_method :_protobuf_message_set_field__test_method_option_bytes, :_protobuf_message_set_field_7893233_bytes
    
    def _protobuf_message_set_field_7893233(value, ignore_nil_for_repeated)
      if value.nil? # rubocop:disable Style/IfInsideElse
        @values.delete(:".test.method_option")
      else
        @values[:".test.method_option"] = ::Protobuf::Field::Int64Field.coerce!(value)
      end
    end
    alias_method :_protobuf_message_set_field__test_method_option, :_protobuf_message_set_field_7893233
    
    def _protobuf_message_encode_7893233_to_stream(value, stream)
      stream << [136, 143, 142, 30].pack('C*') << ::Protobuf::Field::Int64Field.encode(value)
    end
    alias_method :_protobuf_message_encode__test_method_option_to_stream, :_protobuf_message_encode_7893233_to_stream
    
  end


  ##
  # Service Classes
  #
  class ResourceService < ::Protobuf::Rpc::Service
    set_option :".test.service_option", -9876543210
    rpc :find, ::Test::ResourceFindRequest, ::Test::Resource do
      set_option :".test.method_option", 2
    end
    rpc :find_with_rpc_failed, ::Test::ResourceFindRequest, ::Test::Resource
    rpc :find_with_sleep, ::Test::ResourceSleepRequest, ::Test::Resource
    rpc :find_not_implemented, ::Test::ResourceFindRequest, ::Test::Resource
  end

end

