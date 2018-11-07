# encoding: utf-8

##
# This file is auto-generated. DO NOT EDIT!
#
require 'protobuf'

module Google
  module Protobuf
    ::Protobuf::Optionable.inject(self) { ::Google::Protobuf::FileOptions }

    ##
    # Message Classes
    #
    class FileDescriptorSet < ::Protobuf::Message; end
    class FileDescriptorProto < ::Protobuf::Message; end
    class DescriptorProto < ::Protobuf::Message
      class ExtensionRange < ::Protobuf::Message; end
      class ReservedRange < ::Protobuf::Message; end

    end

    class FieldDescriptorProto < ::Protobuf::Message
      class Type < ::Protobuf::Enum
        define :TYPE_DOUBLE, 1
        define :TYPE_FLOAT, 2
        define :TYPE_INT64, 3
        define :TYPE_UINT64, 4
        define :TYPE_INT32, 5
        define :TYPE_FIXED64, 6
        define :TYPE_FIXED32, 7
        define :TYPE_BOOL, 8
        define :TYPE_STRING, 9
        define :TYPE_GROUP, 10
        define :TYPE_MESSAGE, 11
        define :TYPE_BYTES, 12
        define :TYPE_UINT32, 13
        define :TYPE_ENUM, 14
        define :TYPE_SFIXED32, 15
        define :TYPE_SFIXED64, 16
        define :TYPE_SINT32, 17
        define :TYPE_SINT64, 18
      end

      class Label < ::Protobuf::Enum
        define :LABEL_OPTIONAL, 1
        define :LABEL_REQUIRED, 2
        define :LABEL_REPEATED, 3
      end

    end

    class OneofDescriptorProto < ::Protobuf::Message; end
    class EnumDescriptorProto < ::Protobuf::Message; end
    class EnumValueDescriptorProto < ::Protobuf::Message; end
    class ServiceDescriptorProto < ::Protobuf::Message; end
    class MethodDescriptorProto < ::Protobuf::Message; end
    class FileOptions < ::Protobuf::Message
      class OptimizeMode < ::Protobuf::Enum
        define :SPEED, 1
        define :CODE_SIZE, 2
        define :LITE_RUNTIME, 3
      end

    end

    class MessageOptions < ::Protobuf::Message; end
    class FieldOptions < ::Protobuf::Message
      class CType < ::Protobuf::Enum
        define :STRING, 0
        define :CORD, 1
        define :STRING_PIECE, 2
      end

      class JSType < ::Protobuf::Enum
        define :JS_NORMAL, 0
        define :JS_STRING, 1
        define :JS_NUMBER, 2
      end

    end

    class EnumOptions < ::Protobuf::Message; end
    class EnumValueOptions < ::Protobuf::Message; end
    class ServiceOptions < ::Protobuf::Message; end
    class MethodOptions < ::Protobuf::Message; end
    class UninterpretedOption < ::Protobuf::Message
      class NamePart < ::Protobuf::Message; end

    end

    class SourceCodeInfo < ::Protobuf::Message
      class Location < ::Protobuf::Message; end

    end



    ##
    # File Options
    #
    set_option :java_package, "com.google.protobuf"
    set_option :java_outer_classname, "DescriptorProtos"
    set_option :optimize_for, ::Google::Protobuf::FileOptions::OptimizeMode::SPEED
    set_option :go_package, "descriptor"
    set_option :objc_class_prefix, "GPB"
    set_option :csharp_namespace, "Google.Protobuf.Reflection"


    ##
    # Message Fields
    #
    class FileDescriptorSet
      repeated ::Google::Protobuf::FileDescriptorProto, :file, 1
      
      def _protobuf_message_set_field_1_bytes(bytes)
        _protobuf_message_set_field_1(::Google::Protobuf::FileDescriptorProto.decode(bytes), true)
      end
      alias_method :_protobuf_message_set_field_file_bytes, :_protobuf_message_set_field_1_bytes
      
      def _protobuf_message_set_field_1(field, value, ignore_nil_for_repeated)
        if value.nil? && ignore_nil_for_repeated
          ::Protobuf.deprecator.deprecation_warning("[:file]=nil", "use an empty array instead of nil")
          return
        end
        unless value.is_a?(Array)
          fail TypeError, <<-TYPE_ERROR
              Expected repeated value of type ::Google::Protobuf::FileDescriptorProto
              Got #{value.class} for repeated protobuf field :file
          TYPE_ERROR
        end
      
        value = value.compact
      
        if value.empty?
          @values.delete(:file)
          _protobuf_message_remove_tag_to_serialize(1)
        else
          @values[:file] ||= ::PROTOBUF_FIELD_FIELD_ARRAY.new(field)
          @values[:file].replace(value)
          _protobuf_message_add_tag_to_serialize(1)
        end
      end
      alias_method :_protobuf_message_set_field_file, :_protobuf_message_set_field_1
      
      
      def _protobuf_message_encode_1_to_stream(_value, stream)
        _value.each do |value|
          stream << [10].pack('C*') << ::Google::Protobuf::FileDescriptorProto.encode(value)
        end
      end
      alias_method :_protobuf_message_encode_file_to_stream, :_protobuf_message_encode_1_to_stream
      
      REQUIRED_FIELDS = [1]
      
      def _protobuf_message_tags_to_serialize
        @_tags_to_serialize ||= ::Set.new
      end
      
      def _protobuf_message_add_tag_to_serialize(tag)
        @_tags_to_serialize.add(tag)
      end
      
      def _protobuf_message_clear_tags_to_serialize(tag)
        @_tags_to_serialize.clear
      end
      
      def _protobuf_message_remove_tag_to_serialize(tag)
        @_tags_to_serialize.delete(tag)
      end
      
      def _protobuf_message_serialize_message_to(stream)
      ##
      # Required
      #
      (@_tags_to_serialize - REQUIRED_FIELDS).each do |field_number|
        fail ::Protobuf::SerializationError, "Required field #{self.class.name}##{field_number} does not have a value."
      end
        @_tags_to_serialize.each do |tag_to_serialize|
          __send__("_protobuf_message_encode_#{tag_to_serialize}_to_stream", stream)
        end
      end
    end

    class FileDescriptorProto
      optional :string, :name, 1
      
      def _protobuf_message_set_field_1_bytes(bytes)
        _protobuf_message_set_field_1(::PROTOBUF_FIELD_STRING_FIELD.decode(bytes), true)
      end
      alias_method :_protobuf_message_set_field_name_bytes, :_protobuf_message_set_field_1_bytes
      
      def _protobuf_message_set_field_1(value, ignore_nil_for_repeated)
        if value.nil? # rubocop:disable Style/IfInsideElse
          @values.delete(:name)
          _protobuf_message_remove_tag_to_serialize(1)
        else
          @values[:name] = ::PROTOBUF_FIELD_BYTES_FIELD.coerce!(value)
          _protobuf_message_add_tag_to_serialize(1)
        end
      end
      alias_method :_protobuf_message_set_field_name, :_protobuf_message_set_field_1
      
      def _protobuf_message_encode_1_to_stream(value, stream)
        stream << [10].pack('C*') << ::PROTOBUF_FIELD_STRING_FIELD.encode(value)
      end
      alias_method :_protobuf_message_encode_name_to_stream, :_protobuf_message_encode_1_to_stream
      
      optional :string, :package, 2
      
      def _protobuf_message_set_field_2_bytes(bytes)
        _protobuf_message_set_field_2(::PROTOBUF_FIELD_STRING_FIELD.decode(bytes), true)
      end
      alias_method :_protobuf_message_set_field_package_bytes, :_protobuf_message_set_field_2_bytes
      
      def _protobuf_message_set_field_2(value, ignore_nil_for_repeated)
        if value.nil? # rubocop:disable Style/IfInsideElse
          @values.delete(:package)
          _protobuf_message_remove_tag_to_serialize(2)
        else
          @values[:package] = ::PROTOBUF_FIELD_BYTES_FIELD.coerce!(value)
          _protobuf_message_add_tag_to_serialize(2)
        end
      end
      alias_method :_protobuf_message_set_field_package, :_protobuf_message_set_field_2
      
      def _protobuf_message_encode_2_to_stream(value, stream)
        stream << [18].pack('C*') << ::PROTOBUF_FIELD_STRING_FIELD.encode(value)
      end
      alias_method :_protobuf_message_encode_package_to_stream, :_protobuf_message_encode_2_to_stream
      
      repeated :string, :dependency, 3
      
      def _protobuf_message_set_field_3_bytes(bytes)
        _protobuf_message_set_field_3(::PROTOBUF_FIELD_STRING_FIELD.decode(bytes), true)
      end
      alias_method :_protobuf_message_set_field_dependency_bytes, :_protobuf_message_set_field_3_bytes
      
      def _protobuf_message_set_field_3(field, value, ignore_nil_for_repeated)
        if value.nil? && ignore_nil_for_repeated
          ::Protobuf.deprecator.deprecation_warning("[:dependency]=nil", "use an empty array instead of nil")
          return
        end
        unless value.is_a?(Array)
          fail TypeError, <<-TYPE_ERROR
              Expected repeated value of type :string
              Got #{value.class} for repeated protobuf field :dependency
          TYPE_ERROR
        end
      
        value = value.compact
      
        if value.empty?
          @values.delete(:dependency)
          _protobuf_message_remove_tag_to_serialize(3)
        else
          @values[:dependency] ||= ::PROTOBUF_FIELD_FIELD_ARRAY.new(field)
          @values[:dependency].replace(value)
          _protobuf_message_add_tag_to_serialize(3)
        end
      end
      alias_method :_protobuf_message_set_field_dependency, :_protobuf_message_set_field_3
      
      
      def _protobuf_message_encode_3_to_stream(_value, stream)
        _value.each do |value|
          stream << [26].pack('C*') << ::PROTOBUF_FIELD_STRING_FIELD.encode(value)
        end
      end
      alias_method :_protobuf_message_encode_dependency_to_stream, :_protobuf_message_encode_3_to_stream
      
      repeated :int32, :public_dependency, 10
      
      def _protobuf_message_set_field_10_bytes(bytes)
        _protobuf_message_set_field_10(::PROTOBUF_FIELD_INT32_FIELD.decode(bytes), true)
      end
      alias_method :_protobuf_message_set_field_public_dependency_bytes, :_protobuf_message_set_field_10_bytes
      
      def _protobuf_message_set_field_10(field, value, ignore_nil_for_repeated)
        if value.nil? && ignore_nil_for_repeated
          ::Protobuf.deprecator.deprecation_warning("[:public_dependency]=nil", "use an empty array instead of nil")
          return
        end
        unless value.is_a?(Array)
          fail TypeError, <<-TYPE_ERROR
              Expected repeated value of type :int32
              Got #{value.class} for repeated protobuf field :public_dependency
          TYPE_ERROR
        end
      
        value = value.compact
      
        if value.empty?
          @values.delete(:public_dependency)
          _protobuf_message_remove_tag_to_serialize(10)
        else
          @values[:public_dependency] ||= ::PROTOBUF_FIELD_FIELD_ARRAY.new(field)
          @values[:public_dependency].replace(value)
          _protobuf_message_add_tag_to_serialize(10)
        end
      end
      alias_method :_protobuf_message_set_field_public_dependency, :_protobuf_message_set_field_10
      
      
      def _protobuf_message_encode_10_to_stream(_value, stream)
        _value.each do |value|
          stream << [80].pack('C*') << ::PROTOBUF_FIELD_INT32_FIELD.encode(value)
        end
      end
      alias_method :_protobuf_message_encode_public_dependency_to_stream, :_protobuf_message_encode_10_to_stream
      
      repeated :int32, :weak_dependency, 11
      
      def _protobuf_message_set_field_11_bytes(bytes)
        _protobuf_message_set_field_11(::PROTOBUF_FIELD_INT32_FIELD.decode(bytes), true)
      end
      alias_method :_protobuf_message_set_field_weak_dependency_bytes, :_protobuf_message_set_field_11_bytes
      
      def _protobuf_message_set_field_11(field, value, ignore_nil_for_repeated)
        if value.nil? && ignore_nil_for_repeated
          ::Protobuf.deprecator.deprecation_warning("[:weak_dependency]=nil", "use an empty array instead of nil")
          return
        end
        unless value.is_a?(Array)
          fail TypeError, <<-TYPE_ERROR
              Expected repeated value of type :int32
              Got #{value.class} for repeated protobuf field :weak_dependency
          TYPE_ERROR
        end
      
        value = value.compact
      
        if value.empty?
          @values.delete(:weak_dependency)
          _protobuf_message_remove_tag_to_serialize(11)
        else
          @values[:weak_dependency] ||= ::PROTOBUF_FIELD_FIELD_ARRAY.new(field)
          @values[:weak_dependency].replace(value)
          _protobuf_message_add_tag_to_serialize(11)
        end
      end
      alias_method :_protobuf_message_set_field_weak_dependency, :_protobuf_message_set_field_11
      
      
      def _protobuf_message_encode_11_to_stream(_value, stream)
        _value.each do |value|
          stream << [88].pack('C*') << ::PROTOBUF_FIELD_INT32_FIELD.encode(value)
        end
      end
      alias_method :_protobuf_message_encode_weak_dependency_to_stream, :_protobuf_message_encode_11_to_stream
      
      repeated ::Google::Protobuf::DescriptorProto, :message_type, 4
      
      def _protobuf_message_set_field_4_bytes(bytes)
        _protobuf_message_set_field_4(::Google::Protobuf::DescriptorProto.decode(bytes), true)
      end
      alias_method :_protobuf_message_set_field_message_type_bytes, :_protobuf_message_set_field_4_bytes
      
      def _protobuf_message_set_field_4(field, value, ignore_nil_for_repeated)
        if value.nil? && ignore_nil_for_repeated
          ::Protobuf.deprecator.deprecation_warning("[:message_type]=nil", "use an empty array instead of nil")
          return
        end
        unless value.is_a?(Array)
          fail TypeError, <<-TYPE_ERROR
              Expected repeated value of type ::Google::Protobuf::DescriptorProto
              Got #{value.class} for repeated protobuf field :message_type
          TYPE_ERROR
        end
      
        value = value.compact
      
        if value.empty?
          @values.delete(:message_type)
          _protobuf_message_remove_tag_to_serialize(4)
        else
          @values[:message_type] ||= ::PROTOBUF_FIELD_FIELD_ARRAY.new(field)
          @values[:message_type].replace(value)
          _protobuf_message_add_tag_to_serialize(4)
        end
      end
      alias_method :_protobuf_message_set_field_message_type, :_protobuf_message_set_field_4
      
      
      def _protobuf_message_encode_4_to_stream(_value, stream)
        _value.each do |value|
          stream << [34].pack('C*') << ::Google::Protobuf::DescriptorProto.encode(value)
        end
      end
      alias_method :_protobuf_message_encode_message_type_to_stream, :_protobuf_message_encode_4_to_stream
      
      repeated ::Google::Protobuf::EnumDescriptorProto, :enum_type, 5
      
      def _protobuf_message_set_field_5_bytes(bytes)
        _protobuf_message_set_field_5(::Google::Protobuf::EnumDescriptorProto.decode(bytes), true)
      end
      alias_method :_protobuf_message_set_field_enum_type_bytes, :_protobuf_message_set_field_5_bytes
      
      def _protobuf_message_set_field_5(field, value, ignore_nil_for_repeated)
        if value.nil? && ignore_nil_for_repeated
          ::Protobuf.deprecator.deprecation_warning("[:enum_type]=nil", "use an empty array instead of nil")
          return
        end
        unless value.is_a?(Array)
          fail TypeError, <<-TYPE_ERROR
              Expected repeated value of type ::Google::Protobuf::EnumDescriptorProto
              Got #{value.class} for repeated protobuf field :enum_type
          TYPE_ERROR
        end
      
        value = value.compact
      
        if value.empty?
          @values.delete(:enum_type)
          _protobuf_message_remove_tag_to_serialize(5)
        else
          @values[:enum_type] ||= ::PROTOBUF_FIELD_FIELD_ARRAY.new(field)
          @values[:enum_type].replace(value)
          _protobuf_message_add_tag_to_serialize(5)
        end
      end
      alias_method :_protobuf_message_set_field_enum_type, :_protobuf_message_set_field_5
      
      
      def _protobuf_message_encode_5_to_stream(_value, stream)
        _value.each do |value|
          stream << [42].pack('C*') << ::Google::Protobuf::EnumDescriptorProto.encode(value)
        end
      end
      alias_method :_protobuf_message_encode_enum_type_to_stream, :_protobuf_message_encode_5_to_stream
      
      repeated ::Google::Protobuf::ServiceDescriptorProto, :service, 6
      
      def _protobuf_message_set_field_6_bytes(bytes)
        _protobuf_message_set_field_6(::Google::Protobuf::ServiceDescriptorProto.decode(bytes), true)
      end
      alias_method :_protobuf_message_set_field_service_bytes, :_protobuf_message_set_field_6_bytes
      
      def _protobuf_message_set_field_6(field, value, ignore_nil_for_repeated)
        if value.nil? && ignore_nil_for_repeated
          ::Protobuf.deprecator.deprecation_warning("[:service]=nil", "use an empty array instead of nil")
          return
        end
        unless value.is_a?(Array)
          fail TypeError, <<-TYPE_ERROR
              Expected repeated value of type ::Google::Protobuf::ServiceDescriptorProto
              Got #{value.class} for repeated protobuf field :service
          TYPE_ERROR
        end
      
        value = value.compact
      
        if value.empty?
          @values.delete(:service)
          _protobuf_message_remove_tag_to_serialize(6)
        else
          @values[:service] ||= ::PROTOBUF_FIELD_FIELD_ARRAY.new(field)
          @values[:service].replace(value)
          _protobuf_message_add_tag_to_serialize(6)
        end
      end
      alias_method :_protobuf_message_set_field_service, :_protobuf_message_set_field_6
      
      
      def _protobuf_message_encode_6_to_stream(_value, stream)
        _value.each do |value|
          stream << [50].pack('C*') << ::Google::Protobuf::ServiceDescriptorProto.encode(value)
        end
      end
      alias_method :_protobuf_message_encode_service_to_stream, :_protobuf_message_encode_6_to_stream
      
      repeated ::Google::Protobuf::FieldDescriptorProto, :extension, 7
      
      def _protobuf_message_set_field_7_bytes(bytes)
        _protobuf_message_set_field_7(::Google::Protobuf::FieldDescriptorProto.decode(bytes), true)
      end
      alias_method :_protobuf_message_set_field_extension_bytes, :_protobuf_message_set_field_7_bytes
      
      def _protobuf_message_set_field_7(field, value, ignore_nil_for_repeated)
        if value.nil? && ignore_nil_for_repeated
          ::Protobuf.deprecator.deprecation_warning("[:extension]=nil", "use an empty array instead of nil")
          return
        end
        unless value.is_a?(Array)
          fail TypeError, <<-TYPE_ERROR
              Expected repeated value of type ::Google::Protobuf::FieldDescriptorProto
              Got #{value.class} for repeated protobuf field :extension
          TYPE_ERROR
        end
      
        value = value.compact
      
        if value.empty?
          @values.delete(:extension)
          _protobuf_message_remove_tag_to_serialize(7)
        else
          @values[:extension] ||= ::PROTOBUF_FIELD_FIELD_ARRAY.new(field)
          @values[:extension].replace(value)
          _protobuf_message_add_tag_to_serialize(7)
        end
      end
      alias_method :_protobuf_message_set_field_extension, :_protobuf_message_set_field_7
      
      
      def _protobuf_message_encode_7_to_stream(_value, stream)
        _value.each do |value|
          stream << [58].pack('C*') << ::Google::Protobuf::FieldDescriptorProto.encode(value)
        end
      end
      alias_method :_protobuf_message_encode_extension_to_stream, :_protobuf_message_encode_7_to_stream
      
      optional ::Google::Protobuf::FileOptions, :options, 8
      
      def _protobuf_message_set_field_8_bytes(bytes)
        _protobuf_message_set_field_8(::Google::Protobuf::FileOptions.decode(bytes), true)
      end
      alias_method :_protobuf_message_set_field_options_bytes, :_protobuf_message_set_field_8_bytes
      
      def _protobuf_message_set_field_8(value, ignore_nil_for_repeated)
        if value.nil? # rubocop:disable Style/IfInsideElse
          @values.delete(:options)
          _protobuf_message_remove_tag_to_serialize(8)
        else
          @values[:options] = value
          _protobuf_message_add_tag_to_serialize(8)
        end
      end
      alias_method :_protobuf_message_set_field_options, :_protobuf_message_set_field_8
      
      def _protobuf_message_encode_8_to_stream(value, stream)
        stream << [66].pack('C*') << ::Google::Protobuf::FileOptions.encode(value)
      end
      alias_method :_protobuf_message_encode_options_to_stream, :_protobuf_message_encode_8_to_stream
      
      optional ::Google::Protobuf::SourceCodeInfo, :source_code_info, 9
      
      def _protobuf_message_set_field_9_bytes(bytes)
        _protobuf_message_set_field_9(::Google::Protobuf::SourceCodeInfo.decode(bytes), true)
      end
      alias_method :_protobuf_message_set_field_source_code_info_bytes, :_protobuf_message_set_field_9_bytes
      
      def _protobuf_message_set_field_9(value, ignore_nil_for_repeated)
        if value.nil? # rubocop:disable Style/IfInsideElse
          @values.delete(:source_code_info)
          _protobuf_message_remove_tag_to_serialize(9)
        else
          @values[:source_code_info] = value
          _protobuf_message_add_tag_to_serialize(9)
        end
      end
      alias_method :_protobuf_message_set_field_source_code_info, :_protobuf_message_set_field_9
      
      def _protobuf_message_encode_9_to_stream(value, stream)
        stream << [74].pack('C*') << ::Google::Protobuf::SourceCodeInfo.encode(value)
      end
      alias_method :_protobuf_message_encode_source_code_info_to_stream, :_protobuf_message_encode_9_to_stream
      
      optional :string, :syntax, 12
      
      def _protobuf_message_set_field_12_bytes(bytes)
        _protobuf_message_set_field_12(::PROTOBUF_FIELD_STRING_FIELD.decode(bytes), true)
      end
      alias_method :_protobuf_message_set_field_syntax_bytes, :_protobuf_message_set_field_12_bytes
      
      def _protobuf_message_set_field_12(value, ignore_nil_for_repeated)
        if value.nil? # rubocop:disable Style/IfInsideElse
          @values.delete(:syntax)
          _protobuf_message_remove_tag_to_serialize(12)
        else
          @values[:syntax] = ::PROTOBUF_FIELD_BYTES_FIELD.coerce!(value)
          _protobuf_message_add_tag_to_serialize(12)
        end
      end
      alias_method :_protobuf_message_set_field_syntax, :_protobuf_message_set_field_12
      
      def _protobuf_message_encode_12_to_stream(value, stream)
        stream << [98].pack('C*') << ::PROTOBUF_FIELD_STRING_FIELD.encode(value)
      end
      alias_method :_protobuf_message_encode_syntax_to_stream, :_protobuf_message_encode_12_to_stream
      
      REQUIRED_FIELDS = [1, 2, 3, 10, 11, 4, 5, 6, 7, 8, 9, 12]
      
      def _protobuf_message_tags_to_serialize
        @_tags_to_serialize ||= ::Set.new
      end
      
      def _protobuf_message_add_tag_to_serialize(tag)
        @_tags_to_serialize.add(tag)
      end
      
      def _protobuf_message_clear_tags_to_serialize(tag)
        @_tags_to_serialize.clear
      end
      
      def _protobuf_message_remove_tag_to_serialize(tag)
        @_tags_to_serialize.delete(tag)
      end
      
      def _protobuf_message_serialize_message_to(stream)
      ##
      # Required
      #
      (@_tags_to_serialize - REQUIRED_FIELDS).each do |field_number|
        fail ::Protobuf::SerializationError, "Required field #{self.class.name}##{field_number} does not have a value."
      end
        @_tags_to_serialize.each do |tag_to_serialize|
          __send__("_protobuf_message_encode_#{tag_to_serialize}_to_stream", stream)
        end
      end
    end

    class DescriptorProto
      class ExtensionRange
        optional :int32, :start, 1
        
        def _protobuf_message_set_field_1_bytes(bytes)
          _protobuf_message_set_field_1(::PROTOBUF_FIELD_INT32_FIELD.decode(bytes), true)
        end
        alias_method :_protobuf_message_set_field_start_bytes, :_protobuf_message_set_field_1_bytes
        
        def _protobuf_message_set_field_1(value, ignore_nil_for_repeated)
          if value.nil? # rubocop:disable Style/IfInsideElse
            @values.delete(:start)
            _protobuf_message_remove_tag_to_serialize(1)
          else
            @values[:start] = ::PROTOBUF_FIELD_INT32_FIELD.coerce!(value)
            _protobuf_message_add_tag_to_serialize(1)
          end
        end
        alias_method :_protobuf_message_set_field_start, :_protobuf_message_set_field_1
        
        def _protobuf_message_encode_1_to_stream(value, stream)
          stream << [8].pack('C*') << ::PROTOBUF_FIELD_INT32_FIELD.encode(value)
        end
        alias_method :_protobuf_message_encode_start_to_stream, :_protobuf_message_encode_1_to_stream
        
        optional :int32, :end, 2
        
        def _protobuf_message_set_field_2_bytes(bytes)
          _protobuf_message_set_field_2(::PROTOBUF_FIELD_INT32_FIELD.decode(bytes), true)
        end
        alias_method :_protobuf_message_set_field_end_bytes, :_protobuf_message_set_field_2_bytes
        
        def _protobuf_message_set_field_2(value, ignore_nil_for_repeated)
          if value.nil? # rubocop:disable Style/IfInsideElse
            @values.delete(:end)
            _protobuf_message_remove_tag_to_serialize(2)
          else
            @values[:end] = ::PROTOBUF_FIELD_INT32_FIELD.coerce!(value)
            _protobuf_message_add_tag_to_serialize(2)
          end
        end
        alias_method :_protobuf_message_set_field_end, :_protobuf_message_set_field_2
        
        def _protobuf_message_encode_2_to_stream(value, stream)
          stream << [16].pack('C*') << ::PROTOBUF_FIELD_INT32_FIELD.encode(value)
        end
        alias_method :_protobuf_message_encode_end_to_stream, :_protobuf_message_encode_2_to_stream
        
        REQUIRED_FIELDS = [1, 2]
        
        def _protobuf_message_tags_to_serialize
          @_tags_to_serialize ||= ::Set.new
        end
        
        def _protobuf_message_add_tag_to_serialize(tag)
          @_tags_to_serialize.add(tag)
        end
        
        def _protobuf_message_clear_tags_to_serialize(tag)
          @_tags_to_serialize.clear
        end
        
        def _protobuf_message_remove_tag_to_serialize(tag)
          @_tags_to_serialize.delete(tag)
        end
        
        def _protobuf_message_serialize_message_to(stream)
        ##
        # Required
        #
        (@_tags_to_serialize - REQUIRED_FIELDS).each do |field_number|
          fail ::Protobuf::SerializationError, "Required field #{self.class.name}##{field_number} does not have a value."
        end
          @_tags_to_serialize.each do |tag_to_serialize|
            __send__("_protobuf_message_encode_#{tag_to_serialize}_to_stream", stream)
          end
        end
      end

      class ReservedRange
        optional :int32, :start, 1
        
        def _protobuf_message_set_field_1_bytes(bytes)
          _protobuf_message_set_field_1(::PROTOBUF_FIELD_INT32_FIELD.decode(bytes), true)
        end
        alias_method :_protobuf_message_set_field_start_bytes, :_protobuf_message_set_field_1_bytes
        
        def _protobuf_message_set_field_1(value, ignore_nil_for_repeated)
          if value.nil? # rubocop:disable Style/IfInsideElse
            @values.delete(:start)
            _protobuf_message_remove_tag_to_serialize(1)
          else
            @values[:start] = ::PROTOBUF_FIELD_INT32_FIELD.coerce!(value)
            _protobuf_message_add_tag_to_serialize(1)
          end
        end
        alias_method :_protobuf_message_set_field_start, :_protobuf_message_set_field_1
        
        def _protobuf_message_encode_1_to_stream(value, stream)
          stream << [8].pack('C*') << ::PROTOBUF_FIELD_INT32_FIELD.encode(value)
        end
        alias_method :_protobuf_message_encode_start_to_stream, :_protobuf_message_encode_1_to_stream
        
        optional :int32, :end, 2
        
        def _protobuf_message_set_field_2_bytes(bytes)
          _protobuf_message_set_field_2(::PROTOBUF_FIELD_INT32_FIELD.decode(bytes), true)
        end
        alias_method :_protobuf_message_set_field_end_bytes, :_protobuf_message_set_field_2_bytes
        
        def _protobuf_message_set_field_2(value, ignore_nil_for_repeated)
          if value.nil? # rubocop:disable Style/IfInsideElse
            @values.delete(:end)
            _protobuf_message_remove_tag_to_serialize(2)
          else
            @values[:end] = ::PROTOBUF_FIELD_INT32_FIELD.coerce!(value)
            _protobuf_message_add_tag_to_serialize(2)
          end
        end
        alias_method :_protobuf_message_set_field_end, :_protobuf_message_set_field_2
        
        def _protobuf_message_encode_2_to_stream(value, stream)
          stream << [16].pack('C*') << ::PROTOBUF_FIELD_INT32_FIELD.encode(value)
        end
        alias_method :_protobuf_message_encode_end_to_stream, :_protobuf_message_encode_2_to_stream
        
        REQUIRED_FIELDS = [1, 2]
        
        def _protobuf_message_tags_to_serialize
          @_tags_to_serialize ||= ::Set.new
        end
        
        def _protobuf_message_add_tag_to_serialize(tag)
          @_tags_to_serialize.add(tag)
        end
        
        def _protobuf_message_clear_tags_to_serialize(tag)
          @_tags_to_serialize.clear
        end
        
        def _protobuf_message_remove_tag_to_serialize(tag)
          @_tags_to_serialize.delete(tag)
        end
        
        def _protobuf_message_serialize_message_to(stream)
        ##
        # Required
        #
        (@_tags_to_serialize - REQUIRED_FIELDS).each do |field_number|
          fail ::Protobuf::SerializationError, "Required field #{self.class.name}##{field_number} does not have a value."
        end
          @_tags_to_serialize.each do |tag_to_serialize|
            __send__("_protobuf_message_encode_#{tag_to_serialize}_to_stream", stream)
          end
        end
      end

      optional :string, :name, 1
      
      def _protobuf_message_set_field_1_bytes(bytes)
        _protobuf_message_set_field_1(::PROTOBUF_FIELD_STRING_FIELD.decode(bytes), true)
      end
      alias_method :_protobuf_message_set_field_name_bytes, :_protobuf_message_set_field_1_bytes
      
      def _protobuf_message_set_field_1(value, ignore_nil_for_repeated)
        if value.nil? # rubocop:disable Style/IfInsideElse
          @values.delete(:name)
          _protobuf_message_remove_tag_to_serialize(1)
        else
          @values[:name] = ::PROTOBUF_FIELD_BYTES_FIELD.coerce!(value)
          _protobuf_message_add_tag_to_serialize(1)
        end
      end
      alias_method :_protobuf_message_set_field_name, :_protobuf_message_set_field_1
      
      def _protobuf_message_encode_1_to_stream(value, stream)
        stream << [10].pack('C*') << ::PROTOBUF_FIELD_STRING_FIELD.encode(value)
      end
      alias_method :_protobuf_message_encode_name_to_stream, :_protobuf_message_encode_1_to_stream
      
      repeated ::Google::Protobuf::FieldDescriptorProto, :field, 2
      
      def _protobuf_message_set_field_2_bytes(bytes)
        _protobuf_message_set_field_2(::Google::Protobuf::FieldDescriptorProto.decode(bytes), true)
      end
      alias_method :_protobuf_message_set_field_field_bytes, :_protobuf_message_set_field_2_bytes
      
      def _protobuf_message_set_field_2(field, value, ignore_nil_for_repeated)
        if value.nil? && ignore_nil_for_repeated
          ::Protobuf.deprecator.deprecation_warning("[:field]=nil", "use an empty array instead of nil")
          return
        end
        unless value.is_a?(Array)
          fail TypeError, <<-TYPE_ERROR
              Expected repeated value of type ::Google::Protobuf::FieldDescriptorProto
              Got #{value.class} for repeated protobuf field :field
          TYPE_ERROR
        end
      
        value = value.compact
      
        if value.empty?
          @values.delete(:field)
          _protobuf_message_remove_tag_to_serialize(2)
        else
          @values[:field] ||= ::PROTOBUF_FIELD_FIELD_ARRAY.new(field)
          @values[:field].replace(value)
          _protobuf_message_add_tag_to_serialize(2)
        end
      end
      alias_method :_protobuf_message_set_field_field, :_protobuf_message_set_field_2
      
      
      def _protobuf_message_encode_2_to_stream(_value, stream)
        _value.each do |value|
          stream << [18].pack('C*') << ::Google::Protobuf::FieldDescriptorProto.encode(value)
        end
      end
      alias_method :_protobuf_message_encode_field_to_stream, :_protobuf_message_encode_2_to_stream
      
      repeated ::Google::Protobuf::FieldDescriptorProto, :extension, 6
      
      def _protobuf_message_set_field_6_bytes(bytes)
        _protobuf_message_set_field_6(::Google::Protobuf::FieldDescriptorProto.decode(bytes), true)
      end
      alias_method :_protobuf_message_set_field_extension_bytes, :_protobuf_message_set_field_6_bytes
      
      def _protobuf_message_set_field_6(field, value, ignore_nil_for_repeated)
        if value.nil? && ignore_nil_for_repeated
          ::Protobuf.deprecator.deprecation_warning("[:extension]=nil", "use an empty array instead of nil")
          return
        end
        unless value.is_a?(Array)
          fail TypeError, <<-TYPE_ERROR
              Expected repeated value of type ::Google::Protobuf::FieldDescriptorProto
              Got #{value.class} for repeated protobuf field :extension
          TYPE_ERROR
        end
      
        value = value.compact
      
        if value.empty?
          @values.delete(:extension)
          _protobuf_message_remove_tag_to_serialize(6)
        else
          @values[:extension] ||= ::PROTOBUF_FIELD_FIELD_ARRAY.new(field)
          @values[:extension].replace(value)
          _protobuf_message_add_tag_to_serialize(6)
        end
      end
      alias_method :_protobuf_message_set_field_extension, :_protobuf_message_set_field_6
      
      
      def _protobuf_message_encode_6_to_stream(_value, stream)
        _value.each do |value|
          stream << [50].pack('C*') << ::Google::Protobuf::FieldDescriptorProto.encode(value)
        end
      end
      alias_method :_protobuf_message_encode_extension_to_stream, :_protobuf_message_encode_6_to_stream
      
      repeated ::Google::Protobuf::DescriptorProto, :nested_type, 3
      
      def _protobuf_message_set_field_3_bytes(bytes)
        _protobuf_message_set_field_3(::Google::Protobuf::DescriptorProto.decode(bytes), true)
      end
      alias_method :_protobuf_message_set_field_nested_type_bytes, :_protobuf_message_set_field_3_bytes
      
      def _protobuf_message_set_field_3(field, value, ignore_nil_for_repeated)
        if value.nil? && ignore_nil_for_repeated
          ::Protobuf.deprecator.deprecation_warning("[:nested_type]=nil", "use an empty array instead of nil")
          return
        end
        unless value.is_a?(Array)
          fail TypeError, <<-TYPE_ERROR
              Expected repeated value of type ::Google::Protobuf::DescriptorProto
              Got #{value.class} for repeated protobuf field :nested_type
          TYPE_ERROR
        end
      
        value = value.compact
      
        if value.empty?
          @values.delete(:nested_type)
          _protobuf_message_remove_tag_to_serialize(3)
        else
          @values[:nested_type] ||= ::PROTOBUF_FIELD_FIELD_ARRAY.new(field)
          @values[:nested_type].replace(value)
          _protobuf_message_add_tag_to_serialize(3)
        end
      end
      alias_method :_protobuf_message_set_field_nested_type, :_protobuf_message_set_field_3
      
      
      def _protobuf_message_encode_3_to_stream(_value, stream)
        _value.each do |value|
          stream << [26].pack('C*') << ::Google::Protobuf::DescriptorProto.encode(value)
        end
      end
      alias_method :_protobuf_message_encode_nested_type_to_stream, :_protobuf_message_encode_3_to_stream
      
      repeated ::Google::Protobuf::EnumDescriptorProto, :enum_type, 4
      
      def _protobuf_message_set_field_4_bytes(bytes)
        _protobuf_message_set_field_4(::Google::Protobuf::EnumDescriptorProto.decode(bytes), true)
      end
      alias_method :_protobuf_message_set_field_enum_type_bytes, :_protobuf_message_set_field_4_bytes
      
      def _protobuf_message_set_field_4(field, value, ignore_nil_for_repeated)
        if value.nil? && ignore_nil_for_repeated
          ::Protobuf.deprecator.deprecation_warning("[:enum_type]=nil", "use an empty array instead of nil")
          return
        end
        unless value.is_a?(Array)
          fail TypeError, <<-TYPE_ERROR
              Expected repeated value of type ::Google::Protobuf::EnumDescriptorProto
              Got #{value.class} for repeated protobuf field :enum_type
          TYPE_ERROR
        end
      
        value = value.compact
      
        if value.empty?
          @values.delete(:enum_type)
          _protobuf_message_remove_tag_to_serialize(4)
        else
          @values[:enum_type] ||= ::PROTOBUF_FIELD_FIELD_ARRAY.new(field)
          @values[:enum_type].replace(value)
          _protobuf_message_add_tag_to_serialize(4)
        end
      end
      alias_method :_protobuf_message_set_field_enum_type, :_protobuf_message_set_field_4
      
      
      def _protobuf_message_encode_4_to_stream(_value, stream)
        _value.each do |value|
          stream << [34].pack('C*') << ::Google::Protobuf::EnumDescriptorProto.encode(value)
        end
      end
      alias_method :_protobuf_message_encode_enum_type_to_stream, :_protobuf_message_encode_4_to_stream
      
      repeated ::Google::Protobuf::DescriptorProto::ExtensionRange, :extension_range, 5
      
      def _protobuf_message_set_field_5_bytes(bytes)
        _protobuf_message_set_field_5(::Google::Protobuf::DescriptorProto::ExtensionRange.decode(bytes), true)
      end
      alias_method :_protobuf_message_set_field_extension_range_bytes, :_protobuf_message_set_field_5_bytes
      
      def _protobuf_message_set_field_5(field, value, ignore_nil_for_repeated)
        if value.nil? && ignore_nil_for_repeated
          ::Protobuf.deprecator.deprecation_warning("[:extension_range]=nil", "use an empty array instead of nil")
          return
        end
        unless value.is_a?(Array)
          fail TypeError, <<-TYPE_ERROR
              Expected repeated value of type ::Google::Protobuf::DescriptorProto::ExtensionRange
              Got #{value.class} for repeated protobuf field :extension_range
          TYPE_ERROR
        end
      
        value = value.compact
      
        if value.empty?
          @values.delete(:extension_range)
          _protobuf_message_remove_tag_to_serialize(5)
        else
          @values[:extension_range] ||= ::PROTOBUF_FIELD_FIELD_ARRAY.new(field)
          @values[:extension_range].replace(value)
          _protobuf_message_add_tag_to_serialize(5)
        end
      end
      alias_method :_protobuf_message_set_field_extension_range, :_protobuf_message_set_field_5
      
      
      def _protobuf_message_encode_5_to_stream(_value, stream)
        _value.each do |value|
          stream << [42].pack('C*') << ::Google::Protobuf::DescriptorProto::ExtensionRange.encode(value)
        end
      end
      alias_method :_protobuf_message_encode_extension_range_to_stream, :_protobuf_message_encode_5_to_stream
      
      repeated ::Google::Protobuf::OneofDescriptorProto, :oneof_decl, 8
      
      def _protobuf_message_set_field_8_bytes(bytes)
        _protobuf_message_set_field_8(::Google::Protobuf::OneofDescriptorProto.decode(bytes), true)
      end
      alias_method :_protobuf_message_set_field_oneof_decl_bytes, :_protobuf_message_set_field_8_bytes
      
      def _protobuf_message_set_field_8(field, value, ignore_nil_for_repeated)
        if value.nil? && ignore_nil_for_repeated
          ::Protobuf.deprecator.deprecation_warning("[:oneof_decl]=nil", "use an empty array instead of nil")
          return
        end
        unless value.is_a?(Array)
          fail TypeError, <<-TYPE_ERROR
              Expected repeated value of type ::Google::Protobuf::OneofDescriptorProto
              Got #{value.class} for repeated protobuf field :oneof_decl
          TYPE_ERROR
        end
      
        value = value.compact
      
        if value.empty?
          @values.delete(:oneof_decl)
          _protobuf_message_remove_tag_to_serialize(8)
        else
          @values[:oneof_decl] ||= ::PROTOBUF_FIELD_FIELD_ARRAY.new(field)
          @values[:oneof_decl].replace(value)
          _protobuf_message_add_tag_to_serialize(8)
        end
      end
      alias_method :_protobuf_message_set_field_oneof_decl, :_protobuf_message_set_field_8
      
      
      def _protobuf_message_encode_8_to_stream(_value, stream)
        _value.each do |value|
          stream << [66].pack('C*') << ::Google::Protobuf::OneofDescriptorProto.encode(value)
        end
      end
      alias_method :_protobuf_message_encode_oneof_decl_to_stream, :_protobuf_message_encode_8_to_stream
      
      optional ::Google::Protobuf::MessageOptions, :options, 7
      
      def _protobuf_message_set_field_7_bytes(bytes)
        _protobuf_message_set_field_7(::Google::Protobuf::MessageOptions.decode(bytes), true)
      end
      alias_method :_protobuf_message_set_field_options_bytes, :_protobuf_message_set_field_7_bytes
      
      def _protobuf_message_set_field_7(value, ignore_nil_for_repeated)
        if value.nil? # rubocop:disable Style/IfInsideElse
          @values.delete(:options)
          _protobuf_message_remove_tag_to_serialize(7)
        else
          @values[:options] = value
          _protobuf_message_add_tag_to_serialize(7)
        end
      end
      alias_method :_protobuf_message_set_field_options, :_protobuf_message_set_field_7
      
      def _protobuf_message_encode_7_to_stream(value, stream)
        stream << [58].pack('C*') << ::Google::Protobuf::MessageOptions.encode(value)
      end
      alias_method :_protobuf_message_encode_options_to_stream, :_protobuf_message_encode_7_to_stream
      
      repeated ::Google::Protobuf::DescriptorProto::ReservedRange, :reserved_range, 9
      
      def _protobuf_message_set_field_9_bytes(bytes)
        _protobuf_message_set_field_9(::Google::Protobuf::DescriptorProto::ReservedRange.decode(bytes), true)
      end
      alias_method :_protobuf_message_set_field_reserved_range_bytes, :_protobuf_message_set_field_9_bytes
      
      def _protobuf_message_set_field_9(field, value, ignore_nil_for_repeated)
        if value.nil? && ignore_nil_for_repeated
          ::Protobuf.deprecator.deprecation_warning("[:reserved_range]=nil", "use an empty array instead of nil")
          return
        end
        unless value.is_a?(Array)
          fail TypeError, <<-TYPE_ERROR
              Expected repeated value of type ::Google::Protobuf::DescriptorProto::ReservedRange
              Got #{value.class} for repeated protobuf field :reserved_range
          TYPE_ERROR
        end
      
        value = value.compact
      
        if value.empty?
          @values.delete(:reserved_range)
          _protobuf_message_remove_tag_to_serialize(9)
        else
          @values[:reserved_range] ||= ::PROTOBUF_FIELD_FIELD_ARRAY.new(field)
          @values[:reserved_range].replace(value)
          _protobuf_message_add_tag_to_serialize(9)
        end
      end
      alias_method :_protobuf_message_set_field_reserved_range, :_protobuf_message_set_field_9
      
      
      def _protobuf_message_encode_9_to_stream(_value, stream)
        _value.each do |value|
          stream << [74].pack('C*') << ::Google::Protobuf::DescriptorProto::ReservedRange.encode(value)
        end
      end
      alias_method :_protobuf_message_encode_reserved_range_to_stream, :_protobuf_message_encode_9_to_stream
      
      repeated :string, :reserved_name, 10
      
      def _protobuf_message_set_field_10_bytes(bytes)
        _protobuf_message_set_field_10(::PROTOBUF_FIELD_STRING_FIELD.decode(bytes), true)
      end
      alias_method :_protobuf_message_set_field_reserved_name_bytes, :_protobuf_message_set_field_10_bytes
      
      def _protobuf_message_set_field_10(field, value, ignore_nil_for_repeated)
        if value.nil? && ignore_nil_for_repeated
          ::Protobuf.deprecator.deprecation_warning("[:reserved_name]=nil", "use an empty array instead of nil")
          return
        end
        unless value.is_a?(Array)
          fail TypeError, <<-TYPE_ERROR
              Expected repeated value of type :string
              Got #{value.class} for repeated protobuf field :reserved_name
          TYPE_ERROR
        end
      
        value = value.compact
      
        if value.empty?
          @values.delete(:reserved_name)
          _protobuf_message_remove_tag_to_serialize(10)
        else
          @values[:reserved_name] ||= ::PROTOBUF_FIELD_FIELD_ARRAY.new(field)
          @values[:reserved_name].replace(value)
          _protobuf_message_add_tag_to_serialize(10)
        end
      end
      alias_method :_protobuf_message_set_field_reserved_name, :_protobuf_message_set_field_10
      
      
      def _protobuf_message_encode_10_to_stream(_value, stream)
        _value.each do |value|
          stream << [82].pack('C*') << ::PROTOBUF_FIELD_STRING_FIELD.encode(value)
        end
      end
      alias_method :_protobuf_message_encode_reserved_name_to_stream, :_protobuf_message_encode_10_to_stream
      
      REQUIRED_FIELDS = [1, 2, 6, 3, 4, 5, 8, 7, 9, 10]
      
      def _protobuf_message_tags_to_serialize
        @_tags_to_serialize ||= ::Set.new
      end
      
      def _protobuf_message_add_tag_to_serialize(tag)
        @_tags_to_serialize.add(tag)
      end
      
      def _protobuf_message_clear_tags_to_serialize(tag)
        @_tags_to_serialize.clear
      end
      
      def _protobuf_message_remove_tag_to_serialize(tag)
        @_tags_to_serialize.delete(tag)
      end
      
      def _protobuf_message_serialize_message_to(stream)
      ##
      # Required
      #
      (@_tags_to_serialize - REQUIRED_FIELDS).each do |field_number|
        fail ::Protobuf::SerializationError, "Required field #{self.class.name}##{field_number} does not have a value."
      end
        @_tags_to_serialize.each do |tag_to_serialize|
          __send__("_protobuf_message_encode_#{tag_to_serialize}_to_stream", stream)
        end
      end
    end

    class FieldDescriptorProto
      optional :string, :name, 1
      
      def _protobuf_message_set_field_1_bytes(bytes)
        _protobuf_message_set_field_1(::PROTOBUF_FIELD_STRING_FIELD.decode(bytes), true)
      end
      alias_method :_protobuf_message_set_field_name_bytes, :_protobuf_message_set_field_1_bytes
      
      def _protobuf_message_set_field_1(value, ignore_nil_for_repeated)
        if value.nil? # rubocop:disable Style/IfInsideElse
          @values.delete(:name)
          _protobuf_message_remove_tag_to_serialize(1)
        else
          @values[:name] = ::PROTOBUF_FIELD_BYTES_FIELD.coerce!(value)
          _protobuf_message_add_tag_to_serialize(1)
        end
      end
      alias_method :_protobuf_message_set_field_name, :_protobuf_message_set_field_1
      
      def _protobuf_message_encode_1_to_stream(value, stream)
        stream << [10].pack('C*') << ::PROTOBUF_FIELD_STRING_FIELD.encode(value)
      end
      alias_method :_protobuf_message_encode_name_to_stream, :_protobuf_message_encode_1_to_stream
      
      optional :int32, :number, 3
      
      def _protobuf_message_set_field_3_bytes(bytes)
        _protobuf_message_set_field_3(::PROTOBUF_FIELD_INT32_FIELD.decode(bytes), true)
      end
      alias_method :_protobuf_message_set_field_number_bytes, :_protobuf_message_set_field_3_bytes
      
      def _protobuf_message_set_field_3(value, ignore_nil_for_repeated)
        if value.nil? # rubocop:disable Style/IfInsideElse
          @values.delete(:number)
          _protobuf_message_remove_tag_to_serialize(3)
        else
          @values[:number] = ::PROTOBUF_FIELD_INT32_FIELD.coerce!(value)
          _protobuf_message_add_tag_to_serialize(3)
        end
      end
      alias_method :_protobuf_message_set_field_number, :_protobuf_message_set_field_3
      
      def _protobuf_message_encode_3_to_stream(value, stream)
        stream << [24].pack('C*') << ::PROTOBUF_FIELD_INT32_FIELD.encode(value)
      end
      alias_method :_protobuf_message_encode_number_to_stream, :_protobuf_message_encode_3_to_stream
      
      optional ::Google::Protobuf::FieldDescriptorProto::Label, :label, 4
      
      def _protobuf_message_set_field_4_bytes(bytes)
        _protobuf_message_set_field_4(::Google::Protobuf::FieldDescriptorProto::Label.fetch(::PROTOBUF_FIELD_INTEGER_FIELD.decode(bytes)), true)
      end
      alias_method :_protobuf_message_set_field_label_bytes, :_protobuf_message_set_field_4_bytes
      
      def _protobuf_message_set_field_4(value, ignore_nil_for_repeated)
        if value.nil? # rubocop:disable Style/IfInsideElse
          @values.delete(:label)
          _protobuf_message_remove_tag_to_serialize(4)
        else
          @values[:label] = value
          _protobuf_message_add_tag_to_serialize(4)
        end
      end
      alias_method :_protobuf_message_set_field_label, :_protobuf_message_set_field_4
      
      def _protobuf_message_encode_4_to_stream(value, stream)
        stream << [32].pack('C*') << ::PROTOBUF_FIELD_INTEGER_FIELD.encode(value.to_i)
      end
      alias_method :_protobuf_message_encode_label_to_stream, :_protobuf_message_encode_4_to_stream
      
      optional ::Google::Protobuf::FieldDescriptorProto::Type, :type, 5
      
      def _protobuf_message_set_field_5_bytes(bytes)
        _protobuf_message_set_field_5(::Google::Protobuf::FieldDescriptorProto::Type.fetch(::PROTOBUF_FIELD_INTEGER_FIELD.decode(bytes)), true)
      end
      alias_method :_protobuf_message_set_field_type_bytes, :_protobuf_message_set_field_5_bytes
      
      def _protobuf_message_set_field_5(value, ignore_nil_for_repeated)
        if value.nil? # rubocop:disable Style/IfInsideElse
          @values.delete(:type)
          _protobuf_message_remove_tag_to_serialize(5)
        else
          @values[:type] = value
          _protobuf_message_add_tag_to_serialize(5)
        end
      end
      alias_method :_protobuf_message_set_field_type, :_protobuf_message_set_field_5
      
      def _protobuf_message_encode_5_to_stream(value, stream)
        stream << [40].pack('C*') << ::PROTOBUF_FIELD_INTEGER_FIELD.encode(value.to_i)
      end
      alias_method :_protobuf_message_encode_type_to_stream, :_protobuf_message_encode_5_to_stream
      
      optional :string, :type_name, 6
      
      def _protobuf_message_set_field_6_bytes(bytes)
        _protobuf_message_set_field_6(::PROTOBUF_FIELD_STRING_FIELD.decode(bytes), true)
      end
      alias_method :_protobuf_message_set_field_type_name_bytes, :_protobuf_message_set_field_6_bytes
      
      def _protobuf_message_set_field_6(value, ignore_nil_for_repeated)
        if value.nil? # rubocop:disable Style/IfInsideElse
          @values.delete(:type_name)
          _protobuf_message_remove_tag_to_serialize(6)
        else
          @values[:type_name] = ::PROTOBUF_FIELD_BYTES_FIELD.coerce!(value)
          _protobuf_message_add_tag_to_serialize(6)
        end
      end
      alias_method :_protobuf_message_set_field_type_name, :_protobuf_message_set_field_6
      
      def _protobuf_message_encode_6_to_stream(value, stream)
        stream << [50].pack('C*') << ::PROTOBUF_FIELD_STRING_FIELD.encode(value)
      end
      alias_method :_protobuf_message_encode_type_name_to_stream, :_protobuf_message_encode_6_to_stream
      
      optional :string, :extendee, 2
      
      def _protobuf_message_set_field_2_bytes(bytes)
        _protobuf_message_set_field_2(::PROTOBUF_FIELD_STRING_FIELD.decode(bytes), true)
      end
      alias_method :_protobuf_message_set_field_extendee_bytes, :_protobuf_message_set_field_2_bytes
      
      def _protobuf_message_set_field_2(value, ignore_nil_for_repeated)
        if value.nil? # rubocop:disable Style/IfInsideElse
          @values.delete(:extendee)
          _protobuf_message_remove_tag_to_serialize(2)
        else
          @values[:extendee] = ::PROTOBUF_FIELD_BYTES_FIELD.coerce!(value)
          _protobuf_message_add_tag_to_serialize(2)
        end
      end
      alias_method :_protobuf_message_set_field_extendee, :_protobuf_message_set_field_2
      
      def _protobuf_message_encode_2_to_stream(value, stream)
        stream << [18].pack('C*') << ::PROTOBUF_FIELD_STRING_FIELD.encode(value)
      end
      alias_method :_protobuf_message_encode_extendee_to_stream, :_protobuf_message_encode_2_to_stream
      
      optional :string, :default_value, 7
      
      def _protobuf_message_set_field_7_bytes(bytes)
        _protobuf_message_set_field_7(::PROTOBUF_FIELD_STRING_FIELD.decode(bytes), true)
      end
      alias_method :_protobuf_message_set_field_default_value_bytes, :_protobuf_message_set_field_7_bytes
      
      def _protobuf_message_set_field_7(value, ignore_nil_for_repeated)
        if value.nil? # rubocop:disable Style/IfInsideElse
          @values.delete(:default_value)
          _protobuf_message_remove_tag_to_serialize(7)
        else
          @values[:default_value] = ::PROTOBUF_FIELD_BYTES_FIELD.coerce!(value)
          _protobuf_message_add_tag_to_serialize(7)
        end
      end
      alias_method :_protobuf_message_set_field_default_value, :_protobuf_message_set_field_7
      
      def _protobuf_message_encode_7_to_stream(value, stream)
        stream << [58].pack('C*') << ::PROTOBUF_FIELD_STRING_FIELD.encode(value)
      end
      alias_method :_protobuf_message_encode_default_value_to_stream, :_protobuf_message_encode_7_to_stream
      
      optional :int32, :oneof_index, 9
      
      def _protobuf_message_set_field_9_bytes(bytes)
        _protobuf_message_set_field_9(::PROTOBUF_FIELD_INT32_FIELD.decode(bytes), true)
      end
      alias_method :_protobuf_message_set_field_oneof_index_bytes, :_protobuf_message_set_field_9_bytes
      
      def _protobuf_message_set_field_9(value, ignore_nil_for_repeated)
        if value.nil? # rubocop:disable Style/IfInsideElse
          @values.delete(:oneof_index)
          _protobuf_message_remove_tag_to_serialize(9)
        else
          @values[:oneof_index] = ::PROTOBUF_FIELD_INT32_FIELD.coerce!(value)
          _protobuf_message_add_tag_to_serialize(9)
        end
      end
      alias_method :_protobuf_message_set_field_oneof_index, :_protobuf_message_set_field_9
      
      def _protobuf_message_encode_9_to_stream(value, stream)
        stream << [72].pack('C*') << ::PROTOBUF_FIELD_INT32_FIELD.encode(value)
      end
      alias_method :_protobuf_message_encode_oneof_index_to_stream, :_protobuf_message_encode_9_to_stream
      
      optional :string, :json_name, 10
      
      def _protobuf_message_set_field_10_bytes(bytes)
        _protobuf_message_set_field_10(::PROTOBUF_FIELD_STRING_FIELD.decode(bytes), true)
      end
      alias_method :_protobuf_message_set_field_json_name_bytes, :_protobuf_message_set_field_10_bytes
      
      def _protobuf_message_set_field_10(value, ignore_nil_for_repeated)
        if value.nil? # rubocop:disable Style/IfInsideElse
          @values.delete(:json_name)
          _protobuf_message_remove_tag_to_serialize(10)
        else
          @values[:json_name] = ::PROTOBUF_FIELD_BYTES_FIELD.coerce!(value)
          _protobuf_message_add_tag_to_serialize(10)
        end
      end
      alias_method :_protobuf_message_set_field_json_name, :_protobuf_message_set_field_10
      
      def _protobuf_message_encode_10_to_stream(value, stream)
        stream << [82].pack('C*') << ::PROTOBUF_FIELD_STRING_FIELD.encode(value)
      end
      alias_method :_protobuf_message_encode_json_name_to_stream, :_protobuf_message_encode_10_to_stream
      
      optional ::Google::Protobuf::FieldOptions, :options, 8
      
      def _protobuf_message_set_field_8_bytes(bytes)
        _protobuf_message_set_field_8(::Google::Protobuf::FieldOptions.decode(bytes), true)
      end
      alias_method :_protobuf_message_set_field_options_bytes, :_protobuf_message_set_field_8_bytes
      
      def _protobuf_message_set_field_8(value, ignore_nil_for_repeated)
        if value.nil? # rubocop:disable Style/IfInsideElse
          @values.delete(:options)
          _protobuf_message_remove_tag_to_serialize(8)
        else
          @values[:options] = value
          _protobuf_message_add_tag_to_serialize(8)
        end
      end
      alias_method :_protobuf_message_set_field_options, :_protobuf_message_set_field_8
      
      def _protobuf_message_encode_8_to_stream(value, stream)
        stream << [66].pack('C*') << ::Google::Protobuf::FieldOptions.encode(value)
      end
      alias_method :_protobuf_message_encode_options_to_stream, :_protobuf_message_encode_8_to_stream
      
      REQUIRED_FIELDS = [1, 3, 4, 5, 6, 2, 7, 9, 10, 8]
      
      def _protobuf_message_tags_to_serialize
        @_tags_to_serialize ||= ::Set.new
      end
      
      def _protobuf_message_add_tag_to_serialize(tag)
        @_tags_to_serialize.add(tag)
      end
      
      def _protobuf_message_clear_tags_to_serialize(tag)
        @_tags_to_serialize.clear
      end
      
      def _protobuf_message_remove_tag_to_serialize(tag)
        @_tags_to_serialize.delete(tag)
      end
      
      def _protobuf_message_serialize_message_to(stream)
      ##
      # Required
      #
      (@_tags_to_serialize - REQUIRED_FIELDS).each do |field_number|
        fail ::Protobuf::SerializationError, "Required field #{self.class.name}##{field_number} does not have a value."
      end
        @_tags_to_serialize.each do |tag_to_serialize|
          __send__("_protobuf_message_encode_#{tag_to_serialize}_to_stream", stream)
        end
      end
    end

    class OneofDescriptorProto
      optional :string, :name, 1
      
      def _protobuf_message_set_field_1_bytes(bytes)
        _protobuf_message_set_field_1(::PROTOBUF_FIELD_STRING_FIELD.decode(bytes), true)
      end
      alias_method :_protobuf_message_set_field_name_bytes, :_protobuf_message_set_field_1_bytes
      
      def _protobuf_message_set_field_1(value, ignore_nil_for_repeated)
        if value.nil? # rubocop:disable Style/IfInsideElse
          @values.delete(:name)
          _protobuf_message_remove_tag_to_serialize(1)
        else
          @values[:name] = ::PROTOBUF_FIELD_BYTES_FIELD.coerce!(value)
          _protobuf_message_add_tag_to_serialize(1)
        end
      end
      alias_method :_protobuf_message_set_field_name, :_protobuf_message_set_field_1
      
      def _protobuf_message_encode_1_to_stream(value, stream)
        stream << [10].pack('C*') << ::PROTOBUF_FIELD_STRING_FIELD.encode(value)
      end
      alias_method :_protobuf_message_encode_name_to_stream, :_protobuf_message_encode_1_to_stream
      
      REQUIRED_FIELDS = [1]
      
      def _protobuf_message_tags_to_serialize
        @_tags_to_serialize ||= ::Set.new
      end
      
      def _protobuf_message_add_tag_to_serialize(tag)
        @_tags_to_serialize.add(tag)
      end
      
      def _protobuf_message_clear_tags_to_serialize(tag)
        @_tags_to_serialize.clear
      end
      
      def _protobuf_message_remove_tag_to_serialize(tag)
        @_tags_to_serialize.delete(tag)
      end
      
      def _protobuf_message_serialize_message_to(stream)
      ##
      # Required
      #
      (@_tags_to_serialize - REQUIRED_FIELDS).each do |field_number|
        fail ::Protobuf::SerializationError, "Required field #{self.class.name}##{field_number} does not have a value."
      end
        @_tags_to_serialize.each do |tag_to_serialize|
          __send__("_protobuf_message_encode_#{tag_to_serialize}_to_stream", stream)
        end
      end
    end

    class EnumDescriptorProto
      optional :string, :name, 1
      
      def _protobuf_message_set_field_1_bytes(bytes)
        _protobuf_message_set_field_1(::PROTOBUF_FIELD_STRING_FIELD.decode(bytes), true)
      end
      alias_method :_protobuf_message_set_field_name_bytes, :_protobuf_message_set_field_1_bytes
      
      def _protobuf_message_set_field_1(value, ignore_nil_for_repeated)
        if value.nil? # rubocop:disable Style/IfInsideElse
          @values.delete(:name)
          _protobuf_message_remove_tag_to_serialize(1)
        else
          @values[:name] = ::PROTOBUF_FIELD_BYTES_FIELD.coerce!(value)
          _protobuf_message_add_tag_to_serialize(1)
        end
      end
      alias_method :_protobuf_message_set_field_name, :_protobuf_message_set_field_1
      
      def _protobuf_message_encode_1_to_stream(value, stream)
        stream << [10].pack('C*') << ::PROTOBUF_FIELD_STRING_FIELD.encode(value)
      end
      alias_method :_protobuf_message_encode_name_to_stream, :_protobuf_message_encode_1_to_stream
      
      repeated ::Google::Protobuf::EnumValueDescriptorProto, :value, 2
      
      def _protobuf_message_set_field_2_bytes(bytes)
        _protobuf_message_set_field_2(::Google::Protobuf::EnumValueDescriptorProto.decode(bytes), true)
      end
      alias_method :_protobuf_message_set_field_value_bytes, :_protobuf_message_set_field_2_bytes
      
      def _protobuf_message_set_field_2(field, value, ignore_nil_for_repeated)
        if value.nil? && ignore_nil_for_repeated
          ::Protobuf.deprecator.deprecation_warning("[:value]=nil", "use an empty array instead of nil")
          return
        end
        unless value.is_a?(Array)
          fail TypeError, <<-TYPE_ERROR
              Expected repeated value of type ::Google::Protobuf::EnumValueDescriptorProto
              Got #{value.class} for repeated protobuf field :value
          TYPE_ERROR
        end
      
        value = value.compact
      
        if value.empty?
          @values.delete(:value)
          _protobuf_message_remove_tag_to_serialize(2)
        else
          @values[:value] ||= ::PROTOBUF_FIELD_FIELD_ARRAY.new(field)
          @values[:value].replace(value)
          _protobuf_message_add_tag_to_serialize(2)
        end
      end
      alias_method :_protobuf_message_set_field_value, :_protobuf_message_set_field_2
      
      
      def _protobuf_message_encode_2_to_stream(_value, stream)
        _value.each do |value|
          stream << [18].pack('C*') << ::Google::Protobuf::EnumValueDescriptorProto.encode(value)
        end
      end
      alias_method :_protobuf_message_encode_value_to_stream, :_protobuf_message_encode_2_to_stream
      
      optional ::Google::Protobuf::EnumOptions, :options, 3
      
      def _protobuf_message_set_field_3_bytes(bytes)
        _protobuf_message_set_field_3(::Google::Protobuf::EnumOptions.decode(bytes), true)
      end
      alias_method :_protobuf_message_set_field_options_bytes, :_protobuf_message_set_field_3_bytes
      
      def _protobuf_message_set_field_3(value, ignore_nil_for_repeated)
        if value.nil? # rubocop:disable Style/IfInsideElse
          @values.delete(:options)
          _protobuf_message_remove_tag_to_serialize(3)
        else
          @values[:options] = value
          _protobuf_message_add_tag_to_serialize(3)
        end
      end
      alias_method :_protobuf_message_set_field_options, :_protobuf_message_set_field_3
      
      def _protobuf_message_encode_3_to_stream(value, stream)
        stream << [26].pack('C*') << ::Google::Protobuf::EnumOptions.encode(value)
      end
      alias_method :_protobuf_message_encode_options_to_stream, :_protobuf_message_encode_3_to_stream
      
      REQUIRED_FIELDS = [1, 2, 3]
      
      def _protobuf_message_tags_to_serialize
        @_tags_to_serialize ||= ::Set.new
      end
      
      def _protobuf_message_add_tag_to_serialize(tag)
        @_tags_to_serialize.add(tag)
      end
      
      def _protobuf_message_clear_tags_to_serialize(tag)
        @_tags_to_serialize.clear
      end
      
      def _protobuf_message_remove_tag_to_serialize(tag)
        @_tags_to_serialize.delete(tag)
      end
      
      def _protobuf_message_serialize_message_to(stream)
      ##
      # Required
      #
      (@_tags_to_serialize - REQUIRED_FIELDS).each do |field_number|
        fail ::Protobuf::SerializationError, "Required field #{self.class.name}##{field_number} does not have a value."
      end
        @_tags_to_serialize.each do |tag_to_serialize|
          __send__("_protobuf_message_encode_#{tag_to_serialize}_to_stream", stream)
        end
      end
    end

    class EnumValueDescriptorProto
      optional :string, :name, 1
      
      def _protobuf_message_set_field_1_bytes(bytes)
        _protobuf_message_set_field_1(::PROTOBUF_FIELD_STRING_FIELD.decode(bytes), true)
      end
      alias_method :_protobuf_message_set_field_name_bytes, :_protobuf_message_set_field_1_bytes
      
      def _protobuf_message_set_field_1(value, ignore_nil_for_repeated)
        if value.nil? # rubocop:disable Style/IfInsideElse
          @values.delete(:name)
          _protobuf_message_remove_tag_to_serialize(1)
        else
          @values[:name] = ::PROTOBUF_FIELD_BYTES_FIELD.coerce!(value)
          _protobuf_message_add_tag_to_serialize(1)
        end
      end
      alias_method :_protobuf_message_set_field_name, :_protobuf_message_set_field_1
      
      def _protobuf_message_encode_1_to_stream(value, stream)
        stream << [10].pack('C*') << ::PROTOBUF_FIELD_STRING_FIELD.encode(value)
      end
      alias_method :_protobuf_message_encode_name_to_stream, :_protobuf_message_encode_1_to_stream
      
      optional :int32, :number, 2
      
      def _protobuf_message_set_field_2_bytes(bytes)
        _protobuf_message_set_field_2(::PROTOBUF_FIELD_INT32_FIELD.decode(bytes), true)
      end
      alias_method :_protobuf_message_set_field_number_bytes, :_protobuf_message_set_field_2_bytes
      
      def _protobuf_message_set_field_2(value, ignore_nil_for_repeated)
        if value.nil? # rubocop:disable Style/IfInsideElse
          @values.delete(:number)
          _protobuf_message_remove_tag_to_serialize(2)
        else
          @values[:number] = ::PROTOBUF_FIELD_INT32_FIELD.coerce!(value)
          _protobuf_message_add_tag_to_serialize(2)
        end
      end
      alias_method :_protobuf_message_set_field_number, :_protobuf_message_set_field_2
      
      def _protobuf_message_encode_2_to_stream(value, stream)
        stream << [16].pack('C*') << ::PROTOBUF_FIELD_INT32_FIELD.encode(value)
      end
      alias_method :_protobuf_message_encode_number_to_stream, :_protobuf_message_encode_2_to_stream
      
      optional ::Google::Protobuf::EnumValueOptions, :options, 3
      
      def _protobuf_message_set_field_3_bytes(bytes)
        _protobuf_message_set_field_3(::Google::Protobuf::EnumValueOptions.decode(bytes), true)
      end
      alias_method :_protobuf_message_set_field_options_bytes, :_protobuf_message_set_field_3_bytes
      
      def _protobuf_message_set_field_3(value, ignore_nil_for_repeated)
        if value.nil? # rubocop:disable Style/IfInsideElse
          @values.delete(:options)
          _protobuf_message_remove_tag_to_serialize(3)
        else
          @values[:options] = value
          _protobuf_message_add_tag_to_serialize(3)
        end
      end
      alias_method :_protobuf_message_set_field_options, :_protobuf_message_set_field_3
      
      def _protobuf_message_encode_3_to_stream(value, stream)
        stream << [26].pack('C*') << ::Google::Protobuf::EnumValueOptions.encode(value)
      end
      alias_method :_protobuf_message_encode_options_to_stream, :_protobuf_message_encode_3_to_stream
      
      REQUIRED_FIELDS = [1, 2, 3]
      
      def _protobuf_message_tags_to_serialize
        @_tags_to_serialize ||= ::Set.new
      end
      
      def _protobuf_message_add_tag_to_serialize(tag)
        @_tags_to_serialize.add(tag)
      end
      
      def _protobuf_message_clear_tags_to_serialize(tag)
        @_tags_to_serialize.clear
      end
      
      def _protobuf_message_remove_tag_to_serialize(tag)
        @_tags_to_serialize.delete(tag)
      end
      
      def _protobuf_message_serialize_message_to(stream)
      ##
      # Required
      #
      (@_tags_to_serialize - REQUIRED_FIELDS).each do |field_number|
        fail ::Protobuf::SerializationError, "Required field #{self.class.name}##{field_number} does not have a value."
      end
        @_tags_to_serialize.each do |tag_to_serialize|
          __send__("_protobuf_message_encode_#{tag_to_serialize}_to_stream", stream)
        end
      end
    end

    class ServiceDescriptorProto
      optional :string, :name, 1
      
      def _protobuf_message_set_field_1_bytes(bytes)
        _protobuf_message_set_field_1(::PROTOBUF_FIELD_STRING_FIELD.decode(bytes), true)
      end
      alias_method :_protobuf_message_set_field_name_bytes, :_protobuf_message_set_field_1_bytes
      
      def _protobuf_message_set_field_1(value, ignore_nil_for_repeated)
        if value.nil? # rubocop:disable Style/IfInsideElse
          @values.delete(:name)
          _protobuf_message_remove_tag_to_serialize(1)
        else
          @values[:name] = ::PROTOBUF_FIELD_BYTES_FIELD.coerce!(value)
          _protobuf_message_add_tag_to_serialize(1)
        end
      end
      alias_method :_protobuf_message_set_field_name, :_protobuf_message_set_field_1
      
      def _protobuf_message_encode_1_to_stream(value, stream)
        stream << [10].pack('C*') << ::PROTOBUF_FIELD_STRING_FIELD.encode(value)
      end
      alias_method :_protobuf_message_encode_name_to_stream, :_protobuf_message_encode_1_to_stream
      
      repeated ::Google::Protobuf::MethodDescriptorProto, :method, 2
      
      def _protobuf_message_set_field_2_bytes(bytes)
        _protobuf_message_set_field_2(::Google::Protobuf::MethodDescriptorProto.decode(bytes), true)
      end
      alias_method :_protobuf_message_set_field_method_bytes, :_protobuf_message_set_field_2_bytes
      
      def _protobuf_message_set_field_2(field, value, ignore_nil_for_repeated)
        if value.nil? && ignore_nil_for_repeated
          ::Protobuf.deprecator.deprecation_warning("[:method]=nil", "use an empty array instead of nil")
          return
        end
        unless value.is_a?(Array)
          fail TypeError, <<-TYPE_ERROR
              Expected repeated value of type ::Google::Protobuf::MethodDescriptorProto
              Got #{value.class} for repeated protobuf field :method
          TYPE_ERROR
        end
      
        value = value.compact
      
        if value.empty?
          @values.delete(:method)
          _protobuf_message_remove_tag_to_serialize(2)
        else
          @values[:method] ||= ::PROTOBUF_FIELD_FIELD_ARRAY.new(field)
          @values[:method].replace(value)
          _protobuf_message_add_tag_to_serialize(2)
        end
      end
      alias_method :_protobuf_message_set_field_method, :_protobuf_message_set_field_2
      
      
      def _protobuf_message_encode_2_to_stream(_value, stream)
        _value.each do |value|
          stream << [18].pack('C*') << ::Google::Protobuf::MethodDescriptorProto.encode(value)
        end
      end
      alias_method :_protobuf_message_encode_method_to_stream, :_protobuf_message_encode_2_to_stream
      
      optional ::Google::Protobuf::ServiceOptions, :options, 3
      
      def _protobuf_message_set_field_3_bytes(bytes)
        _protobuf_message_set_field_3(::Google::Protobuf::ServiceOptions.decode(bytes), true)
      end
      alias_method :_protobuf_message_set_field_options_bytes, :_protobuf_message_set_field_3_bytes
      
      def _protobuf_message_set_field_3(value, ignore_nil_for_repeated)
        if value.nil? # rubocop:disable Style/IfInsideElse
          @values.delete(:options)
          _protobuf_message_remove_tag_to_serialize(3)
        else
          @values[:options] = value
          _protobuf_message_add_tag_to_serialize(3)
        end
      end
      alias_method :_protobuf_message_set_field_options, :_protobuf_message_set_field_3
      
      def _protobuf_message_encode_3_to_stream(value, stream)
        stream << [26].pack('C*') << ::Google::Protobuf::ServiceOptions.encode(value)
      end
      alias_method :_protobuf_message_encode_options_to_stream, :_protobuf_message_encode_3_to_stream
      
      REQUIRED_FIELDS = [1, 2, 3]
      
      def _protobuf_message_tags_to_serialize
        @_tags_to_serialize ||= ::Set.new
      end
      
      def _protobuf_message_add_tag_to_serialize(tag)
        @_tags_to_serialize.add(tag)
      end
      
      def _protobuf_message_clear_tags_to_serialize(tag)
        @_tags_to_serialize.clear
      end
      
      def _protobuf_message_remove_tag_to_serialize(tag)
        @_tags_to_serialize.delete(tag)
      end
      
      def _protobuf_message_serialize_message_to(stream)
      ##
      # Required
      #
      (@_tags_to_serialize - REQUIRED_FIELDS).each do |field_number|
        fail ::Protobuf::SerializationError, "Required field #{self.class.name}##{field_number} does not have a value."
      end
        @_tags_to_serialize.each do |tag_to_serialize|
          __send__("_protobuf_message_encode_#{tag_to_serialize}_to_stream", stream)
        end
      end
    end

    class MethodDescriptorProto
      optional :string, :name, 1
      
      def _protobuf_message_set_field_1_bytes(bytes)
        _protobuf_message_set_field_1(::PROTOBUF_FIELD_STRING_FIELD.decode(bytes), true)
      end
      alias_method :_protobuf_message_set_field_name_bytes, :_protobuf_message_set_field_1_bytes
      
      def _protobuf_message_set_field_1(value, ignore_nil_for_repeated)
        if value.nil? # rubocop:disable Style/IfInsideElse
          @values.delete(:name)
          _protobuf_message_remove_tag_to_serialize(1)
        else
          @values[:name] = ::PROTOBUF_FIELD_BYTES_FIELD.coerce!(value)
          _protobuf_message_add_tag_to_serialize(1)
        end
      end
      alias_method :_protobuf_message_set_field_name, :_protobuf_message_set_field_1
      
      def _protobuf_message_encode_1_to_stream(value, stream)
        stream << [10].pack('C*') << ::PROTOBUF_FIELD_STRING_FIELD.encode(value)
      end
      alias_method :_protobuf_message_encode_name_to_stream, :_protobuf_message_encode_1_to_stream
      
      optional :string, :input_type, 2
      
      def _protobuf_message_set_field_2_bytes(bytes)
        _protobuf_message_set_field_2(::PROTOBUF_FIELD_STRING_FIELD.decode(bytes), true)
      end
      alias_method :_protobuf_message_set_field_input_type_bytes, :_protobuf_message_set_field_2_bytes
      
      def _protobuf_message_set_field_2(value, ignore_nil_for_repeated)
        if value.nil? # rubocop:disable Style/IfInsideElse
          @values.delete(:input_type)
          _protobuf_message_remove_tag_to_serialize(2)
        else
          @values[:input_type] = ::PROTOBUF_FIELD_BYTES_FIELD.coerce!(value)
          _protobuf_message_add_tag_to_serialize(2)
        end
      end
      alias_method :_protobuf_message_set_field_input_type, :_protobuf_message_set_field_2
      
      def _protobuf_message_encode_2_to_stream(value, stream)
        stream << [18].pack('C*') << ::PROTOBUF_FIELD_STRING_FIELD.encode(value)
      end
      alias_method :_protobuf_message_encode_input_type_to_stream, :_protobuf_message_encode_2_to_stream
      
      optional :string, :output_type, 3
      
      def _protobuf_message_set_field_3_bytes(bytes)
        _protobuf_message_set_field_3(::PROTOBUF_FIELD_STRING_FIELD.decode(bytes), true)
      end
      alias_method :_protobuf_message_set_field_output_type_bytes, :_protobuf_message_set_field_3_bytes
      
      def _protobuf_message_set_field_3(value, ignore_nil_for_repeated)
        if value.nil? # rubocop:disable Style/IfInsideElse
          @values.delete(:output_type)
          _protobuf_message_remove_tag_to_serialize(3)
        else
          @values[:output_type] = ::PROTOBUF_FIELD_BYTES_FIELD.coerce!(value)
          _protobuf_message_add_tag_to_serialize(3)
        end
      end
      alias_method :_protobuf_message_set_field_output_type, :_protobuf_message_set_field_3
      
      def _protobuf_message_encode_3_to_stream(value, stream)
        stream << [26].pack('C*') << ::PROTOBUF_FIELD_STRING_FIELD.encode(value)
      end
      alias_method :_protobuf_message_encode_output_type_to_stream, :_protobuf_message_encode_3_to_stream
      
      optional ::Google::Protobuf::MethodOptions, :options, 4
      
      def _protobuf_message_set_field_4_bytes(bytes)
        _protobuf_message_set_field_4(::Google::Protobuf::MethodOptions.decode(bytes), true)
      end
      alias_method :_protobuf_message_set_field_options_bytes, :_protobuf_message_set_field_4_bytes
      
      def _protobuf_message_set_field_4(value, ignore_nil_for_repeated)
        if value.nil? # rubocop:disable Style/IfInsideElse
          @values.delete(:options)
          _protobuf_message_remove_tag_to_serialize(4)
        else
          @values[:options] = value
          _protobuf_message_add_tag_to_serialize(4)
        end
      end
      alias_method :_protobuf_message_set_field_options, :_protobuf_message_set_field_4
      
      def _protobuf_message_encode_4_to_stream(value, stream)
        stream << [34].pack('C*') << ::Google::Protobuf::MethodOptions.encode(value)
      end
      alias_method :_protobuf_message_encode_options_to_stream, :_protobuf_message_encode_4_to_stream
      
      optional :bool, :client_streaming, 5, :default => false
      
      def _protobuf_message_set_field_5_bytes(bytes)
        _protobuf_message_set_field_5(::PROTOBUF_FIELD_BOOL_FIELD.decode(bytes), true)
      end
      alias_method :_protobuf_message_set_field_client_streaming_bytes, :_protobuf_message_set_field_5_bytes
      
      def _protobuf_message_set_field_5(value, ignore_nil_for_repeated)
        if value.nil? # rubocop:disable Style/IfInsideElse
          @values.delete(:client_streaming)
          _protobuf_message_remove_tag_to_serialize(5)
        else
          @values[:client_streaming] = ::PROTOBUF_FIELD_BOOL_FIELD.coerce!(value)
          _protobuf_message_add_tag_to_serialize(5)
        end
      end
      alias_method :_protobuf_message_set_field_client_streaming, :_protobuf_message_set_field_5
      
      def _protobuf_message_encode_5_to_stream(value, stream)
        stream << [40].pack('C*') << ::PROTOBUF_FIELD_BOOL_FIELD.encode(value)
      end
      alias_method :_protobuf_message_encode_client_streaming_to_stream, :_protobuf_message_encode_5_to_stream
      
      optional :bool, :server_streaming, 6, :default => false
      
      def _protobuf_message_set_field_6_bytes(bytes)
        _protobuf_message_set_field_6(::PROTOBUF_FIELD_BOOL_FIELD.decode(bytes), true)
      end
      alias_method :_protobuf_message_set_field_server_streaming_bytes, :_protobuf_message_set_field_6_bytes
      
      def _protobuf_message_set_field_6(value, ignore_nil_for_repeated)
        if value.nil? # rubocop:disable Style/IfInsideElse
          @values.delete(:server_streaming)
          _protobuf_message_remove_tag_to_serialize(6)
        else
          @values[:server_streaming] = ::PROTOBUF_FIELD_BOOL_FIELD.coerce!(value)
          _protobuf_message_add_tag_to_serialize(6)
        end
      end
      alias_method :_protobuf_message_set_field_server_streaming, :_protobuf_message_set_field_6
      
      def _protobuf_message_encode_6_to_stream(value, stream)
        stream << [48].pack('C*') << ::PROTOBUF_FIELD_BOOL_FIELD.encode(value)
      end
      alias_method :_protobuf_message_encode_server_streaming_to_stream, :_protobuf_message_encode_6_to_stream
      
      REQUIRED_FIELDS = [1, 2, 3, 4, 5, 6]
      
      def _protobuf_message_tags_to_serialize
        @_tags_to_serialize ||= ::Set.new
      end
      
      def _protobuf_message_add_tag_to_serialize(tag)
        @_tags_to_serialize.add(tag)
      end
      
      def _protobuf_message_clear_tags_to_serialize(tag)
        @_tags_to_serialize.clear
      end
      
      def _protobuf_message_remove_tag_to_serialize(tag)
        @_tags_to_serialize.delete(tag)
      end
      
      def _protobuf_message_serialize_message_to(stream)
      ##
      # Required
      #
      (@_tags_to_serialize - REQUIRED_FIELDS).each do |field_number|
        fail ::Protobuf::SerializationError, "Required field #{self.class.name}##{field_number} does not have a value."
      end
        @_tags_to_serialize.each do |tag_to_serialize|
          __send__("_protobuf_message_encode_#{tag_to_serialize}_to_stream", stream)
        end
      end
    end

    class FileOptions
      optional :string, :java_package, 1
      
      def _protobuf_message_set_field_1_bytes(bytes)
        _protobuf_message_set_field_1(::PROTOBUF_FIELD_STRING_FIELD.decode(bytes), true)
      end
      alias_method :_protobuf_message_set_field_java_package_bytes, :_protobuf_message_set_field_1_bytes
      
      def _protobuf_message_set_field_1(value, ignore_nil_for_repeated)
        if value.nil? # rubocop:disable Style/IfInsideElse
          @values.delete(:java_package)
          _protobuf_message_remove_tag_to_serialize(1)
        else
          @values[:java_package] = ::PROTOBUF_FIELD_BYTES_FIELD.coerce!(value)
          _protobuf_message_add_tag_to_serialize(1)
        end
      end
      alias_method :_protobuf_message_set_field_java_package, :_protobuf_message_set_field_1
      
      def _protobuf_message_encode_1_to_stream(value, stream)
        stream << [10].pack('C*') << ::PROTOBUF_FIELD_STRING_FIELD.encode(value)
      end
      alias_method :_protobuf_message_encode_java_package_to_stream, :_protobuf_message_encode_1_to_stream
      
      optional :string, :java_outer_classname, 8
      
      def _protobuf_message_set_field_8_bytes(bytes)
        _protobuf_message_set_field_8(::PROTOBUF_FIELD_STRING_FIELD.decode(bytes), true)
      end
      alias_method :_protobuf_message_set_field_java_outer_classname_bytes, :_protobuf_message_set_field_8_bytes
      
      def _protobuf_message_set_field_8(value, ignore_nil_for_repeated)
        if value.nil? # rubocop:disable Style/IfInsideElse
          @values.delete(:java_outer_classname)
          _protobuf_message_remove_tag_to_serialize(8)
        else
          @values[:java_outer_classname] = ::PROTOBUF_FIELD_BYTES_FIELD.coerce!(value)
          _protobuf_message_add_tag_to_serialize(8)
        end
      end
      alias_method :_protobuf_message_set_field_java_outer_classname, :_protobuf_message_set_field_8
      
      def _protobuf_message_encode_8_to_stream(value, stream)
        stream << [66].pack('C*') << ::PROTOBUF_FIELD_STRING_FIELD.encode(value)
      end
      alias_method :_protobuf_message_encode_java_outer_classname_to_stream, :_protobuf_message_encode_8_to_stream
      
      optional :bool, :java_multiple_files, 10, :default => false
      
      def _protobuf_message_set_field_10_bytes(bytes)
        _protobuf_message_set_field_10(::PROTOBUF_FIELD_BOOL_FIELD.decode(bytes), true)
      end
      alias_method :_protobuf_message_set_field_java_multiple_files_bytes, :_protobuf_message_set_field_10_bytes
      
      def _protobuf_message_set_field_10(value, ignore_nil_for_repeated)
        if value.nil? # rubocop:disable Style/IfInsideElse
          @values.delete(:java_multiple_files)
          _protobuf_message_remove_tag_to_serialize(10)
        else
          @values[:java_multiple_files] = ::PROTOBUF_FIELD_BOOL_FIELD.coerce!(value)
          _protobuf_message_add_tag_to_serialize(10)
        end
      end
      alias_method :_protobuf_message_set_field_java_multiple_files, :_protobuf_message_set_field_10
      
      def _protobuf_message_encode_10_to_stream(value, stream)
        stream << [80].pack('C*') << ::PROTOBUF_FIELD_BOOL_FIELD.encode(value)
      end
      alias_method :_protobuf_message_encode_java_multiple_files_to_stream, :_protobuf_message_encode_10_to_stream
      
      optional :bool, :java_generate_equals_and_hash, 20, :default => false
      
      def _protobuf_message_set_field_20_bytes(bytes)
        _protobuf_message_set_field_20(::PROTOBUF_FIELD_BOOL_FIELD.decode(bytes), true)
      end
      alias_method :_protobuf_message_set_field_java_generate_equals_and_hash_bytes, :_protobuf_message_set_field_20_bytes
      
      def _protobuf_message_set_field_20(value, ignore_nil_for_repeated)
        if value.nil? # rubocop:disable Style/IfInsideElse
          @values.delete(:java_generate_equals_and_hash)
          _protobuf_message_remove_tag_to_serialize(20)
        else
          @values[:java_generate_equals_and_hash] = ::PROTOBUF_FIELD_BOOL_FIELD.coerce!(value)
          _protobuf_message_add_tag_to_serialize(20)
        end
      end
      alias_method :_protobuf_message_set_field_java_generate_equals_and_hash, :_protobuf_message_set_field_20
      
      def _protobuf_message_encode_20_to_stream(value, stream)
        stream << [160, 1].pack('C*') << ::PROTOBUF_FIELD_BOOL_FIELD.encode(value)
      end
      alias_method :_protobuf_message_encode_java_generate_equals_and_hash_to_stream, :_protobuf_message_encode_20_to_stream
      
      optional :bool, :java_string_check_utf8, 27, :default => false
      
      def _protobuf_message_set_field_27_bytes(bytes)
        _protobuf_message_set_field_27(::PROTOBUF_FIELD_BOOL_FIELD.decode(bytes), true)
      end
      alias_method :_protobuf_message_set_field_java_string_check_utf8_bytes, :_protobuf_message_set_field_27_bytes
      
      def _protobuf_message_set_field_27(value, ignore_nil_for_repeated)
        if value.nil? # rubocop:disable Style/IfInsideElse
          @values.delete(:java_string_check_utf8)
          _protobuf_message_remove_tag_to_serialize(27)
        else
          @values[:java_string_check_utf8] = ::PROTOBUF_FIELD_BOOL_FIELD.coerce!(value)
          _protobuf_message_add_tag_to_serialize(27)
        end
      end
      alias_method :_protobuf_message_set_field_java_string_check_utf8, :_protobuf_message_set_field_27
      
      def _protobuf_message_encode_27_to_stream(value, stream)
        stream << [216, 1].pack('C*') << ::PROTOBUF_FIELD_BOOL_FIELD.encode(value)
      end
      alias_method :_protobuf_message_encode_java_string_check_utf8_to_stream, :_protobuf_message_encode_27_to_stream
      
      optional ::Google::Protobuf::FileOptions::OptimizeMode, :optimize_for, 9, :default => ::Google::Protobuf::FileOptions::OptimizeMode::SPEED
      
      def _protobuf_message_set_field_9_bytes(bytes)
        _protobuf_message_set_field_9(::Google::Protobuf::FileOptions::OptimizeMode.fetch(::PROTOBUF_FIELD_INTEGER_FIELD.decode(bytes)), true)
      end
      alias_method :_protobuf_message_set_field_optimize_for_bytes, :_protobuf_message_set_field_9_bytes
      
      def _protobuf_message_set_field_9(value, ignore_nil_for_repeated)
        if value.nil? # rubocop:disable Style/IfInsideElse
          @values.delete(:optimize_for)
          _protobuf_message_remove_tag_to_serialize(9)
        else
          @values[:optimize_for] = value
          _protobuf_message_add_tag_to_serialize(9)
        end
      end
      alias_method :_protobuf_message_set_field_optimize_for, :_protobuf_message_set_field_9
      
      def _protobuf_message_encode_9_to_stream(value, stream)
        stream << [72].pack('C*') << ::PROTOBUF_FIELD_INTEGER_FIELD.encode(value.to_i)
      end
      alias_method :_protobuf_message_encode_optimize_for_to_stream, :_protobuf_message_encode_9_to_stream
      
      optional :string, :go_package, 11
      
      def _protobuf_message_set_field_11_bytes(bytes)
        _protobuf_message_set_field_11(::PROTOBUF_FIELD_STRING_FIELD.decode(bytes), true)
      end
      alias_method :_protobuf_message_set_field_go_package_bytes, :_protobuf_message_set_field_11_bytes
      
      def _protobuf_message_set_field_11(value, ignore_nil_for_repeated)
        if value.nil? # rubocop:disable Style/IfInsideElse
          @values.delete(:go_package)
          _protobuf_message_remove_tag_to_serialize(11)
        else
          @values[:go_package] = ::PROTOBUF_FIELD_BYTES_FIELD.coerce!(value)
          _protobuf_message_add_tag_to_serialize(11)
        end
      end
      alias_method :_protobuf_message_set_field_go_package, :_protobuf_message_set_field_11
      
      def _protobuf_message_encode_11_to_stream(value, stream)
        stream << [90].pack('C*') << ::PROTOBUF_FIELD_STRING_FIELD.encode(value)
      end
      alias_method :_protobuf_message_encode_go_package_to_stream, :_protobuf_message_encode_11_to_stream
      
      optional :bool, :cc_generic_services, 16, :default => false
      
      def _protobuf_message_set_field_16_bytes(bytes)
        _protobuf_message_set_field_16(::PROTOBUF_FIELD_BOOL_FIELD.decode(bytes), true)
      end
      alias_method :_protobuf_message_set_field_cc_generic_services_bytes, :_protobuf_message_set_field_16_bytes
      
      def _protobuf_message_set_field_16(value, ignore_nil_for_repeated)
        if value.nil? # rubocop:disable Style/IfInsideElse
          @values.delete(:cc_generic_services)
          _protobuf_message_remove_tag_to_serialize(16)
        else
          @values[:cc_generic_services] = ::PROTOBUF_FIELD_BOOL_FIELD.coerce!(value)
          _protobuf_message_add_tag_to_serialize(16)
        end
      end
      alias_method :_protobuf_message_set_field_cc_generic_services, :_protobuf_message_set_field_16
      
      def _protobuf_message_encode_16_to_stream(value, stream)
        stream << [128, 1].pack('C*') << ::PROTOBUF_FIELD_BOOL_FIELD.encode(value)
      end
      alias_method :_protobuf_message_encode_cc_generic_services_to_stream, :_protobuf_message_encode_16_to_stream
      
      optional :bool, :java_generic_services, 17, :default => false
      
      def _protobuf_message_set_field_17_bytes(bytes)
        _protobuf_message_set_field_17(::PROTOBUF_FIELD_BOOL_FIELD.decode(bytes), true)
      end
      alias_method :_protobuf_message_set_field_java_generic_services_bytes, :_protobuf_message_set_field_17_bytes
      
      def _protobuf_message_set_field_17(value, ignore_nil_for_repeated)
        if value.nil? # rubocop:disable Style/IfInsideElse
          @values.delete(:java_generic_services)
          _protobuf_message_remove_tag_to_serialize(17)
        else
          @values[:java_generic_services] = ::PROTOBUF_FIELD_BOOL_FIELD.coerce!(value)
          _protobuf_message_add_tag_to_serialize(17)
        end
      end
      alias_method :_protobuf_message_set_field_java_generic_services, :_protobuf_message_set_field_17
      
      def _protobuf_message_encode_17_to_stream(value, stream)
        stream << [136, 1].pack('C*') << ::PROTOBUF_FIELD_BOOL_FIELD.encode(value)
      end
      alias_method :_protobuf_message_encode_java_generic_services_to_stream, :_protobuf_message_encode_17_to_stream
      
      optional :bool, :py_generic_services, 18, :default => false
      
      def _protobuf_message_set_field_18_bytes(bytes)
        _protobuf_message_set_field_18(::PROTOBUF_FIELD_BOOL_FIELD.decode(bytes), true)
      end
      alias_method :_protobuf_message_set_field_py_generic_services_bytes, :_protobuf_message_set_field_18_bytes
      
      def _protobuf_message_set_field_18(value, ignore_nil_for_repeated)
        if value.nil? # rubocop:disable Style/IfInsideElse
          @values.delete(:py_generic_services)
          _protobuf_message_remove_tag_to_serialize(18)
        else
          @values[:py_generic_services] = ::PROTOBUF_FIELD_BOOL_FIELD.coerce!(value)
          _protobuf_message_add_tag_to_serialize(18)
        end
      end
      alias_method :_protobuf_message_set_field_py_generic_services, :_protobuf_message_set_field_18
      
      def _protobuf_message_encode_18_to_stream(value, stream)
        stream << [144, 1].pack('C*') << ::PROTOBUF_FIELD_BOOL_FIELD.encode(value)
      end
      alias_method :_protobuf_message_encode_py_generic_services_to_stream, :_protobuf_message_encode_18_to_stream
      
      optional :bool, :deprecated, 23, :default => false
      
      def _protobuf_message_set_field_23_bytes(bytes)
        _protobuf_message_set_field_23(::PROTOBUF_FIELD_BOOL_FIELD.decode(bytes), true)
      end
      alias_method :_protobuf_message_set_field_deprecated_bytes, :_protobuf_message_set_field_23_bytes
      
      def _protobuf_message_set_field_23(value, ignore_nil_for_repeated)
        if value.nil? # rubocop:disable Style/IfInsideElse
          @values.delete(:deprecated)
          _protobuf_message_remove_tag_to_serialize(23)
        else
          @values[:deprecated] = ::PROTOBUF_FIELD_BOOL_FIELD.coerce!(value)
          _protobuf_message_add_tag_to_serialize(23)
        end
      end
      alias_method :_protobuf_message_set_field_deprecated, :_protobuf_message_set_field_23
      
      def _protobuf_message_encode_23_to_stream(value, stream)
        stream << [184, 1].pack('C*') << ::PROTOBUF_FIELD_BOOL_FIELD.encode(value)
      end
      alias_method :_protobuf_message_encode_deprecated_to_stream, :_protobuf_message_encode_23_to_stream
      
      optional :bool, :cc_enable_arenas, 31, :default => false
      
      def _protobuf_message_set_field_31_bytes(bytes)
        _protobuf_message_set_field_31(::PROTOBUF_FIELD_BOOL_FIELD.decode(bytes), true)
      end
      alias_method :_protobuf_message_set_field_cc_enable_arenas_bytes, :_protobuf_message_set_field_31_bytes
      
      def _protobuf_message_set_field_31(value, ignore_nil_for_repeated)
        if value.nil? # rubocop:disable Style/IfInsideElse
          @values.delete(:cc_enable_arenas)
          _protobuf_message_remove_tag_to_serialize(31)
        else
          @values[:cc_enable_arenas] = ::PROTOBUF_FIELD_BOOL_FIELD.coerce!(value)
          _protobuf_message_add_tag_to_serialize(31)
        end
      end
      alias_method :_protobuf_message_set_field_cc_enable_arenas, :_protobuf_message_set_field_31
      
      def _protobuf_message_encode_31_to_stream(value, stream)
        stream << [248, 1].pack('C*') << ::PROTOBUF_FIELD_BOOL_FIELD.encode(value)
      end
      alias_method :_protobuf_message_encode_cc_enable_arenas_to_stream, :_protobuf_message_encode_31_to_stream
      
      optional :string, :objc_class_prefix, 36
      
      def _protobuf_message_set_field_36_bytes(bytes)
        _protobuf_message_set_field_36(::PROTOBUF_FIELD_STRING_FIELD.decode(bytes), true)
      end
      alias_method :_protobuf_message_set_field_objc_class_prefix_bytes, :_protobuf_message_set_field_36_bytes
      
      def _protobuf_message_set_field_36(value, ignore_nil_for_repeated)
        if value.nil? # rubocop:disable Style/IfInsideElse
          @values.delete(:objc_class_prefix)
          _protobuf_message_remove_tag_to_serialize(36)
        else
          @values[:objc_class_prefix] = ::PROTOBUF_FIELD_BYTES_FIELD.coerce!(value)
          _protobuf_message_add_tag_to_serialize(36)
        end
      end
      alias_method :_protobuf_message_set_field_objc_class_prefix, :_protobuf_message_set_field_36
      
      def _protobuf_message_encode_36_to_stream(value, stream)
        stream << [162, 2].pack('C*') << ::PROTOBUF_FIELD_STRING_FIELD.encode(value)
      end
      alias_method :_protobuf_message_encode_objc_class_prefix_to_stream, :_protobuf_message_encode_36_to_stream
      
      optional :string, :csharp_namespace, 37
      
      def _protobuf_message_set_field_37_bytes(bytes)
        _protobuf_message_set_field_37(::PROTOBUF_FIELD_STRING_FIELD.decode(bytes), true)
      end
      alias_method :_protobuf_message_set_field_csharp_namespace_bytes, :_protobuf_message_set_field_37_bytes
      
      def _protobuf_message_set_field_37(value, ignore_nil_for_repeated)
        if value.nil? # rubocop:disable Style/IfInsideElse
          @values.delete(:csharp_namespace)
          _protobuf_message_remove_tag_to_serialize(37)
        else
          @values[:csharp_namespace] = ::PROTOBUF_FIELD_BYTES_FIELD.coerce!(value)
          _protobuf_message_add_tag_to_serialize(37)
        end
      end
      alias_method :_protobuf_message_set_field_csharp_namespace, :_protobuf_message_set_field_37
      
      def _protobuf_message_encode_37_to_stream(value, stream)
        stream << [170, 2].pack('C*') << ::PROTOBUF_FIELD_STRING_FIELD.encode(value)
      end
      alias_method :_protobuf_message_encode_csharp_namespace_to_stream, :_protobuf_message_encode_37_to_stream
      
      optional :bool, :javanano_use_deprecated_package, 38
      
      def _protobuf_message_set_field_38_bytes(bytes)
        _protobuf_message_set_field_38(::PROTOBUF_FIELD_BOOL_FIELD.decode(bytes), true)
      end
      alias_method :_protobuf_message_set_field_javanano_use_deprecated_package_bytes, :_protobuf_message_set_field_38_bytes
      
      def _protobuf_message_set_field_38(value, ignore_nil_for_repeated)
        if value.nil? # rubocop:disable Style/IfInsideElse
          @values.delete(:javanano_use_deprecated_package)
          _protobuf_message_remove_tag_to_serialize(38)
        else
          @values[:javanano_use_deprecated_package] = ::PROTOBUF_FIELD_BOOL_FIELD.coerce!(value)
          _protobuf_message_add_tag_to_serialize(38)
        end
      end
      alias_method :_protobuf_message_set_field_javanano_use_deprecated_package, :_protobuf_message_set_field_38
      
      def _protobuf_message_encode_38_to_stream(value, stream)
        stream << [176, 2].pack('C*') << ::PROTOBUF_FIELD_BOOL_FIELD.encode(value)
      end
      alias_method :_protobuf_message_encode_javanano_use_deprecated_package_to_stream, :_protobuf_message_encode_38_to_stream
      
      repeated ::Google::Protobuf::UninterpretedOption, :uninterpreted_option, 999
      
      def _protobuf_message_set_field_999_bytes(bytes)
        _protobuf_message_set_field_999(::Google::Protobuf::UninterpretedOption.decode(bytes), true)
      end
      alias_method :_protobuf_message_set_field_uninterpreted_option_bytes, :_protobuf_message_set_field_999_bytes
      
      def _protobuf_message_set_field_999(field, value, ignore_nil_for_repeated)
        if value.nil? && ignore_nil_for_repeated
          ::Protobuf.deprecator.deprecation_warning("[:uninterpreted_option]=nil", "use an empty array instead of nil")
          return
        end
        unless value.is_a?(Array)
          fail TypeError, <<-TYPE_ERROR
              Expected repeated value of type ::Google::Protobuf::UninterpretedOption
              Got #{value.class} for repeated protobuf field :uninterpreted_option
          TYPE_ERROR
        end
      
        value = value.compact
      
        if value.empty?
          @values.delete(:uninterpreted_option)
          _protobuf_message_remove_tag_to_serialize(999)
        else
          @values[:uninterpreted_option] ||= ::PROTOBUF_FIELD_FIELD_ARRAY.new(field)
          @values[:uninterpreted_option].replace(value)
          _protobuf_message_add_tag_to_serialize(999)
        end
      end
      alias_method :_protobuf_message_set_field_uninterpreted_option, :_protobuf_message_set_field_999
      
      
      def _protobuf_message_encode_999_to_stream(_value, stream)
        _value.each do |value|
          stream << [186, 62].pack('C*') << ::Google::Protobuf::UninterpretedOption.encode(value)
        end
      end
      alias_method :_protobuf_message_encode_uninterpreted_option_to_stream, :_protobuf_message_encode_999_to_stream
      
      # Extension Fields
      extensions 1000...536870912
      REQUIRED_FIELDS = [1, 8, 10, 20, 27, 9, 11, 16, 17, 18, 23, 31, 36, 37, 38, 999]
      
      def _protobuf_message_tags_to_serialize
        @_tags_to_serialize ||= ::Set.new
      end
      
      def _protobuf_message_add_tag_to_serialize(tag)
        @_tags_to_serialize.add(tag)
      end
      
      def _protobuf_message_clear_tags_to_serialize(tag)
        @_tags_to_serialize.clear
      end
      
      def _protobuf_message_remove_tag_to_serialize(tag)
        @_tags_to_serialize.delete(tag)
      end
      
      def _protobuf_message_serialize_message_to(stream)
      ##
      # Required
      #
      (@_tags_to_serialize - REQUIRED_FIELDS).each do |field_number|
        fail ::Protobuf::SerializationError, "Required field #{self.class.name}##{field_number} does not have a value."
      end
        @_tags_to_serialize.each do |tag_to_serialize|
          __send__("_protobuf_message_encode_#{tag_to_serialize}_to_stream", stream)
        end
      end
    end

    class MessageOptions
      optional :bool, :message_set_wire_format, 1, :default => false
      
      def _protobuf_message_set_field_1_bytes(bytes)
        _protobuf_message_set_field_1(::PROTOBUF_FIELD_BOOL_FIELD.decode(bytes), true)
      end
      alias_method :_protobuf_message_set_field_message_set_wire_format_bytes, :_protobuf_message_set_field_1_bytes
      
      def _protobuf_message_set_field_1(value, ignore_nil_for_repeated)
        if value.nil? # rubocop:disable Style/IfInsideElse
          @values.delete(:message_set_wire_format)
          _protobuf_message_remove_tag_to_serialize(1)
        else
          @values[:message_set_wire_format] = ::PROTOBUF_FIELD_BOOL_FIELD.coerce!(value)
          _protobuf_message_add_tag_to_serialize(1)
        end
      end
      alias_method :_protobuf_message_set_field_message_set_wire_format, :_protobuf_message_set_field_1
      
      def _protobuf_message_encode_1_to_stream(value, stream)
        stream << [8].pack('C*') << ::PROTOBUF_FIELD_BOOL_FIELD.encode(value)
      end
      alias_method :_protobuf_message_encode_message_set_wire_format_to_stream, :_protobuf_message_encode_1_to_stream
      
      optional :bool, :no_standard_descriptor_accessor, 2, :default => false
      
      def _protobuf_message_set_field_2_bytes(bytes)
        _protobuf_message_set_field_2(::PROTOBUF_FIELD_BOOL_FIELD.decode(bytes), true)
      end
      alias_method :_protobuf_message_set_field_no_standard_descriptor_accessor_bytes, :_protobuf_message_set_field_2_bytes
      
      def _protobuf_message_set_field_2(value, ignore_nil_for_repeated)
        if value.nil? # rubocop:disable Style/IfInsideElse
          @values.delete(:no_standard_descriptor_accessor)
          _protobuf_message_remove_tag_to_serialize(2)
        else
          @values[:no_standard_descriptor_accessor] = ::PROTOBUF_FIELD_BOOL_FIELD.coerce!(value)
          _protobuf_message_add_tag_to_serialize(2)
        end
      end
      alias_method :_protobuf_message_set_field_no_standard_descriptor_accessor, :_protobuf_message_set_field_2
      
      def _protobuf_message_encode_2_to_stream(value, stream)
        stream << [16].pack('C*') << ::PROTOBUF_FIELD_BOOL_FIELD.encode(value)
      end
      alias_method :_protobuf_message_encode_no_standard_descriptor_accessor_to_stream, :_protobuf_message_encode_2_to_stream
      
      optional :bool, :deprecated, 3, :default => false
      
      def _protobuf_message_set_field_3_bytes(bytes)
        _protobuf_message_set_field_3(::PROTOBUF_FIELD_BOOL_FIELD.decode(bytes), true)
      end
      alias_method :_protobuf_message_set_field_deprecated_bytes, :_protobuf_message_set_field_3_bytes
      
      def _protobuf_message_set_field_3(value, ignore_nil_for_repeated)
        if value.nil? # rubocop:disable Style/IfInsideElse
          @values.delete(:deprecated)
          _protobuf_message_remove_tag_to_serialize(3)
        else
          @values[:deprecated] = ::PROTOBUF_FIELD_BOOL_FIELD.coerce!(value)
          _protobuf_message_add_tag_to_serialize(3)
        end
      end
      alias_method :_protobuf_message_set_field_deprecated, :_protobuf_message_set_field_3
      
      def _protobuf_message_encode_3_to_stream(value, stream)
        stream << [24].pack('C*') << ::PROTOBUF_FIELD_BOOL_FIELD.encode(value)
      end
      alias_method :_protobuf_message_encode_deprecated_to_stream, :_protobuf_message_encode_3_to_stream
      
      optional :bool, :map_entry, 7
      
      def _protobuf_message_set_field_7_bytes(bytes)
        _protobuf_message_set_field_7(::PROTOBUF_FIELD_BOOL_FIELD.decode(bytes), true)
      end
      alias_method :_protobuf_message_set_field_map_entry_bytes, :_protobuf_message_set_field_7_bytes
      
      def _protobuf_message_set_field_7(value, ignore_nil_for_repeated)
        if value.nil? # rubocop:disable Style/IfInsideElse
          @values.delete(:map_entry)
          _protobuf_message_remove_tag_to_serialize(7)
        else
          @values[:map_entry] = ::PROTOBUF_FIELD_BOOL_FIELD.coerce!(value)
          _protobuf_message_add_tag_to_serialize(7)
        end
      end
      alias_method :_protobuf_message_set_field_map_entry, :_protobuf_message_set_field_7
      
      def _protobuf_message_encode_7_to_stream(value, stream)
        stream << [56].pack('C*') << ::PROTOBUF_FIELD_BOOL_FIELD.encode(value)
      end
      alias_method :_protobuf_message_encode_map_entry_to_stream, :_protobuf_message_encode_7_to_stream
      
      repeated ::Google::Protobuf::UninterpretedOption, :uninterpreted_option, 999
      
      def _protobuf_message_set_field_999_bytes(bytes)
        _protobuf_message_set_field_999(::Google::Protobuf::UninterpretedOption.decode(bytes), true)
      end
      alias_method :_protobuf_message_set_field_uninterpreted_option_bytes, :_protobuf_message_set_field_999_bytes
      
      def _protobuf_message_set_field_999(field, value, ignore_nil_for_repeated)
        if value.nil? && ignore_nil_for_repeated
          ::Protobuf.deprecator.deprecation_warning("[:uninterpreted_option]=nil", "use an empty array instead of nil")
          return
        end
        unless value.is_a?(Array)
          fail TypeError, <<-TYPE_ERROR
              Expected repeated value of type ::Google::Protobuf::UninterpretedOption
              Got #{value.class} for repeated protobuf field :uninterpreted_option
          TYPE_ERROR
        end
      
        value = value.compact
      
        if value.empty?
          @values.delete(:uninterpreted_option)
          _protobuf_message_remove_tag_to_serialize(999)
        else
          @values[:uninterpreted_option] ||= ::PROTOBUF_FIELD_FIELD_ARRAY.new(field)
          @values[:uninterpreted_option].replace(value)
          _protobuf_message_add_tag_to_serialize(999)
        end
      end
      alias_method :_protobuf_message_set_field_uninterpreted_option, :_protobuf_message_set_field_999
      
      
      def _protobuf_message_encode_999_to_stream(_value, stream)
        _value.each do |value|
          stream << [186, 62].pack('C*') << ::Google::Protobuf::UninterpretedOption.encode(value)
        end
      end
      alias_method :_protobuf_message_encode_uninterpreted_option_to_stream, :_protobuf_message_encode_999_to_stream
      
      # Extension Fields
      extensions 1000...536870912
      REQUIRED_FIELDS = [1, 2, 3, 7, 999]
      
      def _protobuf_message_tags_to_serialize
        @_tags_to_serialize ||= ::Set.new
      end
      
      def _protobuf_message_add_tag_to_serialize(tag)
        @_tags_to_serialize.add(tag)
      end
      
      def _protobuf_message_clear_tags_to_serialize(tag)
        @_tags_to_serialize.clear
      end
      
      def _protobuf_message_remove_tag_to_serialize(tag)
        @_tags_to_serialize.delete(tag)
      end
      
      def _protobuf_message_serialize_message_to(stream)
      ##
      # Required
      #
      (@_tags_to_serialize - REQUIRED_FIELDS).each do |field_number|
        fail ::Protobuf::SerializationError, "Required field #{self.class.name}##{field_number} does not have a value."
      end
        @_tags_to_serialize.each do |tag_to_serialize|
          __send__("_protobuf_message_encode_#{tag_to_serialize}_to_stream", stream)
        end
      end
    end

    class FieldOptions
      optional ::Google::Protobuf::FieldOptions::CType, :ctype, 1, :default => ::Google::Protobuf::FieldOptions::CType::STRING
      
      def _protobuf_message_set_field_1_bytes(bytes)
        _protobuf_message_set_field_1(::Google::Protobuf::FieldOptions::CType.fetch(::PROTOBUF_FIELD_INTEGER_FIELD.decode(bytes)), true)
      end
      alias_method :_protobuf_message_set_field_ctype_bytes, :_protobuf_message_set_field_1_bytes
      
      def _protobuf_message_set_field_1(value, ignore_nil_for_repeated)
        if value.nil? # rubocop:disable Style/IfInsideElse
          @values.delete(:ctype)
          _protobuf_message_remove_tag_to_serialize(1)
        else
          @values[:ctype] = value
          _protobuf_message_add_tag_to_serialize(1)
        end
      end
      alias_method :_protobuf_message_set_field_ctype, :_protobuf_message_set_field_1
      
      def _protobuf_message_encode_1_to_stream(value, stream)
        stream << [8].pack('C*') << ::PROTOBUF_FIELD_INTEGER_FIELD.encode(value.to_i)
      end
      alias_method :_protobuf_message_encode_ctype_to_stream, :_protobuf_message_encode_1_to_stream
      
      optional :bool, :packed, 2
      
      def _protobuf_message_set_field_2_bytes(bytes)
        _protobuf_message_set_field_2(::PROTOBUF_FIELD_BOOL_FIELD.decode(bytes), true)
      end
      alias_method :_protobuf_message_set_field_packed_bytes, :_protobuf_message_set_field_2_bytes
      
      def _protobuf_message_set_field_2(value, ignore_nil_for_repeated)
        if value.nil? # rubocop:disable Style/IfInsideElse
          @values.delete(:packed)
          _protobuf_message_remove_tag_to_serialize(2)
        else
          @values[:packed] = ::PROTOBUF_FIELD_BOOL_FIELD.coerce!(value)
          _protobuf_message_add_tag_to_serialize(2)
        end
      end
      alias_method :_protobuf_message_set_field_packed, :_protobuf_message_set_field_2
      
      def _protobuf_message_encode_2_to_stream(value, stream)
        stream << [16].pack('C*') << ::PROTOBUF_FIELD_BOOL_FIELD.encode(value)
      end
      alias_method :_protobuf_message_encode_packed_to_stream, :_protobuf_message_encode_2_to_stream
      
      optional ::Google::Protobuf::FieldOptions::JSType, :jstype, 6, :default => ::Google::Protobuf::FieldOptions::JSType::JS_NORMAL
      
      def _protobuf_message_set_field_6_bytes(bytes)
        _protobuf_message_set_field_6(::Google::Protobuf::FieldOptions::JSType.fetch(::PROTOBUF_FIELD_INTEGER_FIELD.decode(bytes)), true)
      end
      alias_method :_protobuf_message_set_field_jstype_bytes, :_protobuf_message_set_field_6_bytes
      
      def _protobuf_message_set_field_6(value, ignore_nil_for_repeated)
        if value.nil? # rubocop:disable Style/IfInsideElse
          @values.delete(:jstype)
          _protobuf_message_remove_tag_to_serialize(6)
        else
          @values[:jstype] = value
          _protobuf_message_add_tag_to_serialize(6)
        end
      end
      alias_method :_protobuf_message_set_field_jstype, :_protobuf_message_set_field_6
      
      def _protobuf_message_encode_6_to_stream(value, stream)
        stream << [48].pack('C*') << ::PROTOBUF_FIELD_INTEGER_FIELD.encode(value.to_i)
      end
      alias_method :_protobuf_message_encode_jstype_to_stream, :_protobuf_message_encode_6_to_stream
      
      optional :bool, :lazy, 5, :default => false
      
      def _protobuf_message_set_field_5_bytes(bytes)
        _protobuf_message_set_field_5(::PROTOBUF_FIELD_BOOL_FIELD.decode(bytes), true)
      end
      alias_method :_protobuf_message_set_field_lazy_bytes, :_protobuf_message_set_field_5_bytes
      
      def _protobuf_message_set_field_5(value, ignore_nil_for_repeated)
        if value.nil? # rubocop:disable Style/IfInsideElse
          @values.delete(:lazy)
          _protobuf_message_remove_tag_to_serialize(5)
        else
          @values[:lazy] = ::PROTOBUF_FIELD_BOOL_FIELD.coerce!(value)
          _protobuf_message_add_tag_to_serialize(5)
        end
      end
      alias_method :_protobuf_message_set_field_lazy, :_protobuf_message_set_field_5
      
      def _protobuf_message_encode_5_to_stream(value, stream)
        stream << [40].pack('C*') << ::PROTOBUF_FIELD_BOOL_FIELD.encode(value)
      end
      alias_method :_protobuf_message_encode_lazy_to_stream, :_protobuf_message_encode_5_to_stream
      
      optional :bool, :deprecated, 3, :default => false
      
      def _protobuf_message_set_field_3_bytes(bytes)
        _protobuf_message_set_field_3(::PROTOBUF_FIELD_BOOL_FIELD.decode(bytes), true)
      end
      alias_method :_protobuf_message_set_field_deprecated_bytes, :_protobuf_message_set_field_3_bytes
      
      def _protobuf_message_set_field_3(value, ignore_nil_for_repeated)
        if value.nil? # rubocop:disable Style/IfInsideElse
          @values.delete(:deprecated)
          _protobuf_message_remove_tag_to_serialize(3)
        else
          @values[:deprecated] = ::PROTOBUF_FIELD_BOOL_FIELD.coerce!(value)
          _protobuf_message_add_tag_to_serialize(3)
        end
      end
      alias_method :_protobuf_message_set_field_deprecated, :_protobuf_message_set_field_3
      
      def _protobuf_message_encode_3_to_stream(value, stream)
        stream << [24].pack('C*') << ::PROTOBUF_FIELD_BOOL_FIELD.encode(value)
      end
      alias_method :_protobuf_message_encode_deprecated_to_stream, :_protobuf_message_encode_3_to_stream
      
      optional :bool, :weak, 10, :default => false
      
      def _protobuf_message_set_field_10_bytes(bytes)
        _protobuf_message_set_field_10(::PROTOBUF_FIELD_BOOL_FIELD.decode(bytes), true)
      end
      alias_method :_protobuf_message_set_field_weak_bytes, :_protobuf_message_set_field_10_bytes
      
      def _protobuf_message_set_field_10(value, ignore_nil_for_repeated)
        if value.nil? # rubocop:disable Style/IfInsideElse
          @values.delete(:weak)
          _protobuf_message_remove_tag_to_serialize(10)
        else
          @values[:weak] = ::PROTOBUF_FIELD_BOOL_FIELD.coerce!(value)
          _protobuf_message_add_tag_to_serialize(10)
        end
      end
      alias_method :_protobuf_message_set_field_weak, :_protobuf_message_set_field_10
      
      def _protobuf_message_encode_10_to_stream(value, stream)
        stream << [80].pack('C*') << ::PROTOBUF_FIELD_BOOL_FIELD.encode(value)
      end
      alias_method :_protobuf_message_encode_weak_to_stream, :_protobuf_message_encode_10_to_stream
      
      repeated ::Google::Protobuf::UninterpretedOption, :uninterpreted_option, 999
      
      def _protobuf_message_set_field_999_bytes(bytes)
        _protobuf_message_set_field_999(::Google::Protobuf::UninterpretedOption.decode(bytes), true)
      end
      alias_method :_protobuf_message_set_field_uninterpreted_option_bytes, :_protobuf_message_set_field_999_bytes
      
      def _protobuf_message_set_field_999(field, value, ignore_nil_for_repeated)
        if value.nil? && ignore_nil_for_repeated
          ::Protobuf.deprecator.deprecation_warning("[:uninterpreted_option]=nil", "use an empty array instead of nil")
          return
        end
        unless value.is_a?(Array)
          fail TypeError, <<-TYPE_ERROR
              Expected repeated value of type ::Google::Protobuf::UninterpretedOption
              Got #{value.class} for repeated protobuf field :uninterpreted_option
          TYPE_ERROR
        end
      
        value = value.compact
      
        if value.empty?
          @values.delete(:uninterpreted_option)
          _protobuf_message_remove_tag_to_serialize(999)
        else
          @values[:uninterpreted_option] ||= ::PROTOBUF_FIELD_FIELD_ARRAY.new(field)
          @values[:uninterpreted_option].replace(value)
          _protobuf_message_add_tag_to_serialize(999)
        end
      end
      alias_method :_protobuf_message_set_field_uninterpreted_option, :_protobuf_message_set_field_999
      
      
      def _protobuf_message_encode_999_to_stream(_value, stream)
        _value.each do |value|
          stream << [186, 62].pack('C*') << ::Google::Protobuf::UninterpretedOption.encode(value)
        end
      end
      alias_method :_protobuf_message_encode_uninterpreted_option_to_stream, :_protobuf_message_encode_999_to_stream
      
      # Extension Fields
      extensions 1000...536870912
      REQUIRED_FIELDS = [1, 2, 6, 5, 3, 10, 999]
      
      def _protobuf_message_tags_to_serialize
        @_tags_to_serialize ||= ::Set.new
      end
      
      def _protobuf_message_add_tag_to_serialize(tag)
        @_tags_to_serialize.add(tag)
      end
      
      def _protobuf_message_clear_tags_to_serialize(tag)
        @_tags_to_serialize.clear
      end
      
      def _protobuf_message_remove_tag_to_serialize(tag)
        @_tags_to_serialize.delete(tag)
      end
      
      def _protobuf_message_serialize_message_to(stream)
      ##
      # Required
      #
      (@_tags_to_serialize - REQUIRED_FIELDS).each do |field_number|
        fail ::Protobuf::SerializationError, "Required field #{self.class.name}##{field_number} does not have a value."
      end
        @_tags_to_serialize.each do |tag_to_serialize|
          __send__("_protobuf_message_encode_#{tag_to_serialize}_to_stream", stream)
        end
      end
    end

    class EnumOptions
      optional :bool, :allow_alias, 2
      
      def _protobuf_message_set_field_2_bytes(bytes)
        _protobuf_message_set_field_2(::PROTOBUF_FIELD_BOOL_FIELD.decode(bytes), true)
      end
      alias_method :_protobuf_message_set_field_allow_alias_bytes, :_protobuf_message_set_field_2_bytes
      
      def _protobuf_message_set_field_2(value, ignore_nil_for_repeated)
        if value.nil? # rubocop:disable Style/IfInsideElse
          @values.delete(:allow_alias)
          _protobuf_message_remove_tag_to_serialize(2)
        else
          @values[:allow_alias] = ::PROTOBUF_FIELD_BOOL_FIELD.coerce!(value)
          _protobuf_message_add_tag_to_serialize(2)
        end
      end
      alias_method :_protobuf_message_set_field_allow_alias, :_protobuf_message_set_field_2
      
      def _protobuf_message_encode_2_to_stream(value, stream)
        stream << [16].pack('C*') << ::PROTOBUF_FIELD_BOOL_FIELD.encode(value)
      end
      alias_method :_protobuf_message_encode_allow_alias_to_stream, :_protobuf_message_encode_2_to_stream
      
      optional :bool, :deprecated, 3, :default => false
      
      def _protobuf_message_set_field_3_bytes(bytes)
        _protobuf_message_set_field_3(::PROTOBUF_FIELD_BOOL_FIELD.decode(bytes), true)
      end
      alias_method :_protobuf_message_set_field_deprecated_bytes, :_protobuf_message_set_field_3_bytes
      
      def _protobuf_message_set_field_3(value, ignore_nil_for_repeated)
        if value.nil? # rubocop:disable Style/IfInsideElse
          @values.delete(:deprecated)
          _protobuf_message_remove_tag_to_serialize(3)
        else
          @values[:deprecated] = ::PROTOBUF_FIELD_BOOL_FIELD.coerce!(value)
          _protobuf_message_add_tag_to_serialize(3)
        end
      end
      alias_method :_protobuf_message_set_field_deprecated, :_protobuf_message_set_field_3
      
      def _protobuf_message_encode_3_to_stream(value, stream)
        stream << [24].pack('C*') << ::PROTOBUF_FIELD_BOOL_FIELD.encode(value)
      end
      alias_method :_protobuf_message_encode_deprecated_to_stream, :_protobuf_message_encode_3_to_stream
      
      repeated ::Google::Protobuf::UninterpretedOption, :uninterpreted_option, 999
      
      def _protobuf_message_set_field_999_bytes(bytes)
        _protobuf_message_set_field_999(::Google::Protobuf::UninterpretedOption.decode(bytes), true)
      end
      alias_method :_protobuf_message_set_field_uninterpreted_option_bytes, :_protobuf_message_set_field_999_bytes
      
      def _protobuf_message_set_field_999(field, value, ignore_nil_for_repeated)
        if value.nil? && ignore_nil_for_repeated
          ::Protobuf.deprecator.deprecation_warning("[:uninterpreted_option]=nil", "use an empty array instead of nil")
          return
        end
        unless value.is_a?(Array)
          fail TypeError, <<-TYPE_ERROR
              Expected repeated value of type ::Google::Protobuf::UninterpretedOption
              Got #{value.class} for repeated protobuf field :uninterpreted_option
          TYPE_ERROR
        end
      
        value = value.compact
      
        if value.empty?
          @values.delete(:uninterpreted_option)
          _protobuf_message_remove_tag_to_serialize(999)
        else
          @values[:uninterpreted_option] ||= ::PROTOBUF_FIELD_FIELD_ARRAY.new(field)
          @values[:uninterpreted_option].replace(value)
          _protobuf_message_add_tag_to_serialize(999)
        end
      end
      alias_method :_protobuf_message_set_field_uninterpreted_option, :_protobuf_message_set_field_999
      
      
      def _protobuf_message_encode_999_to_stream(_value, stream)
        _value.each do |value|
          stream << [186, 62].pack('C*') << ::Google::Protobuf::UninterpretedOption.encode(value)
        end
      end
      alias_method :_protobuf_message_encode_uninterpreted_option_to_stream, :_protobuf_message_encode_999_to_stream
      
      # Extension Fields
      extensions 1000...536870912
      REQUIRED_FIELDS = [2, 3, 999]
      
      def _protobuf_message_tags_to_serialize
        @_tags_to_serialize ||= ::Set.new
      end
      
      def _protobuf_message_add_tag_to_serialize(tag)
        @_tags_to_serialize.add(tag)
      end
      
      def _protobuf_message_clear_tags_to_serialize(tag)
        @_tags_to_serialize.clear
      end
      
      def _protobuf_message_remove_tag_to_serialize(tag)
        @_tags_to_serialize.delete(tag)
      end
      
      def _protobuf_message_serialize_message_to(stream)
      ##
      # Required
      #
      (@_tags_to_serialize - REQUIRED_FIELDS).each do |field_number|
        fail ::Protobuf::SerializationError, "Required field #{self.class.name}##{field_number} does not have a value."
      end
        @_tags_to_serialize.each do |tag_to_serialize|
          __send__("_protobuf_message_encode_#{tag_to_serialize}_to_stream", stream)
        end
      end
    end

    class EnumValueOptions
      optional :bool, :deprecated, 1, :default => false
      
      def _protobuf_message_set_field_1_bytes(bytes)
        _protobuf_message_set_field_1(::PROTOBUF_FIELD_BOOL_FIELD.decode(bytes), true)
      end
      alias_method :_protobuf_message_set_field_deprecated_bytes, :_protobuf_message_set_field_1_bytes
      
      def _protobuf_message_set_field_1(value, ignore_nil_for_repeated)
        if value.nil? # rubocop:disable Style/IfInsideElse
          @values.delete(:deprecated)
          _protobuf_message_remove_tag_to_serialize(1)
        else
          @values[:deprecated] = ::PROTOBUF_FIELD_BOOL_FIELD.coerce!(value)
          _protobuf_message_add_tag_to_serialize(1)
        end
      end
      alias_method :_protobuf_message_set_field_deprecated, :_protobuf_message_set_field_1
      
      def _protobuf_message_encode_1_to_stream(value, stream)
        stream << [8].pack('C*') << ::PROTOBUF_FIELD_BOOL_FIELD.encode(value)
      end
      alias_method :_protobuf_message_encode_deprecated_to_stream, :_protobuf_message_encode_1_to_stream
      
      repeated ::Google::Protobuf::UninterpretedOption, :uninterpreted_option, 999
      
      def _protobuf_message_set_field_999_bytes(bytes)
        _protobuf_message_set_field_999(::Google::Protobuf::UninterpretedOption.decode(bytes), true)
      end
      alias_method :_protobuf_message_set_field_uninterpreted_option_bytes, :_protobuf_message_set_field_999_bytes
      
      def _protobuf_message_set_field_999(field, value, ignore_nil_for_repeated)
        if value.nil? && ignore_nil_for_repeated
          ::Protobuf.deprecator.deprecation_warning("[:uninterpreted_option]=nil", "use an empty array instead of nil")
          return
        end
        unless value.is_a?(Array)
          fail TypeError, <<-TYPE_ERROR
              Expected repeated value of type ::Google::Protobuf::UninterpretedOption
              Got #{value.class} for repeated protobuf field :uninterpreted_option
          TYPE_ERROR
        end
      
        value = value.compact
      
        if value.empty?
          @values.delete(:uninterpreted_option)
          _protobuf_message_remove_tag_to_serialize(999)
        else
          @values[:uninterpreted_option] ||= ::PROTOBUF_FIELD_FIELD_ARRAY.new(field)
          @values[:uninterpreted_option].replace(value)
          _protobuf_message_add_tag_to_serialize(999)
        end
      end
      alias_method :_protobuf_message_set_field_uninterpreted_option, :_protobuf_message_set_field_999
      
      
      def _protobuf_message_encode_999_to_stream(_value, stream)
        _value.each do |value|
          stream << [186, 62].pack('C*') << ::Google::Protobuf::UninterpretedOption.encode(value)
        end
      end
      alias_method :_protobuf_message_encode_uninterpreted_option_to_stream, :_protobuf_message_encode_999_to_stream
      
      # Extension Fields
      extensions 1000...536870912
      REQUIRED_FIELDS = [1, 999]
      
      def _protobuf_message_tags_to_serialize
        @_tags_to_serialize ||= ::Set.new
      end
      
      def _protobuf_message_add_tag_to_serialize(tag)
        @_tags_to_serialize.add(tag)
      end
      
      def _protobuf_message_clear_tags_to_serialize(tag)
        @_tags_to_serialize.clear
      end
      
      def _protobuf_message_remove_tag_to_serialize(tag)
        @_tags_to_serialize.delete(tag)
      end
      
      def _protobuf_message_serialize_message_to(stream)
      ##
      # Required
      #
      (@_tags_to_serialize - REQUIRED_FIELDS).each do |field_number|
        fail ::Protobuf::SerializationError, "Required field #{self.class.name}##{field_number} does not have a value."
      end
        @_tags_to_serialize.each do |tag_to_serialize|
          __send__("_protobuf_message_encode_#{tag_to_serialize}_to_stream", stream)
        end
      end
    end

    class ServiceOptions
      optional :bool, :deprecated, 33, :default => false
      
      def _protobuf_message_set_field_33_bytes(bytes)
        _protobuf_message_set_field_33(::PROTOBUF_FIELD_BOOL_FIELD.decode(bytes), true)
      end
      alias_method :_protobuf_message_set_field_deprecated_bytes, :_protobuf_message_set_field_33_bytes
      
      def _protobuf_message_set_field_33(value, ignore_nil_for_repeated)
        if value.nil? # rubocop:disable Style/IfInsideElse
          @values.delete(:deprecated)
          _protobuf_message_remove_tag_to_serialize(33)
        else
          @values[:deprecated] = ::PROTOBUF_FIELD_BOOL_FIELD.coerce!(value)
          _protobuf_message_add_tag_to_serialize(33)
        end
      end
      alias_method :_protobuf_message_set_field_deprecated, :_protobuf_message_set_field_33
      
      def _protobuf_message_encode_33_to_stream(value, stream)
        stream << [136, 2].pack('C*') << ::PROTOBUF_FIELD_BOOL_FIELD.encode(value)
      end
      alias_method :_protobuf_message_encode_deprecated_to_stream, :_protobuf_message_encode_33_to_stream
      
      repeated ::Google::Protobuf::UninterpretedOption, :uninterpreted_option, 999
      
      def _protobuf_message_set_field_999_bytes(bytes)
        _protobuf_message_set_field_999(::Google::Protobuf::UninterpretedOption.decode(bytes), true)
      end
      alias_method :_protobuf_message_set_field_uninterpreted_option_bytes, :_protobuf_message_set_field_999_bytes
      
      def _protobuf_message_set_field_999(field, value, ignore_nil_for_repeated)
        if value.nil? && ignore_nil_for_repeated
          ::Protobuf.deprecator.deprecation_warning("[:uninterpreted_option]=nil", "use an empty array instead of nil")
          return
        end
        unless value.is_a?(Array)
          fail TypeError, <<-TYPE_ERROR
              Expected repeated value of type ::Google::Protobuf::UninterpretedOption
              Got #{value.class} for repeated protobuf field :uninterpreted_option
          TYPE_ERROR
        end
      
        value = value.compact
      
        if value.empty?
          @values.delete(:uninterpreted_option)
          _protobuf_message_remove_tag_to_serialize(999)
        else
          @values[:uninterpreted_option] ||= ::PROTOBUF_FIELD_FIELD_ARRAY.new(field)
          @values[:uninterpreted_option].replace(value)
          _protobuf_message_add_tag_to_serialize(999)
        end
      end
      alias_method :_protobuf_message_set_field_uninterpreted_option, :_protobuf_message_set_field_999
      
      
      def _protobuf_message_encode_999_to_stream(_value, stream)
        _value.each do |value|
          stream << [186, 62].pack('C*') << ::Google::Protobuf::UninterpretedOption.encode(value)
        end
      end
      alias_method :_protobuf_message_encode_uninterpreted_option_to_stream, :_protobuf_message_encode_999_to_stream
      
      # Extension Fields
      extensions 1000...536870912
      REQUIRED_FIELDS = [33, 999]
      
      def _protobuf_message_tags_to_serialize
        @_tags_to_serialize ||= ::Set.new
      end
      
      def _protobuf_message_add_tag_to_serialize(tag)
        @_tags_to_serialize.add(tag)
      end
      
      def _protobuf_message_clear_tags_to_serialize(tag)
        @_tags_to_serialize.clear
      end
      
      def _protobuf_message_remove_tag_to_serialize(tag)
        @_tags_to_serialize.delete(tag)
      end
      
      def _protobuf_message_serialize_message_to(stream)
      ##
      # Required
      #
      (@_tags_to_serialize - REQUIRED_FIELDS).each do |field_number|
        fail ::Protobuf::SerializationError, "Required field #{self.class.name}##{field_number} does not have a value."
      end
        @_tags_to_serialize.each do |tag_to_serialize|
          __send__("_protobuf_message_encode_#{tag_to_serialize}_to_stream", stream)
        end
      end
    end

    class MethodOptions
      optional :bool, :deprecated, 33, :default => false
      
      def _protobuf_message_set_field_33_bytes(bytes)
        _protobuf_message_set_field_33(::PROTOBUF_FIELD_BOOL_FIELD.decode(bytes), true)
      end
      alias_method :_protobuf_message_set_field_deprecated_bytes, :_protobuf_message_set_field_33_bytes
      
      def _protobuf_message_set_field_33(value, ignore_nil_for_repeated)
        if value.nil? # rubocop:disable Style/IfInsideElse
          @values.delete(:deprecated)
          _protobuf_message_remove_tag_to_serialize(33)
        else
          @values[:deprecated] = ::PROTOBUF_FIELD_BOOL_FIELD.coerce!(value)
          _protobuf_message_add_tag_to_serialize(33)
        end
      end
      alias_method :_protobuf_message_set_field_deprecated, :_protobuf_message_set_field_33
      
      def _protobuf_message_encode_33_to_stream(value, stream)
        stream << [136, 2].pack('C*') << ::PROTOBUF_FIELD_BOOL_FIELD.encode(value)
      end
      alias_method :_protobuf_message_encode_deprecated_to_stream, :_protobuf_message_encode_33_to_stream
      
      repeated ::Google::Protobuf::UninterpretedOption, :uninterpreted_option, 999
      
      def _protobuf_message_set_field_999_bytes(bytes)
        _protobuf_message_set_field_999(::Google::Protobuf::UninterpretedOption.decode(bytes), true)
      end
      alias_method :_protobuf_message_set_field_uninterpreted_option_bytes, :_protobuf_message_set_field_999_bytes
      
      def _protobuf_message_set_field_999(field, value, ignore_nil_for_repeated)
        if value.nil? && ignore_nil_for_repeated
          ::Protobuf.deprecator.deprecation_warning("[:uninterpreted_option]=nil", "use an empty array instead of nil")
          return
        end
        unless value.is_a?(Array)
          fail TypeError, <<-TYPE_ERROR
              Expected repeated value of type ::Google::Protobuf::UninterpretedOption
              Got #{value.class} for repeated protobuf field :uninterpreted_option
          TYPE_ERROR
        end
      
        value = value.compact
      
        if value.empty?
          @values.delete(:uninterpreted_option)
          _protobuf_message_remove_tag_to_serialize(999)
        else
          @values[:uninterpreted_option] ||= ::PROTOBUF_FIELD_FIELD_ARRAY.new(field)
          @values[:uninterpreted_option].replace(value)
          _protobuf_message_add_tag_to_serialize(999)
        end
      end
      alias_method :_protobuf_message_set_field_uninterpreted_option, :_protobuf_message_set_field_999
      
      
      def _protobuf_message_encode_999_to_stream(_value, stream)
        _value.each do |value|
          stream << [186, 62].pack('C*') << ::Google::Protobuf::UninterpretedOption.encode(value)
        end
      end
      alias_method :_protobuf_message_encode_uninterpreted_option_to_stream, :_protobuf_message_encode_999_to_stream
      
      # Extension Fields
      extensions 1000...536870912
      REQUIRED_FIELDS = [33, 999]
      
      def _protobuf_message_tags_to_serialize
        @_tags_to_serialize ||= ::Set.new
      end
      
      def _protobuf_message_add_tag_to_serialize(tag)
        @_tags_to_serialize.add(tag)
      end
      
      def _protobuf_message_clear_tags_to_serialize(tag)
        @_tags_to_serialize.clear
      end
      
      def _protobuf_message_remove_tag_to_serialize(tag)
        @_tags_to_serialize.delete(tag)
      end
      
      def _protobuf_message_serialize_message_to(stream)
      ##
      # Required
      #
      (@_tags_to_serialize - REQUIRED_FIELDS).each do |field_number|
        fail ::Protobuf::SerializationError, "Required field #{self.class.name}##{field_number} does not have a value."
      end
        @_tags_to_serialize.each do |tag_to_serialize|
          __send__("_protobuf_message_encode_#{tag_to_serialize}_to_stream", stream)
        end
      end
    end

    class UninterpretedOption
      class NamePart
        required :string, :name_part, 1
        
        def _protobuf_message_set_field_1_bytes(bytes)
          _protobuf_message_set_field_1(::PROTOBUF_FIELD_STRING_FIELD.decode(bytes), true)
        end
        alias_method :_protobuf_message_set_field_name_part_bytes, :_protobuf_message_set_field_1_bytes
        
        def _protobuf_message_set_field_1(value, ignore_nil_for_repeated)
          if value.nil? # rubocop:disable Style/IfInsideElse
            @values.delete(:name_part)
            _protobuf_message_remove_tag_to_serialize(1)
          else
            @values[:name_part] = ::PROTOBUF_FIELD_BYTES_FIELD.coerce!(value)
            _protobuf_message_add_tag_to_serialize(1)
          end
        end
        alias_method :_protobuf_message_set_field_name_part, :_protobuf_message_set_field_1
        
        def _protobuf_message_encode_1_to_stream(value, stream)
          stream << [10].pack('C*') << ::PROTOBUF_FIELD_STRING_FIELD.encode(value)
        end
        alias_method :_protobuf_message_encode_name_part_to_stream, :_protobuf_message_encode_1_to_stream
        
        required :bool, :is_extension, 2
        
        def _protobuf_message_set_field_2_bytes(bytes)
          _protobuf_message_set_field_2(::PROTOBUF_FIELD_BOOL_FIELD.decode(bytes), true)
        end
        alias_method :_protobuf_message_set_field_is_extension_bytes, :_protobuf_message_set_field_2_bytes
        
        def _protobuf_message_set_field_2(value, ignore_nil_for_repeated)
          if value.nil? # rubocop:disable Style/IfInsideElse
            @values.delete(:is_extension)
            _protobuf_message_remove_tag_to_serialize(2)
          else
            @values[:is_extension] = ::PROTOBUF_FIELD_BOOL_FIELD.coerce!(value)
            _protobuf_message_add_tag_to_serialize(2)
          end
        end
        alias_method :_protobuf_message_set_field_is_extension, :_protobuf_message_set_field_2
        
        def _protobuf_message_encode_2_to_stream(value, stream)
          stream << [16].pack('C*') << ::PROTOBUF_FIELD_BOOL_FIELD.encode(value)
        end
        alias_method :_protobuf_message_encode_is_extension_to_stream, :_protobuf_message_encode_2_to_stream
        
        REQUIRED_FIELDS = [1, 2]
        
        def _protobuf_message_tags_to_serialize
          @_tags_to_serialize ||= ::Set.new
        end
        
        def _protobuf_message_add_tag_to_serialize(tag)
          @_tags_to_serialize.add(tag)
        end
        
        def _protobuf_message_clear_tags_to_serialize(tag)
          @_tags_to_serialize.clear
        end
        
        def _protobuf_message_remove_tag_to_serialize(tag)
          @_tags_to_serialize.delete(tag)
        end
        
        def _protobuf_message_serialize_message_to(stream)
        ##
        # Required
        #
        (@_tags_to_serialize - REQUIRED_FIELDS).each do |field_number|
          fail ::Protobuf::SerializationError, "Required field #{self.class.name}##{field_number} does not have a value."
        end
          @_tags_to_serialize.each do |tag_to_serialize|
            __send__("_protobuf_message_encode_#{tag_to_serialize}_to_stream", stream)
          end
        end
      end

      repeated ::Google::Protobuf::UninterpretedOption::NamePart, :name, 2
      
      def _protobuf_message_set_field_2_bytes(bytes)
        _protobuf_message_set_field_2(::Google::Protobuf::UninterpretedOption::NamePart.decode(bytes), true)
      end
      alias_method :_protobuf_message_set_field_name_bytes, :_protobuf_message_set_field_2_bytes
      
      def _protobuf_message_set_field_2(field, value, ignore_nil_for_repeated)
        if value.nil? && ignore_nil_for_repeated
          ::Protobuf.deprecator.deprecation_warning("[:name]=nil", "use an empty array instead of nil")
          return
        end
        unless value.is_a?(Array)
          fail TypeError, <<-TYPE_ERROR
              Expected repeated value of type ::Google::Protobuf::UninterpretedOption::NamePart
              Got #{value.class} for repeated protobuf field :name
          TYPE_ERROR
        end
      
        value = value.compact
      
        if value.empty?
          @values.delete(:name)
          _protobuf_message_remove_tag_to_serialize(2)
        else
          @values[:name] ||= ::PROTOBUF_FIELD_FIELD_ARRAY.new(field)
          @values[:name].replace(value)
          _protobuf_message_add_tag_to_serialize(2)
        end
      end
      alias_method :_protobuf_message_set_field_name, :_protobuf_message_set_field_2
      
      
      def _protobuf_message_encode_2_to_stream(_value, stream)
        _value.each do |value|
          stream << [18].pack('C*') << ::Google::Protobuf::UninterpretedOption::NamePart.encode(value)
        end
      end
      alias_method :_protobuf_message_encode_name_to_stream, :_protobuf_message_encode_2_to_stream
      
      optional :string, :identifier_value, 3
      
      def _protobuf_message_set_field_3_bytes(bytes)
        _protobuf_message_set_field_3(::PROTOBUF_FIELD_STRING_FIELD.decode(bytes), true)
      end
      alias_method :_protobuf_message_set_field_identifier_value_bytes, :_protobuf_message_set_field_3_bytes
      
      def _protobuf_message_set_field_3(value, ignore_nil_for_repeated)
        if value.nil? # rubocop:disable Style/IfInsideElse
          @values.delete(:identifier_value)
          _protobuf_message_remove_tag_to_serialize(3)
        else
          @values[:identifier_value] = ::PROTOBUF_FIELD_BYTES_FIELD.coerce!(value)
          _protobuf_message_add_tag_to_serialize(3)
        end
      end
      alias_method :_protobuf_message_set_field_identifier_value, :_protobuf_message_set_field_3
      
      def _protobuf_message_encode_3_to_stream(value, stream)
        stream << [26].pack('C*') << ::PROTOBUF_FIELD_STRING_FIELD.encode(value)
      end
      alias_method :_protobuf_message_encode_identifier_value_to_stream, :_protobuf_message_encode_3_to_stream
      
      optional :uint64, :positive_int_value, 4
      
      def _protobuf_message_set_field_4_bytes(bytes)
        _protobuf_message_set_field_4(::PROTOBUF_FIELD_UINT64_FIELD.decode(bytes), true)
      end
      alias_method :_protobuf_message_set_field_positive_int_value_bytes, :_protobuf_message_set_field_4_bytes
      
      def _protobuf_message_set_field_4(value, ignore_nil_for_repeated)
        if value.nil? # rubocop:disable Style/IfInsideElse
          @values.delete(:positive_int_value)
          _protobuf_message_remove_tag_to_serialize(4)
        else
          @values[:positive_int_value] = ::PROTOBUF_FIELD_UINT64_FIELD.coerce!(value)
          _protobuf_message_add_tag_to_serialize(4)
        end
      end
      alias_method :_protobuf_message_set_field_positive_int_value, :_protobuf_message_set_field_4
      
      def _protobuf_message_encode_4_to_stream(value, stream)
        stream << [32].pack('C*') << ::PROTOBUF_FIELD_UINT64_FIELD.encode(value)
      end
      alias_method :_protobuf_message_encode_positive_int_value_to_stream, :_protobuf_message_encode_4_to_stream
      
      optional :int64, :negative_int_value, 5
      
      def _protobuf_message_set_field_5_bytes(bytes)
        _protobuf_message_set_field_5(::PROTOBUF_FIELD_INT64_FIELD.decode(bytes), true)
      end
      alias_method :_protobuf_message_set_field_negative_int_value_bytes, :_protobuf_message_set_field_5_bytes
      
      def _protobuf_message_set_field_5(value, ignore_nil_for_repeated)
        if value.nil? # rubocop:disable Style/IfInsideElse
          @values.delete(:negative_int_value)
          _protobuf_message_remove_tag_to_serialize(5)
        else
          @values[:negative_int_value] = ::PROTOBUF_FIELD_INT64_FIELD.coerce!(value)
          _protobuf_message_add_tag_to_serialize(5)
        end
      end
      alias_method :_protobuf_message_set_field_negative_int_value, :_protobuf_message_set_field_5
      
      def _protobuf_message_encode_5_to_stream(value, stream)
        stream << [40].pack('C*') << ::PROTOBUF_FIELD_INT64_FIELD.encode(value)
      end
      alias_method :_protobuf_message_encode_negative_int_value_to_stream, :_protobuf_message_encode_5_to_stream
      
      optional :double, :double_value, 6
      
      def _protobuf_message_set_field_6_bytes(bytes)
        _protobuf_message_set_field_6(::PROTOBUF_FIELD_DOUBLE_FIELD.decode(bytes), true)
      end
      alias_method :_protobuf_message_set_field_double_value_bytes, :_protobuf_message_set_field_6_bytes
      
      def _protobuf_message_set_field_6(value, ignore_nil_for_repeated)
        if value.nil? # rubocop:disable Style/IfInsideElse
          @values.delete(:double_value)
          _protobuf_message_remove_tag_to_serialize(6)
        else
          @values[:double_value] = ::PROTOBUF_FIELD_FLOAT_FIELD.coerce!(value)
          _protobuf_message_add_tag_to_serialize(6)
        end
      end
      alias_method :_protobuf_message_set_field_double_value, :_protobuf_message_set_field_6
      
      def _protobuf_message_encode_6_to_stream(value, stream)
        stream << [49].pack('C*') << ::PROTOBUF_FIELD_DOUBLE_FIELD.encode(value)
      end
      alias_method :_protobuf_message_encode_double_value_to_stream, :_protobuf_message_encode_6_to_stream
      
      optional :bytes, :string_value, 7
      
      def _protobuf_message_set_field_7_bytes(bytes)
        _protobuf_message_set_field_7(::PROTOBUF_FIELD_BYTES_FIELD.decode(bytes), true)
      end
      alias_method :_protobuf_message_set_field_string_value_bytes, :_protobuf_message_set_field_7_bytes
      
      def _protobuf_message_set_field_7(value, ignore_nil_for_repeated)
        if value.nil? # rubocop:disable Style/IfInsideElse
          @values.delete(:string_value)
          _protobuf_message_remove_tag_to_serialize(7)
        else
          @values[:string_value] = ::PROTOBUF_FIELD_BYTES_FIELD.coerce!(value)
          _protobuf_message_add_tag_to_serialize(7)
        end
      end
      alias_method :_protobuf_message_set_field_string_value, :_protobuf_message_set_field_7
      
      def _protobuf_message_encode_7_to_stream(value, stream)
        stream << [58].pack('C*') << ::PROTOBUF_FIELD_BYTES_FIELD.encode(value)
      end
      alias_method :_protobuf_message_encode_string_value_to_stream, :_protobuf_message_encode_7_to_stream
      
      optional :string, :aggregate_value, 8
      
      def _protobuf_message_set_field_8_bytes(bytes)
        _protobuf_message_set_field_8(::PROTOBUF_FIELD_STRING_FIELD.decode(bytes), true)
      end
      alias_method :_protobuf_message_set_field_aggregate_value_bytes, :_protobuf_message_set_field_8_bytes
      
      def _protobuf_message_set_field_8(value, ignore_nil_for_repeated)
        if value.nil? # rubocop:disable Style/IfInsideElse
          @values.delete(:aggregate_value)
          _protobuf_message_remove_tag_to_serialize(8)
        else
          @values[:aggregate_value] = ::PROTOBUF_FIELD_BYTES_FIELD.coerce!(value)
          _protobuf_message_add_tag_to_serialize(8)
        end
      end
      alias_method :_protobuf_message_set_field_aggregate_value, :_protobuf_message_set_field_8
      
      def _protobuf_message_encode_8_to_stream(value, stream)
        stream << [66].pack('C*') << ::PROTOBUF_FIELD_STRING_FIELD.encode(value)
      end
      alias_method :_protobuf_message_encode_aggregate_value_to_stream, :_protobuf_message_encode_8_to_stream
      
      REQUIRED_FIELDS = [2, 3, 4, 5, 6, 7, 8]
      
      def _protobuf_message_tags_to_serialize
        @_tags_to_serialize ||= ::Set.new
      end
      
      def _protobuf_message_add_tag_to_serialize(tag)
        @_tags_to_serialize.add(tag)
      end
      
      def _protobuf_message_clear_tags_to_serialize(tag)
        @_tags_to_serialize.clear
      end
      
      def _protobuf_message_remove_tag_to_serialize(tag)
        @_tags_to_serialize.delete(tag)
      end
      
      def _protobuf_message_serialize_message_to(stream)
      ##
      # Required
      #
      (@_tags_to_serialize - REQUIRED_FIELDS).each do |field_number|
        fail ::Protobuf::SerializationError, "Required field #{self.class.name}##{field_number} does not have a value."
      end
        @_tags_to_serialize.each do |tag_to_serialize|
          __send__("_protobuf_message_encode_#{tag_to_serialize}_to_stream", stream)
        end
      end
    end

    class SourceCodeInfo
      class Location
        repeated :int32, :path, 1, :packed => true
        
        def _protobuf_message_set_field_1_bytes(bytes)
          _protobuf_message_set_field_1(::PROTOBUF_FIELD_INT32_FIELD.decode(bytes), true)
        end
        alias_method :_protobuf_message_set_field_path_bytes, :_protobuf_message_set_field_1_bytes
        
        def _protobuf_message_set_field_1(field, value, ignore_nil_for_repeated)
          if value.nil? && ignore_nil_for_repeated
            ::Protobuf.deprecator.deprecation_warning("[:path]=nil", "use an empty array instead of nil")
            return
          end
          unless value.is_a?(Array)
            fail TypeError, <<-TYPE_ERROR
                Expected repeated value of type :int32
                Got #{value.class} for repeated protobuf field :path
            TYPE_ERROR
          end
        
          value = value.compact
        
          if value.empty?
            @values.delete(:path)
            _protobuf_message_remove_tag_to_serialize(1)
          else
            @values[:path] ||= ::PROTOBUF_FIELD_FIELD_ARRAY.new(field)
            @values[:path].replace(value)
            _protobuf_message_add_tag_to_serialize(1)
          end
        end
        alias_method :_protobuf_message_set_field_path, :_protobuf_message_set_field_1
        
        
        def _protobuf_message_encode_1_to_stream(_value, stream)
          packed_value = _value.map { |value| ::PROTOBUF_FIELD_INT32_FIELD.encode(value) }.join
          stream << [10].pack('C*') << ::Protobuf::Field::VarintField.encode(packed_value.size) << packed_value
        end
        alias_method :_protobuf_message_encode_path_to_stream, :_protobuf_message_encode_1_to_stream
        
        repeated :int32, :span, 2, :packed => true
        
        def _protobuf_message_set_field_2_bytes(bytes)
          _protobuf_message_set_field_2(::PROTOBUF_FIELD_INT32_FIELD.decode(bytes), true)
        end
        alias_method :_protobuf_message_set_field_span_bytes, :_protobuf_message_set_field_2_bytes
        
        def _protobuf_message_set_field_2(field, value, ignore_nil_for_repeated)
          if value.nil? && ignore_nil_for_repeated
            ::Protobuf.deprecator.deprecation_warning("[:span]=nil", "use an empty array instead of nil")
            return
          end
          unless value.is_a?(Array)
            fail TypeError, <<-TYPE_ERROR
                Expected repeated value of type :int32
                Got #{value.class} for repeated protobuf field :span
            TYPE_ERROR
          end
        
          value = value.compact
        
          if value.empty?
            @values.delete(:span)
            _protobuf_message_remove_tag_to_serialize(2)
          else
            @values[:span] ||= ::PROTOBUF_FIELD_FIELD_ARRAY.new(field)
            @values[:span].replace(value)
            _protobuf_message_add_tag_to_serialize(2)
          end
        end
        alias_method :_protobuf_message_set_field_span, :_protobuf_message_set_field_2
        
        
        def _protobuf_message_encode_2_to_stream(_value, stream)
          packed_value = _value.map { |value| ::PROTOBUF_FIELD_INT32_FIELD.encode(value) }.join
          stream << [18].pack('C*') << ::Protobuf::Field::VarintField.encode(packed_value.size) << packed_value
        end
        alias_method :_protobuf_message_encode_span_to_stream, :_protobuf_message_encode_2_to_stream
        
        optional :string, :leading_comments, 3
        
        def _protobuf_message_set_field_3_bytes(bytes)
          _protobuf_message_set_field_3(::PROTOBUF_FIELD_STRING_FIELD.decode(bytes), true)
        end
        alias_method :_protobuf_message_set_field_leading_comments_bytes, :_protobuf_message_set_field_3_bytes
        
        def _protobuf_message_set_field_3(value, ignore_nil_for_repeated)
          if value.nil? # rubocop:disable Style/IfInsideElse
            @values.delete(:leading_comments)
            _protobuf_message_remove_tag_to_serialize(3)
          else
            @values[:leading_comments] = ::PROTOBUF_FIELD_BYTES_FIELD.coerce!(value)
            _protobuf_message_add_tag_to_serialize(3)
          end
        end
        alias_method :_protobuf_message_set_field_leading_comments, :_protobuf_message_set_field_3
        
        def _protobuf_message_encode_3_to_stream(value, stream)
          stream << [26].pack('C*') << ::PROTOBUF_FIELD_STRING_FIELD.encode(value)
        end
        alias_method :_protobuf_message_encode_leading_comments_to_stream, :_protobuf_message_encode_3_to_stream
        
        optional :string, :trailing_comments, 4
        
        def _protobuf_message_set_field_4_bytes(bytes)
          _protobuf_message_set_field_4(::PROTOBUF_FIELD_STRING_FIELD.decode(bytes), true)
        end
        alias_method :_protobuf_message_set_field_trailing_comments_bytes, :_protobuf_message_set_field_4_bytes
        
        def _protobuf_message_set_field_4(value, ignore_nil_for_repeated)
          if value.nil? # rubocop:disable Style/IfInsideElse
            @values.delete(:trailing_comments)
            _protobuf_message_remove_tag_to_serialize(4)
          else
            @values[:trailing_comments] = ::PROTOBUF_FIELD_BYTES_FIELD.coerce!(value)
            _protobuf_message_add_tag_to_serialize(4)
          end
        end
        alias_method :_protobuf_message_set_field_trailing_comments, :_protobuf_message_set_field_4
        
        def _protobuf_message_encode_4_to_stream(value, stream)
          stream << [34].pack('C*') << ::PROTOBUF_FIELD_STRING_FIELD.encode(value)
        end
        alias_method :_protobuf_message_encode_trailing_comments_to_stream, :_protobuf_message_encode_4_to_stream
        
        repeated :string, :leading_detached_comments, 6
        
        def _protobuf_message_set_field_6_bytes(bytes)
          _protobuf_message_set_field_6(::PROTOBUF_FIELD_STRING_FIELD.decode(bytes), true)
        end
        alias_method :_protobuf_message_set_field_leading_detached_comments_bytes, :_protobuf_message_set_field_6_bytes
        
        def _protobuf_message_set_field_6(field, value, ignore_nil_for_repeated)
          if value.nil? && ignore_nil_for_repeated
            ::Protobuf.deprecator.deprecation_warning("[:leading_detached_comments]=nil", "use an empty array instead of nil")
            return
          end
          unless value.is_a?(Array)
            fail TypeError, <<-TYPE_ERROR
                Expected repeated value of type :string
                Got #{value.class} for repeated protobuf field :leading_detached_comments
            TYPE_ERROR
          end
        
          value = value.compact
        
          if value.empty?
            @values.delete(:leading_detached_comments)
            _protobuf_message_remove_tag_to_serialize(6)
          else
            @values[:leading_detached_comments] ||= ::PROTOBUF_FIELD_FIELD_ARRAY.new(field)
            @values[:leading_detached_comments].replace(value)
            _protobuf_message_add_tag_to_serialize(6)
          end
        end
        alias_method :_protobuf_message_set_field_leading_detached_comments, :_protobuf_message_set_field_6
        
        
        def _protobuf_message_encode_6_to_stream(_value, stream)
          _value.each do |value|
            stream << [50].pack('C*') << ::PROTOBUF_FIELD_STRING_FIELD.encode(value)
          end
        end
        alias_method :_protobuf_message_encode_leading_detached_comments_to_stream, :_protobuf_message_encode_6_to_stream
        
        REQUIRED_FIELDS = [1, 2, 3, 4, 6]
        
        def _protobuf_message_tags_to_serialize
          @_tags_to_serialize ||= ::Set.new
        end
        
        def _protobuf_message_add_tag_to_serialize(tag)
          @_tags_to_serialize.add(tag)
        end
        
        def _protobuf_message_clear_tags_to_serialize(tag)
          @_tags_to_serialize.clear
        end
        
        def _protobuf_message_remove_tag_to_serialize(tag)
          @_tags_to_serialize.delete(tag)
        end
        
        def _protobuf_message_serialize_message_to(stream)
        ##
        # Required
        #
        (@_tags_to_serialize - REQUIRED_FIELDS).each do |field_number|
          fail ::Protobuf::SerializationError, "Required field #{self.class.name}##{field_number} does not have a value."
        end
          @_tags_to_serialize.each do |tag_to_serialize|
            __send__("_protobuf_message_encode_#{tag_to_serialize}_to_stream", stream)
          end
        end
      end

      repeated ::Google::Protobuf::SourceCodeInfo::Location, :location, 1
      
      def _protobuf_message_set_field_1_bytes(bytes)
        _protobuf_message_set_field_1(::Google::Protobuf::SourceCodeInfo::Location.decode(bytes), true)
      end
      alias_method :_protobuf_message_set_field_location_bytes, :_protobuf_message_set_field_1_bytes
      
      def _protobuf_message_set_field_1(field, value, ignore_nil_for_repeated)
        if value.nil? && ignore_nil_for_repeated
          ::Protobuf.deprecator.deprecation_warning("[:location]=nil", "use an empty array instead of nil")
          return
        end
        unless value.is_a?(Array)
          fail TypeError, <<-TYPE_ERROR
              Expected repeated value of type ::Google::Protobuf::SourceCodeInfo::Location
              Got #{value.class} for repeated protobuf field :location
          TYPE_ERROR
        end
      
        value = value.compact
      
        if value.empty?
          @values.delete(:location)
          _protobuf_message_remove_tag_to_serialize(1)
        else
          @values[:location] ||= ::PROTOBUF_FIELD_FIELD_ARRAY.new(field)
          @values[:location].replace(value)
          _protobuf_message_add_tag_to_serialize(1)
        end
      end
      alias_method :_protobuf_message_set_field_location, :_protobuf_message_set_field_1
      
      
      def _protobuf_message_encode_1_to_stream(_value, stream)
        _value.each do |value|
          stream << [10].pack('C*') << ::Google::Protobuf::SourceCodeInfo::Location.encode(value)
        end
      end
      alias_method :_protobuf_message_encode_location_to_stream, :_protobuf_message_encode_1_to_stream
      
      REQUIRED_FIELDS = [1]
      
      def _protobuf_message_tags_to_serialize
        @_tags_to_serialize ||= ::Set.new
      end
      
      def _protobuf_message_add_tag_to_serialize(tag)
        @_tags_to_serialize.add(tag)
      end
      
      def _protobuf_message_clear_tags_to_serialize(tag)
        @_tags_to_serialize.clear
      end
      
      def _protobuf_message_remove_tag_to_serialize(tag)
        @_tags_to_serialize.delete(tag)
      end
      
      def _protobuf_message_serialize_message_to(stream)
      ##
      # Required
      #
      (@_tags_to_serialize - REQUIRED_FIELDS).each do |field_number|
        fail ::Protobuf::SerializationError, "Required field #{self.class.name}##{field_number} does not have a value."
      end
        @_tags_to_serialize.each do |tag_to_serialize|
          __send__("_protobuf_message_encode_#{tag_to_serialize}_to_stream", stream)
        end
      end
    end

  end

end

