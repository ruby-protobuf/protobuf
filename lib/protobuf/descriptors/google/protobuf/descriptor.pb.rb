##
# This file is auto-generated. DO NOT EDIT!
#
require 'protobuf/message'

module Google

  module Protobuf
  
    ##
    # Message Classes
    #
    class FileDescriptorSet < ::Protobuf::Message; end
    class FileDescriptorProto < ::Protobuf::Message; end
    class DescriptorProto < ::Protobuf::Message
      class ExtensionRange < ::Protobuf::Message; end
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
    # Message Fields
    #
    class FileDescriptorSet
      repeated ::Google::Protobuf::FileDescriptorProto, :file, 1
    end
    
    class FileDescriptorProto
      optional ::Protobuf::Field::StringField, :name, 1
      optional ::Protobuf::Field::StringField, :package, 2
      repeated ::Protobuf::Field::StringField, :dependency, 3
      repeated ::Protobuf::Field::Int32Field, :public_dependency, 10
      repeated ::Protobuf::Field::Int32Field, :weak_dependency, 11
      repeated ::Google::Protobuf::DescriptorProto, :message_type, 4
      repeated ::Google::Protobuf::EnumDescriptorProto, :enum_type, 5
      repeated ::Google::Protobuf::ServiceDescriptorProto, :service, 6
      repeated ::Google::Protobuf::FieldDescriptorProto, :extension, 7
      optional ::Google::Protobuf::FileOptions, :options, 8
      optional ::Google::Protobuf::SourceCodeInfo, :source_code_info, 9
    end
    
    class DescriptorProto
      class ExtensionRange
        optional ::Protobuf::Field::Int32Field, :start, 1
        optional ::Protobuf::Field::Int32Field, :end, 2
      end
      
      optional ::Protobuf::Field::StringField, :name, 1
      repeated ::Google::Protobuf::FieldDescriptorProto, :field, 2
      repeated ::Google::Protobuf::FieldDescriptorProto, :extension, 6
      repeated ::Google::Protobuf::DescriptorProto, :nested_type, 3
      repeated ::Google::Protobuf::EnumDescriptorProto, :enum_type, 4
      repeated ::Google::Protobuf::DescriptorProto::ExtensionRange, :extension_range, 5
      optional ::Google::Protobuf::MessageOptions, :options, 7
    end
    
    class FieldDescriptorProto
      optional ::Protobuf::Field::StringField, :name, 1
      optional ::Protobuf::Field::Int32Field, :number, 3
      optional ::Google::Protobuf::FieldDescriptorProto::Label, :label, 4
      optional ::Google::Protobuf::FieldDescriptorProto::Type, :type, 5
      optional ::Protobuf::Field::StringField, :type_name, 6
      optional ::Protobuf::Field::StringField, :extendee, 2
      optional ::Protobuf::Field::StringField, :default_value, 7
      optional ::Google::Protobuf::FieldOptions, :options, 8
    end
    
    class EnumDescriptorProto
      optional ::Protobuf::Field::StringField, :name, 1
      repeated ::Google::Protobuf::EnumValueDescriptorProto, :value, 2
      optional ::Google::Protobuf::EnumOptions, :options, 3
    end
    
    class EnumValueDescriptorProto
      optional ::Protobuf::Field::StringField, :name, 1
      optional ::Protobuf::Field::Int32Field, :number, 2
      optional ::Google::Protobuf::EnumValueOptions, :options, 3
    end
    
    class ServiceDescriptorProto
      optional ::Protobuf::Field::StringField, :name, 1
      repeated ::Google::Protobuf::MethodDescriptorProto, :method, 2
      optional ::Google::Protobuf::ServiceOptions, :options, 3
    end
    
    class MethodDescriptorProto
      optional ::Protobuf::Field::StringField, :name, 1
      optional ::Protobuf::Field::StringField, :input_type, 2
      optional ::Protobuf::Field::StringField, :output_type, 3
      optional ::Google::Protobuf::MethodOptions, :options, 4
    end
    
    class FileOptions
      optional ::Protobuf::Field::StringField, :java_package, 1
      optional ::Protobuf::Field::StringField, :java_outer_classname, 8
      optional ::Protobuf::Field::BoolField, :java_multiple_files, 10, :default => false
      optional ::Protobuf::Field::BoolField, :java_generate_equals_and_hash, 20, :default => false
      optional ::Google::Protobuf::FileOptions::OptimizeMode, :optimize_for, 9, :default => ::Google::Protobuf::FileOptions::OptimizeMode::SPEED
      optional ::Protobuf::Field::StringField, :go_package, 11
      optional ::Protobuf::Field::BoolField, :cc_generic_services, 16, :default => false
      optional ::Protobuf::Field::BoolField, :java_generic_services, 17, :default => false
      optional ::Protobuf::Field::BoolField, :py_generic_services, 18, :default => false
      repeated ::Google::Protobuf::UninterpretedOption, :uninterpreted_option, 999
      
      # Extension Fields
      extensions 1000...536870912
    end
    
    class MessageOptions
      optional ::Protobuf::Field::BoolField, :message_set_wire_format, 1, :default => false
      optional ::Protobuf::Field::BoolField, :no_standard_descriptor_accessor, 2, :default => false
      repeated ::Google::Protobuf::UninterpretedOption, :uninterpreted_option, 999
      
      # Extension Fields
      extensions 1000...536870912
    end
    
    class FieldOptions
      optional ::Google::Protobuf::FieldOptions::CType, :ctype, 1, :default => ::Google::Protobuf::FieldOptions::CType::STRING
      optional ::Protobuf::Field::BoolField, :packed, 2
      optional ::Protobuf::Field::BoolField, :lazy, 5, :default => false
      optional ::Protobuf::Field::BoolField, :deprecated, 3, :default => false
      optional ::Protobuf::Field::StringField, :experimental_map_key, 9
      optional ::Protobuf::Field::BoolField, :weak, 10, :default => false
      repeated ::Google::Protobuf::UninterpretedOption, :uninterpreted_option, 999
      
      # Extension Fields
      extensions 1000...536870912
    end
    
    class EnumOptions
      optional ::Protobuf::Field::BoolField, :allow_alias, 2, :default => true
      repeated ::Google::Protobuf::UninterpretedOption, :uninterpreted_option, 999
      
      # Extension Fields
      extensions 1000...536870912
    end
    
    class EnumValueOptions
      repeated ::Google::Protobuf::UninterpretedOption, :uninterpreted_option, 999
      
      # Extension Fields
      extensions 1000...536870912
    end
    
    class ServiceOptions
      repeated ::Google::Protobuf::UninterpretedOption, :uninterpreted_option, 999
      
      # Extension Fields
      extensions 1000...536870912
    end
    
    class MethodOptions
      repeated ::Google::Protobuf::UninterpretedOption, :uninterpreted_option, 999
      
      # Extension Fields
      extensions 1000...536870912
    end
    
    class UninterpretedOption
      class NamePart
        required ::Protobuf::Field::StringField, :name_part, 1
        required ::Protobuf::Field::BoolField, :is_extension, 2
      end
      
      repeated ::Google::Protobuf::UninterpretedOption::NamePart, :name, 2
      optional ::Protobuf::Field::StringField, :identifier_value, 3
      optional ::Protobuf::Field::Uint64Field, :positive_int_value, 4
      optional ::Protobuf::Field::Int64Field, :negative_int_value, 5
      optional ::Protobuf::Field::DoubleField, :double_value, 6
      optional ::Protobuf::Field::BytesField, :string_value, 7
      optional ::Protobuf::Field::StringField, :aggregate_value, 8
    end
    
    class SourceCodeInfo
      class Location
        repeated ::Protobuf::Field::Int32Field, :path, 1, :packed => true
        repeated ::Protobuf::Field::Int32Field, :span, 2, :packed => true
        optional ::Protobuf::Field::StringField, :leading_comments, 3
        optional ::Protobuf::Field::StringField, :trailing_comments, 4
      end
      
      repeated ::Google::Protobuf::SourceCodeInfo::Location, :location, 1
    end
    
    
  end
  
end

