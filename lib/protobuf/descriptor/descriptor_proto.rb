require 'protobuf/message/message'
require 'protobuf/message/enum'
require 'protobuf/message/extend'

module Google
  module Protobuf
    ::Protobuf::OPTIONS[:"java_package"] = "com.google.protobuf"
    ::Protobuf::OPTIONS[:"java_outer_classname"] = "DescriptorProtos"
    ::Protobuf::OPTIONS[:"optimize_for"] = :SPEED
    class FileDescriptorProto < ::Protobuf::Message
      defined_in __FILE__
      optional :string, :name, 1
      optional :string, :package, 2
      repeated :string, :dependency, 3
      repeated :DescriptorProto, :message_type, 4
      repeated :EnumDescriptorProto, :enum_type, 5
      repeated :ServiceDescriptorProto, :service, 6
      repeated :FieldDescriptorProto, :extension, 7
      optional :FileOptions, :options, 8
    end
    class DescriptorProto < ::Protobuf::Message
      defined_in __FILE__
      optional :string, :name, 1
      repeated :FieldDescriptorProto, :field, 2
      repeated :FieldDescriptorProto, :extension, 6
      repeated :DescriptorProto, :nested_type, 3
      repeated :EnumDescriptorProto, :enum_type, 4
      class ExtensionRange < ::Protobuf::Message
        defined_in __FILE__
        optional :int32, :start, 1
        optional :int32, :end, 2
      end
      repeated :ExtensionRange, :extension_range, 5
      optional :MessageOptions, :options, 7
    end
    class FieldDescriptorProto < ::Protobuf::Message
      defined_in __FILE__
      class Type < ::Protobuf::Enum
        defined_in __FILE__
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
        defined_in __FILE__
        define :LABEL_OPTIONAL, 1
        define :LABEL_REQUIRED, 2
        define :LABEL_REPEATED, 3
      end
      optional :string, :name, 1
      optional :int32, :number, 3
      optional :Label, :label, 4
      optional :Type, :type, 5
      optional :string, :type_name, 6
      optional :string, :extendee, 2
      optional :string, :default_value, 7
      optional :FieldOptions, :options, 8
    end
    class EnumDescriptorProto < ::Protobuf::Message
      defined_in __FILE__
      optional :string, :name, 1
      repeated :EnumValueDescriptorProto, :value, 2
      optional :EnumOptions, :options, 3
    end
    class EnumValueDescriptorProto < ::Protobuf::Message
      defined_in __FILE__
      optional :string, :name, 1
      optional :int32, :number, 2
      optional :EnumValueOptions, :options, 3
    end
    class ServiceDescriptorProto < ::Protobuf::Message
      defined_in __FILE__
      optional :string, :name, 1
      repeated :MethodDescriptorProto, :method, 2
      optional :ServiceOptions, :options, 3
    end
    class MethodDescriptorProto < ::Protobuf::Message
      defined_in __FILE__
      optional :string, :name, 1
      optional :string, :input_type, 2
      optional :string, :output_type, 3
      optional :MethodOptions, :options, 4
    end
    class FileOptions < ::Protobuf::Message
      defined_in __FILE__
      optional :string, :java_package, 1
      optional :string, :java_outer_classname, 8
      optional :bool, :java_multiple_files, 10, :default => false
      class OptimizeMode < ::Protobuf::Enum
        defined_in __FILE__
        define :SPEED, 1
        define :CODE_SIZE, 2
      end
      optional :OptimizeMode, :optimize_for, 9, :default => :CODE_SIZE
    end
    class MessageOptions < ::Protobuf::Message
      defined_in __FILE__
      optional :bool, :message_set_wire_format, 1, :default => false
    end
    class FieldOptions < ::Protobuf::Message
      defined_in __FILE__
      optional :CType, :ctype, 1
      class CType < ::Protobuf::Enum
        defined_in __FILE__
        define :CORD, 1
        define :STRING_PIECE, 2
      end
      optional :string, :experimental_map_key, 9
    end
    class EnumOptions < ::Protobuf::Message
      defined_in __FILE__
    end
    class EnumValueOptions < ::Protobuf::Message
      defined_in __FILE__
    end
    class ServiceOptions < ::Protobuf::Message
      defined_in __FILE__
    end
    class MethodOptions < ::Protobuf::Message
      defined_in __FILE__
    end
  end
end
