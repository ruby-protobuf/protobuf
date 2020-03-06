# encoding: utf-8
# frozen_string_literal: true

##
# This file is auto-generated. DO NOT EDIT!
#
require 'base64'
require 'set'
require 'protobuf'

module Google
  module Protobuf
    FULLY_QUALIFIED_NAME = 'google.protobuf' unless defined?(self::FULLY_QUALIFIED_NAME)

    @descriptors = [] unless instance_variable_defined?(:@descriptors)
    @descriptors << lambda do
      bytes = File.read(__FILE__, mode: 'rb').split(/^__END__$/, 2).last
      ::Google::Protobuf::FileDescriptorProto.decode(Base64.decode64(bytes))
    end

    @descriptor_dependencies = Set.new unless instance_variable_defined?(:@descriptor_dependencies)
    @descriptor_dependencies |= []

    unless respond_to?(:descriptor_set)
      def self.descriptor_set
        ::Google::Protobuf::FileDescriptorSet.new(:file => @descriptors.map(&:call))
      end
    end

    unless respond_to?(:descriptor_dependencies)
      def self.descriptor_dependencies
        @descriptor_dependencies
      end
    end
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
        FULLY_QUALIFIED_NAME = FULLY_QUALIFIED_NAME + '.Type'

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
        FULLY_QUALIFIED_NAME = FULLY_QUALIFIED_NAME + '.Label'

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
        FULLY_QUALIFIED_NAME = FULLY_QUALIFIED_NAME + '.OptimizeMode'

        define :SPEED, 1
        define :CODE_SIZE, 2
        define :LITE_RUNTIME, 3
      end

    end

    class MessageOptions < ::Protobuf::Message; end
    class FieldOptions < ::Protobuf::Message
      class CType < ::Protobuf::Enum
        FULLY_QUALIFIED_NAME = FULLY_QUALIFIED_NAME + '.CType'

        define :STRING, 0
        define :CORD, 1
        define :STRING_PIECE, 2
      end

      class JSType < ::Protobuf::Enum
        FULLY_QUALIFIED_NAME = FULLY_QUALIFIED_NAME + '.JSType'

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
      FULLY_QUALIFIED_NAME = FULLY_QUALIFIED_NAME + '.FileDescriptorSet'
      repeated ::Google::Protobuf::FileDescriptorProto, :file, 1
    end

    class FileDescriptorProto
      FULLY_QUALIFIED_NAME = FULLY_QUALIFIED_NAME + '.FileDescriptorProto'
      optional :string, :name, 1
      optional :string, :package, 2
      repeated :string, :dependency, 3
      repeated :int32, :public_dependency, 10
      repeated :int32, :weak_dependency, 11
      repeated ::Google::Protobuf::DescriptorProto, :message_type, 4
      repeated ::Google::Protobuf::EnumDescriptorProto, :enum_type, 5
      repeated ::Google::Protobuf::ServiceDescriptorProto, :service, 6
      repeated ::Google::Protobuf::FieldDescriptorProto, :extension, 7
      optional ::Google::Protobuf::FileOptions, :options, 8
      optional ::Google::Protobuf::SourceCodeInfo, :source_code_info, 9
      optional :string, :syntax, 12
    end

    class DescriptorProto
      FULLY_QUALIFIED_NAME = FULLY_QUALIFIED_NAME + '.DescriptorProto'
      class ExtensionRange
        FULLY_QUALIFIED_NAME = FULLY_QUALIFIED_NAME + '.ExtensionRange'
        optional :int32, :start, 1
        optional :int32, :end, 2
      end

      class ReservedRange
        FULLY_QUALIFIED_NAME = FULLY_QUALIFIED_NAME + '.ReservedRange'
        optional :int32, :start, 1
        optional :int32, :end, 2
      end

      optional :string, :name, 1
      repeated ::Google::Protobuf::FieldDescriptorProto, :field, 2
      repeated ::Google::Protobuf::FieldDescriptorProto, :extension, 6
      repeated ::Google::Protobuf::DescriptorProto, :nested_type, 3
      repeated ::Google::Protobuf::EnumDescriptorProto, :enum_type, 4
      repeated ::Google::Protobuf::DescriptorProto::ExtensionRange, :extension_range, 5
      repeated ::Google::Protobuf::OneofDescriptorProto, :oneof_decl, 8
      optional ::Google::Protobuf::MessageOptions, :options, 7
      repeated ::Google::Protobuf::DescriptorProto::ReservedRange, :reserved_range, 9
      repeated :string, :reserved_name, 10
    end

    class FieldDescriptorProto
      FULLY_QUALIFIED_NAME = FULLY_QUALIFIED_NAME + '.FieldDescriptorProto'
      optional :string, :name, 1
      optional :int32, :number, 3
      optional ::Google::Protobuf::FieldDescriptorProto::Label, :label, 4
      optional ::Google::Protobuf::FieldDescriptorProto::Type, :type, 5
      optional :string, :type_name, 6
      optional :string, :extendee, 2
      optional :string, :default_value, 7
      optional :int32, :oneof_index, 9
      optional :string, :json_name, 10
      optional ::Google::Protobuf::FieldOptions, :options, 8
    end

    class OneofDescriptorProto
      FULLY_QUALIFIED_NAME = FULLY_QUALIFIED_NAME + '.OneofDescriptorProto'
      optional :string, :name, 1
    end

    class EnumDescriptorProto
      FULLY_QUALIFIED_NAME = FULLY_QUALIFIED_NAME + '.EnumDescriptorProto'
      optional :string, :name, 1
      repeated ::Google::Protobuf::EnumValueDescriptorProto, :value, 2
      optional ::Google::Protobuf::EnumOptions, :options, 3
    end

    class EnumValueDescriptorProto
      FULLY_QUALIFIED_NAME = FULLY_QUALIFIED_NAME + '.EnumValueDescriptorProto'
      optional :string, :name, 1
      optional :int32, :number, 2
      optional ::Google::Protobuf::EnumValueOptions, :options, 3
    end

    class ServiceDescriptorProto
      FULLY_QUALIFIED_NAME = FULLY_QUALIFIED_NAME + '.ServiceDescriptorProto'
      optional :string, :name, 1
      repeated ::Google::Protobuf::MethodDescriptorProto, :method, 2
      optional ::Google::Protobuf::ServiceOptions, :options, 3
    end

    class MethodDescriptorProto
      FULLY_QUALIFIED_NAME = FULLY_QUALIFIED_NAME + '.MethodDescriptorProto'
      optional :string, :name, 1
      optional :string, :input_type, 2
      optional :string, :output_type, 3
      optional ::Google::Protobuf::MethodOptions, :options, 4
      optional :bool, :client_streaming, 5, :default => false
      optional :bool, :server_streaming, 6, :default => false
    end

    class FileOptions
      FULLY_QUALIFIED_NAME = FULLY_QUALIFIED_NAME + '.FileOptions'
      optional :string, :java_package, 1
      optional :string, :java_outer_classname, 8
      optional :bool, :java_multiple_files, 10, :default => false
      optional :bool, :java_generate_equals_and_hash, 20, :default => false
      optional :bool, :java_string_check_utf8, 27, :default => false
      optional ::Google::Protobuf::FileOptions::OptimizeMode, :optimize_for, 9, :default => ::Google::Protobuf::FileOptions::OptimizeMode::SPEED
      optional :string, :go_package, 11
      optional :bool, :cc_generic_services, 16, :default => false
      optional :bool, :java_generic_services, 17, :default => false
      optional :bool, :py_generic_services, 18, :default => false
      optional :bool, :deprecated, 23, :default => false
      optional :bool, :cc_enable_arenas, 31, :default => false
      optional :string, :objc_class_prefix, 36
      optional :string, :csharp_namespace, 37
      optional :bool, :javanano_use_deprecated_package, 38
      repeated ::Google::Protobuf::UninterpretedOption, :uninterpreted_option, 999
      # Extension Fields
      extensions 1000...536870912
    end

    class MessageOptions
      FULLY_QUALIFIED_NAME = FULLY_QUALIFIED_NAME + '.MessageOptions'
      optional :bool, :message_set_wire_format, 1, :default => false
      optional :bool, :no_standard_descriptor_accessor, 2, :default => false
      optional :bool, :deprecated, 3, :default => false
      optional :bool, :map_entry, 7
      repeated ::Google::Protobuf::UninterpretedOption, :uninterpreted_option, 999
      # Extension Fields
      extensions 1000...536870912
    end

    class FieldOptions
      FULLY_QUALIFIED_NAME = FULLY_QUALIFIED_NAME + '.FieldOptions'
      optional ::Google::Protobuf::FieldOptions::CType, :ctype, 1, :default => ::Google::Protobuf::FieldOptions::CType::STRING
      optional :bool, :packed, 2
      optional ::Google::Protobuf::FieldOptions::JSType, :jstype, 6, :default => ::Google::Protobuf::FieldOptions::JSType::JS_NORMAL
      optional :bool, :lazy, 5, :default => false
      optional :bool, :deprecated, 3, :default => false
      optional :bool, :weak, 10, :default => false
      repeated ::Google::Protobuf::UninterpretedOption, :uninterpreted_option, 999
      # Extension Fields
      extensions 1000...536870912
    end

    class EnumOptions
      FULLY_QUALIFIED_NAME = FULLY_QUALIFIED_NAME + '.EnumOptions'
      optional :bool, :allow_alias, 2
      optional :bool, :deprecated, 3, :default => false
      repeated ::Google::Protobuf::UninterpretedOption, :uninterpreted_option, 999
      # Extension Fields
      extensions 1000...536870912
    end

    class EnumValueOptions
      FULLY_QUALIFIED_NAME = FULLY_QUALIFIED_NAME + '.EnumValueOptions'
      optional :bool, :deprecated, 1, :default => false
      repeated ::Google::Protobuf::UninterpretedOption, :uninterpreted_option, 999
      # Extension Fields
      extensions 1000...536870912
    end

    class ServiceOptions
      FULLY_QUALIFIED_NAME = FULLY_QUALIFIED_NAME + '.ServiceOptions'
      optional :bool, :deprecated, 33, :default => false
      repeated ::Google::Protobuf::UninterpretedOption, :uninterpreted_option, 999
      # Extension Fields
      extensions 1000...536870912
    end

    class MethodOptions
      FULLY_QUALIFIED_NAME = FULLY_QUALIFIED_NAME + '.MethodOptions'
      optional :bool, :deprecated, 33, :default => false
      repeated ::Google::Protobuf::UninterpretedOption, :uninterpreted_option, 999
      # Extension Fields
      extensions 1000...536870912
    end

    class UninterpretedOption
      FULLY_QUALIFIED_NAME = FULLY_QUALIFIED_NAME + '.UninterpretedOption'
      class NamePart
        FULLY_QUALIFIED_NAME = FULLY_QUALIFIED_NAME + '.NamePart'
        required :string, :name_part, 1
        required :bool, :is_extension, 2
      end

      repeated ::Google::Protobuf::UninterpretedOption::NamePart, :name, 2
      optional :string, :identifier_value, 3
      optional :uint64, :positive_int_value, 4
      optional :int64, :negative_int_value, 5
      optional :double, :double_value, 6
      optional :bytes, :string_value, 7
      optional :string, :aggregate_value, 8
    end

    class SourceCodeInfo
      FULLY_QUALIFIED_NAME = FULLY_QUALIFIED_NAME + '.SourceCodeInfo'
      class Location
        FULLY_QUALIFIED_NAME = FULLY_QUALIFIED_NAME + '.Location'
        repeated :int32, :path, 1, :packed => true
        repeated :int32, :span, 2, :packed => true
        optional :string, :leading_comments, 3
        optional :string, :trailing_comments, 4
        repeated :string, :leading_detached_comments, 6
      end

      repeated ::Google::Protobuf::SourceCodeInfo::Location, :location, 1
    end

  end

end


# Raw descriptor bytes below
__END__
CiBnb29nbGUvcHJvdG9idWYvZGVzY3JpcHRvci5wcm90bxIPZ29vZ2xlLnBy
b3RvYnVmIk0KEUZpbGVEZXNjcmlwdG9yU2V0EjgKBGZpbGUYASADKAsyJC5n
b29nbGUucHJvdG9idWYuRmlsZURlc2NyaXB0b3JQcm90b1IEZmlsZSLkBAoT
RmlsZURlc2NyaXB0b3JQcm90bxISCgRuYW1lGAEgASgJUgRuYW1lEhgKB3Bh
Y2thZ2UYAiABKAlSB3BhY2thZ2USHgoKZGVwZW5kZW5jeRgDIAMoCVIKZGVw
ZW5kZW5jeRIrChFwdWJsaWNfZGVwZW5kZW5jeRgKIAMoBVIQcHVibGljRGVw
ZW5kZW5jeRInCg93ZWFrX2RlcGVuZGVuY3kYCyADKAVSDndlYWtEZXBlbmRl
bmN5EkMKDG1lc3NhZ2VfdHlwZRgEIAMoCzIgLmdvb2dsZS5wcm90b2J1Zi5E
ZXNjcmlwdG9yUHJvdG9SC21lc3NhZ2VUeXBlEkEKCWVudW1fdHlwZRgFIAMo
CzIkLmdvb2dsZS5wcm90b2J1Zi5FbnVtRGVzY3JpcHRvclByb3RvUghlbnVt
VHlwZRJBCgdzZXJ2aWNlGAYgAygLMicuZ29vZ2xlLnByb3RvYnVmLlNlcnZp
Y2VEZXNjcmlwdG9yUHJvdG9SB3NlcnZpY2USQwoJZXh0ZW5zaW9uGAcgAygL
MiUuZ29vZ2xlLnByb3RvYnVmLkZpZWxkRGVzY3JpcHRvclByb3RvUglleHRl
bnNpb24SNgoHb3B0aW9ucxgIIAEoCzIcLmdvb2dsZS5wcm90b2J1Zi5GaWxl
T3B0aW9uc1IHb3B0aW9ucxJJChBzb3VyY2VfY29kZV9pbmZvGAkgASgLMh8u
Z29vZ2xlLnByb3RvYnVmLlNvdXJjZUNvZGVJbmZvUg5zb3VyY2VDb2RlSW5m
bxIWCgZzeW50YXgYDCABKAlSBnN5bnRheCL3BQoPRGVzY3JpcHRvclByb3Rv
EhIKBG5hbWUYASABKAlSBG5hbWUSOwoFZmllbGQYAiADKAsyJS5nb29nbGUu
cHJvdG9idWYuRmllbGREZXNjcmlwdG9yUHJvdG9SBWZpZWxkEkMKCWV4dGVu
c2lvbhgGIAMoCzIlLmdvb2dsZS5wcm90b2J1Zi5GaWVsZERlc2NyaXB0b3JQ
cm90b1IJZXh0ZW5zaW9uEkEKC25lc3RlZF90eXBlGAMgAygLMiAuZ29vZ2xl
LnByb3RvYnVmLkRlc2NyaXB0b3JQcm90b1IKbmVzdGVkVHlwZRJBCgllbnVt
X3R5cGUYBCADKAsyJC5nb29nbGUucHJvdG9idWYuRW51bURlc2NyaXB0b3JQ
cm90b1IIZW51bVR5cGUSWAoPZXh0ZW5zaW9uX3JhbmdlGAUgAygLMi8uZ29v
Z2xlLnByb3RvYnVmLkRlc2NyaXB0b3JQcm90by5FeHRlbnNpb25SYW5nZVIO
ZXh0ZW5zaW9uUmFuZ2USRAoKb25lb2ZfZGVjbBgIIAMoCzIlLmdvb2dsZS5w
cm90b2J1Zi5PbmVvZkRlc2NyaXB0b3JQcm90b1IJb25lb2ZEZWNsEjkKB29w
dGlvbnMYByABKAsyHy5nb29nbGUucHJvdG9idWYuTWVzc2FnZU9wdGlvbnNS
B29wdGlvbnMSVQoOcmVzZXJ2ZWRfcmFuZ2UYCSADKAsyLi5nb29nbGUucHJv
dG9idWYuRGVzY3JpcHRvclByb3RvLlJlc2VydmVkUmFuZ2VSDXJlc2VydmVk
UmFuZ2USIwoNcmVzZXJ2ZWRfbmFtZRgKIAMoCVIMcmVzZXJ2ZWROYW1lGjgK
DkV4dGVuc2lvblJhbmdlEhQKBXN0YXJ0GAEgASgFUgVzdGFydBIQCgNlbmQY
AiABKAVSA2VuZBo3Cg1SZXNlcnZlZFJhbmdlEhQKBXN0YXJ0GAEgASgFUgVz
dGFydBIQCgNlbmQYAiABKAVSA2VuZCKYBgoURmllbGREZXNjcmlwdG9yUHJv
dG8SEgoEbmFtZRgBIAEoCVIEbmFtZRIWCgZudW1iZXIYAyABKAVSBm51bWJl
chJBCgVsYWJlbBgEIAEoDjIrLmdvb2dsZS5wcm90b2J1Zi5GaWVsZERlc2Ny
aXB0b3JQcm90by5MYWJlbFIFbGFiZWwSPgoEdHlwZRgFIAEoDjIqLmdvb2ds
ZS5wcm90b2J1Zi5GaWVsZERlc2NyaXB0b3JQcm90by5UeXBlUgR0eXBlEhsK
CXR5cGVfbmFtZRgGIAEoCVIIdHlwZU5hbWUSGgoIZXh0ZW5kZWUYAiABKAlS
CGV4dGVuZGVlEiMKDWRlZmF1bHRfdmFsdWUYByABKAlSDGRlZmF1bHRWYWx1
ZRIfCgtvbmVvZl9pbmRleBgJIAEoBVIKb25lb2ZJbmRleBIbCglqc29uX25h
bWUYCiABKAlSCGpzb25OYW1lEjcKB29wdGlvbnMYCCABKAsyHS5nb29nbGUu
cHJvdG9idWYuRmllbGRPcHRpb25zUgdvcHRpb25zIrYCCgRUeXBlEg8KC1RZ
UEVfRE9VQkxFEAESDgoKVFlQRV9GTE9BVBACEg4KClRZUEVfSU5UNjQQAxIP
CgtUWVBFX1VJTlQ2NBAEEg4KClRZUEVfSU5UMzIQBRIQCgxUWVBFX0ZJWEVE
NjQQBhIQCgxUWVBFX0ZJWEVEMzIQBxINCglUWVBFX0JPT0wQCBIPCgtUWVBF
X1NUUklORxAJEg4KClRZUEVfR1JPVVAQChIQCgxUWVBFX01FU1NBR0UQCxIO
CgpUWVBFX0JZVEVTEAwSDwoLVFlQRV9VSU5UMzIQDRINCglUWVBFX0VOVU0Q
DhIRCg1UWVBFX1NGSVhFRDMyEA8SEQoNVFlQRV9TRklYRUQ2NBAQEg8KC1RZ
UEVfU0lOVDMyEBESDwoLVFlQRV9TSU5UNjQQEiJDCgVMYWJlbBISCg5MQUJF
TF9PUFRJT05BTBABEhIKDkxBQkVMX1JFUVVJUkVEEAISEgoOTEFCRUxfUkVQ
RUFURUQQAyIqChRPbmVvZkRlc2NyaXB0b3JQcm90bxISCgRuYW1lGAEgASgJ
UgRuYW1lIqIBChNFbnVtRGVzY3JpcHRvclByb3RvEhIKBG5hbWUYASABKAlS
BG5hbWUSPwoFdmFsdWUYAiADKAsyKS5nb29nbGUucHJvdG9idWYuRW51bVZh
bHVlRGVzY3JpcHRvclByb3RvUgV2YWx1ZRI2CgdvcHRpb25zGAMgASgLMhwu
Z29vZ2xlLnByb3RvYnVmLkVudW1PcHRpb25zUgdvcHRpb25zIoMBChhFbnVt
VmFsdWVEZXNjcmlwdG9yUHJvdG8SEgoEbmFtZRgBIAEoCVIEbmFtZRIWCgZu
dW1iZXIYAiABKAVSBm51bWJlchI7CgdvcHRpb25zGAMgASgLMiEuZ29vZ2xl
LnByb3RvYnVmLkVudW1WYWx1ZU9wdGlvbnNSB29wdGlvbnMipwEKFlNlcnZp
Y2VEZXNjcmlwdG9yUHJvdG8SEgoEbmFtZRgBIAEoCVIEbmFtZRI+CgZtZXRo
b2QYAiADKAsyJi5nb29nbGUucHJvdG9idWYuTWV0aG9kRGVzY3JpcHRvclBy
b3RvUgZtZXRob2QSOQoHb3B0aW9ucxgDIAEoCzIfLmdvb2dsZS5wcm90b2J1
Zi5TZXJ2aWNlT3B0aW9uc1IHb3B0aW9ucyKJAgoVTWV0aG9kRGVzY3JpcHRv
clByb3RvEhIKBG5hbWUYASABKAlSBG5hbWUSHQoKaW5wdXRfdHlwZRgCIAEo
CVIJaW5wdXRUeXBlEh8KC291dHB1dF90eXBlGAMgASgJUgpvdXRwdXRUeXBl
EjgKB29wdGlvbnMYBCABKAsyHi5nb29nbGUucHJvdG9idWYuTWV0aG9kT3B0
aW9uc1IHb3B0aW9ucxIwChBjbGllbnRfc3RyZWFtaW5nGAUgASgIOgVmYWxz
ZVIPY2xpZW50U3RyZWFtaW5nEjAKEHNlcnZlcl9zdHJlYW1pbmcYBiABKAg6
BWZhbHNlUg9zZXJ2ZXJTdHJlYW1pbmci0gcKC0ZpbGVPcHRpb25zEiEKDGph
dmFfcGFja2FnZRgBIAEoCVILamF2YVBhY2thZ2USMAoUamF2YV9vdXRlcl9j
bGFzc25hbWUYCCABKAlSEmphdmFPdXRlckNsYXNzbmFtZRI1ChNqYXZhX211
bHRpcGxlX2ZpbGVzGAogASgIOgVmYWxzZVIRamF2YU11bHRpcGxlRmlsZXMS
RwodamF2YV9nZW5lcmF0ZV9lcXVhbHNfYW5kX2hhc2gYFCABKAg6BWZhbHNl
UhlqYXZhR2VuZXJhdGVFcXVhbHNBbmRIYXNoEjoKFmphdmFfc3RyaW5nX2No
ZWNrX3V0ZjgYGyABKAg6BWZhbHNlUhNqYXZhU3RyaW5nQ2hlY2tVdGY4ElMK
DG9wdGltaXplX2ZvchgJIAEoDjIpLmdvb2dsZS5wcm90b2J1Zi5GaWxlT3B0
aW9ucy5PcHRpbWl6ZU1vZGU6BVNQRUVEUgtvcHRpbWl6ZUZvchIdCgpnb19w
YWNrYWdlGAsgASgJUglnb1BhY2thZ2USNQoTY2NfZ2VuZXJpY19zZXJ2aWNl
cxgQIAEoCDoFZmFsc2VSEWNjR2VuZXJpY1NlcnZpY2VzEjkKFWphdmFfZ2Vu
ZXJpY19zZXJ2aWNlcxgRIAEoCDoFZmFsc2VSE2phdmFHZW5lcmljU2Vydmlj
ZXMSNQoTcHlfZ2VuZXJpY19zZXJ2aWNlcxgSIAEoCDoFZmFsc2VSEXB5R2Vu
ZXJpY1NlcnZpY2VzEiUKCmRlcHJlY2F0ZWQYFyABKAg6BWZhbHNlUgpkZXBy
ZWNhdGVkEi8KEGNjX2VuYWJsZV9hcmVuYXMYHyABKAg6BWZhbHNlUg5jY0Vu
YWJsZUFyZW5hcxIqChFvYmpjX2NsYXNzX3ByZWZpeBgkIAEoCVIPb2JqY0Ns
YXNzUHJlZml4EikKEGNzaGFycF9uYW1lc3BhY2UYJSABKAlSD2NzaGFycE5h
bWVzcGFjZRJFCh9qYXZhbmFub191c2VfZGVwcmVjYXRlZF9wYWNrYWdlGCYg
ASgIUhxqYXZhbmFub1VzZURlcHJlY2F0ZWRQYWNrYWdlElgKFHVuaW50ZXJw
cmV0ZWRfb3B0aW9uGOcHIAMoCzIkLmdvb2dsZS5wcm90b2J1Zi5VbmludGVy
cHJldGVkT3B0aW9uUhN1bmludGVycHJldGVkT3B0aW9uIjoKDE9wdGltaXpl
TW9kZRIJCgVTUEVFRBABEg0KCUNPREVfU0laRRACEhAKDExJVEVfUlVOVElN
RRADKgkI6AcQgICAgAIixQIKDk1lc3NhZ2VPcHRpb25zEjwKF21lc3NhZ2Vf
c2V0X3dpcmVfZm9ybWF0GAEgASgIOgVmYWxzZVIUbWVzc2FnZVNldFdpcmVG
b3JtYXQSTAofbm9fc3RhbmRhcmRfZGVzY3JpcHRvcl9hY2Nlc3NvchgCIAEo
CDoFZmFsc2VSHG5vU3RhbmRhcmREZXNjcmlwdG9yQWNjZXNzb3ISJQoKZGVw
cmVjYXRlZBgDIAEoCDoFZmFsc2VSCmRlcHJlY2F0ZWQSGwoJbWFwX2VudHJ5
GAcgASgIUghtYXBFbnRyeRJYChR1bmludGVycHJldGVkX29wdGlvbhjnByAD
KAsyJC5nb29nbGUucHJvdG9idWYuVW5pbnRlcnByZXRlZE9wdGlvblITdW5p
bnRlcnByZXRlZE9wdGlvbioJCOgHEICAgIACItwDCgxGaWVsZE9wdGlvbnMS
QQoFY3R5cGUYASABKA4yIy5nb29nbGUucHJvdG9idWYuRmllbGRPcHRpb25z
LkNUeXBlOgZTVFJJTkdSBWN0eXBlEhYKBnBhY2tlZBgCIAEoCFIGcGFja2Vk
EkcKBmpzdHlwZRgGIAEoDjIkLmdvb2dsZS5wcm90b2J1Zi5GaWVsZE9wdGlv
bnMuSlNUeXBlOglKU19OT1JNQUxSBmpzdHlwZRIZCgRsYXp5GAUgASgIOgVm
YWxzZVIEbGF6eRIlCgpkZXByZWNhdGVkGAMgASgIOgVmYWxzZVIKZGVwcmVj
YXRlZBIZCgR3ZWFrGAogASgIOgVmYWxzZVIEd2VhaxJYChR1bmludGVycHJl
dGVkX29wdGlvbhjnByADKAsyJC5nb29nbGUucHJvdG9idWYuVW5pbnRlcnBy
ZXRlZE9wdGlvblITdW5pbnRlcnByZXRlZE9wdGlvbiIvCgVDVHlwZRIKCgZT
VFJJTkcQABIICgRDT1JEEAESEAoMU1RSSU5HX1BJRUNFEAIiNQoGSlNUeXBl
Eg0KCUpTX05PUk1BTBAAEg0KCUpTX1NUUklORxABEg0KCUpTX05VTUJFUhAC
KgkI6AcQgICAgAIiugEKC0VudW1PcHRpb25zEh8KC2FsbG93X2FsaWFzGAIg
ASgIUgphbGxvd0FsaWFzEiUKCmRlcHJlY2F0ZWQYAyABKAg6BWZhbHNlUgpk
ZXByZWNhdGVkElgKFHVuaW50ZXJwcmV0ZWRfb3B0aW9uGOcHIAMoCzIkLmdv
b2dsZS5wcm90b2J1Zi5VbmludGVycHJldGVkT3B0aW9uUhN1bmludGVycHJl
dGVkT3B0aW9uKgkI6AcQgICAgAIingEKEEVudW1WYWx1ZU9wdGlvbnMSJQoK
ZGVwcmVjYXRlZBgBIAEoCDoFZmFsc2VSCmRlcHJlY2F0ZWQSWAoUdW5pbnRl
cnByZXRlZF9vcHRpb24Y5wcgAygLMiQuZ29vZ2xlLnByb3RvYnVmLlVuaW50
ZXJwcmV0ZWRPcHRpb25SE3VuaW50ZXJwcmV0ZWRPcHRpb24qCQjoBxCAgICA
AiKcAQoOU2VydmljZU9wdGlvbnMSJQoKZGVwcmVjYXRlZBghIAEoCDoFZmFs
c2VSCmRlcHJlY2F0ZWQSWAoUdW5pbnRlcnByZXRlZF9vcHRpb24Y5wcgAygL
MiQuZ29vZ2xlLnByb3RvYnVmLlVuaW50ZXJwcmV0ZWRPcHRpb25SE3VuaW50
ZXJwcmV0ZWRPcHRpb24qCQjoBxCAgICAAiKbAQoNTWV0aG9kT3B0aW9ucxIl
CgpkZXByZWNhdGVkGCEgASgIOgVmYWxzZVIKZGVwcmVjYXRlZBJYChR1bmlu
dGVycHJldGVkX29wdGlvbhjnByADKAsyJC5nb29nbGUucHJvdG9idWYuVW5p
bnRlcnByZXRlZE9wdGlvblITdW5pbnRlcnByZXRlZE9wdGlvbioJCOgHEICA
gIACIpoDChNVbmludGVycHJldGVkT3B0aW9uEkEKBG5hbWUYAiADKAsyLS5n
b29nbGUucHJvdG9idWYuVW5pbnRlcnByZXRlZE9wdGlvbi5OYW1lUGFydFIE
bmFtZRIpChBpZGVudGlmaWVyX3ZhbHVlGAMgASgJUg9pZGVudGlmaWVyVmFs
dWUSLAoScG9zaXRpdmVfaW50X3ZhbHVlGAQgASgEUhBwb3NpdGl2ZUludFZh
bHVlEiwKEm5lZ2F0aXZlX2ludF92YWx1ZRgFIAEoA1IQbmVnYXRpdmVJbnRW
YWx1ZRIhCgxkb3VibGVfdmFsdWUYBiABKAFSC2RvdWJsZVZhbHVlEiEKDHN0
cmluZ192YWx1ZRgHIAEoDFILc3RyaW5nVmFsdWUSJwoPYWdncmVnYXRlX3Zh
bHVlGAggASgJUg5hZ2dyZWdhdGVWYWx1ZRpKCghOYW1lUGFydBIbCgluYW1l
X3BhcnQYASACKAlSCG5hbWVQYXJ0EiEKDGlzX2V4dGVuc2lvbhgCIAIoCFIL
aXNFeHRlbnNpb24ipwIKDlNvdXJjZUNvZGVJbmZvEkQKCGxvY2F0aW9uGAEg
AygLMiguZ29vZ2xlLnByb3RvYnVmLlNvdXJjZUNvZGVJbmZvLkxvY2F0aW9u
Ughsb2NhdGlvbhrOAQoITG9jYXRpb24SFgoEcGF0aBgBIAMoBUICEAFSBHBh
dGgSFgoEc3BhbhgCIAMoBUICEAFSBHNwYW4SKQoQbGVhZGluZ19jb21tZW50
cxgDIAEoCVIPbGVhZGluZ0NvbW1lbnRzEisKEXRyYWlsaW5nX2NvbW1lbnRz
GAQgASgJUhB0cmFpbGluZ0NvbW1lbnRzEjoKGWxlYWRpbmdfZGV0YWNoZWRf
Y29tbWVudHMYBiADKAlSF2xlYWRpbmdEZXRhY2hlZENvbW1lbnRzQlgKE2Nv
bS5nb29nbGUucHJvdG9idWZCEERlc2NyaXB0b3JQcm90b3NIAVoKZGVzY3Jp
cHRvcqICA0dQQqoCGkdvb2dsZS5Qcm90b2J1Zi5SZWZsZWN0aW9uSpeZAgoH
EgUnAIoGAQqqDwoBDBIDJwASMsEMIFByb3RvY29sIEJ1ZmZlcnMgLSBHb29n
bGUncyBkYXRhIGludGVyY2hhbmdlIGZvcm1hdAogQ29weXJpZ2h0IDIwMDgg
R29vZ2xlIEluYy4gIEFsbCByaWdodHMgcmVzZXJ2ZWQuCiBodHRwczovL2Rl
dmVsb3BlcnMuZ29vZ2xlLmNvbS9wcm90b2NvbC1idWZmZXJzLwoKIFJlZGlz
dHJpYnV0aW9uIGFuZCB1c2UgaW4gc291cmNlIGFuZCBiaW5hcnkgZm9ybXMs
IHdpdGggb3Igd2l0aG91dAogbW9kaWZpY2F0aW9uLCBhcmUgcGVybWl0dGVk
IHByb3ZpZGVkIHRoYXQgdGhlIGZvbGxvd2luZyBjb25kaXRpb25zIGFyZQog
bWV0OgoKICAgICAqIFJlZGlzdHJpYnV0aW9ucyBvZiBzb3VyY2UgY29kZSBt
dXN0IHJldGFpbiB0aGUgYWJvdmUgY29weXJpZ2h0CiBub3RpY2UsIHRoaXMg
bGlzdCBvZiBjb25kaXRpb25zIGFuZCB0aGUgZm9sbG93aW5nIGRpc2NsYWlt
ZXIuCiAgICAgKiBSZWRpc3RyaWJ1dGlvbnMgaW4gYmluYXJ5IGZvcm0gbXVz
dCByZXByb2R1Y2UgdGhlIGFib3ZlCiBjb3B5cmlnaHQgbm90aWNlLCB0aGlz
IGxpc3Qgb2YgY29uZGl0aW9ucyBhbmQgdGhlIGZvbGxvd2luZyBkaXNjbGFp
bWVyCiBpbiB0aGUgZG9jdW1lbnRhdGlvbiBhbmQvb3Igb3RoZXIgbWF0ZXJp
YWxzIHByb3ZpZGVkIHdpdGggdGhlCiBkaXN0cmlidXRpb24uCiAgICAgKiBO
ZWl0aGVyIHRoZSBuYW1lIG9mIEdvb2dsZSBJbmMuIG5vciB0aGUgbmFtZXMg
b2YgaXRzCiBjb250cmlidXRvcnMgbWF5IGJlIHVzZWQgdG8gZW5kb3JzZSBv
ciBwcm9tb3RlIHByb2R1Y3RzIGRlcml2ZWQgZnJvbQogdGhpcyBzb2Z0d2Fy
ZSB3aXRob3V0IHNwZWNpZmljIHByaW9yIHdyaXR0ZW4gcGVybWlzc2lvbi4K
CiBUSElTIFNPRlRXQVJFIElTIFBST1ZJREVEIEJZIFRIRSBDT1BZUklHSFQg
SE9MREVSUyBBTkQgQ09OVFJJQlVUT1JTCiAiQVMgSVMiIEFORCBBTlkgRVhQ
UkVTUyBPUiBJTVBMSUVEIFdBUlJBTlRJRVMsIElOQ0xVRElORywgQlVUIE5P
VAogTElNSVRFRCBUTywgVEhFIElNUExJRUQgV0FSUkFOVElFUyBPRiBNRVJD
SEFOVEFCSUxJVFkgQU5EIEZJVE5FU1MgRk9SCiBBIFBBUlRJQ1VMQVIgUFVS
UE9TRSBBUkUgRElTQ0xBSU1FRC4gSU4gTk8gRVZFTlQgU0hBTEwgVEhFIENP
UFlSSUdIVAogT1dORVIgT1IgQ09OVFJJQlVUT1JTIEJFIExJQUJMRSBGT1Ig
QU5ZIERJUkVDVCwgSU5ESVJFQ1QsIElOQ0lERU5UQUwsCiBTUEVDSUFMLCBF
WEVNUExBUlksIE9SIENPTlNFUVVFTlRJQUwgREFNQUdFUyAoSU5DTFVESU5H
LCBCVVQgTk9UCiBMSU1JVEVEIFRPLCBQUk9DVVJFTUVOVCBPRiBTVUJTVElU
VVRFIEdPT0RTIE9SIFNFUlZJQ0VTOyBMT1NTIE9GIFVTRSwKIERBVEEsIE9S
IFBST0ZJVFM7IE9SIEJVU0lORVNTIElOVEVSUlVQVElPTikgSE9XRVZFUiBD
QVVTRUQgQU5EIE9OIEFOWQogVEhFT1JZIE9GIExJQUJJTElUWSwgV0hFVEhF
UiBJTiBDT05UUkFDVCwgU1RSSUNUIExJQUJJTElUWSwgT1IgVE9SVAogKElO
Q0xVRElORyBORUdMSUdFTkNFIE9SIE9USEVSV0lTRSkgQVJJU0lORyBJTiBB
TlkgV0FZIE9VVCBPRiBUSEUgVVNFCiBPRiBUSElTIFNPRlRXQVJFLCBFVkVO
IElGIEFEVklTRUQgT0YgVEhFIFBPU1NJQklMSVRZIE9GIFNVQ0ggREFNQUdF
Lgoy2wIgQXV0aG9yOiBrZW50b25AZ29vZ2xlLmNvbSAoS2VudG9uIFZhcmRh
KQogIEJhc2VkIG9uIG9yaWdpbmFsIFByb3RvY29sIEJ1ZmZlcnMgZGVzaWdu
IGJ5CiAgU2FuamF5IEdoZW1hd2F0LCBKZWZmIERlYW4sIGFuZCBvdGhlcnMu
CgogVGhlIG1lc3NhZ2VzIGluIHRoaXMgZmlsZSBkZXNjcmliZSB0aGUgZGVm
aW5pdGlvbnMgZm91bmQgaW4gLnByb3RvIGZpbGVzLgogQSB2YWxpZCAucHJv
dG8gZmlsZSBjYW4gYmUgdHJhbnNsYXRlZCBkaXJlY3RseSB0byBhIEZpbGVE
ZXNjcmlwdG9yUHJvdG8KIHdpdGhvdXQgYW55IG90aGVyIGluZm9ybWF0aW9u
IChlLmcuIHdpdGhvdXQgcmVhZGluZyBpdHMgaW1wb3J0cykuCgoICgECEgMp
ABgKCAoBCBIDKgAhCgkKAggLEgMqACEKCAoBCBIDKwAsCgkKAggBEgMrACwK
CAoBCBIDLAAxCgkKAggIEgMsADEKCAoBCBIDLQA3CgkKAgglEgMtADcKCAoB
CBIDLgAhCgkKAggkEgMuACEKCAoBCBIDMgAcCn8KAggJEgMyABwadCBkZXNj
cmlwdG9yLnByb3RvIG11c3QgYmUgb3B0aW1pemVkIGZvciBzcGVlZCBiZWNh
dXNlIHJlZmxlY3Rpb24tYmFzZWQKIGFsZ29yaXRobXMgZG9uJ3Qgd29yayBk
dXJpbmcgYm9vdHN0cmFwcGluZy4KCmoKAgQAEgQ2ADgBGl4gVGhlIHByb3Rv
Y29sIGNvbXBpbGVyIGNhbiBvdXRwdXQgYSBGaWxlRGVzY3JpcHRvclNldCBj
b250YWluaW5nIHRoZSAucHJvdG8KIGZpbGVzIGl0IHBhcnNlcy4KCgoKAwQA
ARIDNggZCgsKBAQAAgASAzcCKAoMCgUEAAIABBIDNwIKCgwKBQQAAgAGEgM3
Cx4KDAoFBAACAAESAzcfIwoMCgUEAAIAAxIDNyYnCi8KAgQBEgQ7AFgBGiMg
RGVzY3JpYmVzIGEgY29tcGxldGUgLnByb3RvIGZpbGUuCgoKCgMEAQESAzsI
Gwo5CgQEAQIAEgM8AhsiLCBmaWxlIG5hbWUsIHJlbGF0aXZlIHRvIHJvb3Qg
b2Ygc291cmNlIHRyZWUKCgwKBQQBAgAEEgM8AgoKDAoFBAECAAUSAzwLEQoM
CgUEAQIAARIDPBIWCgwKBQQBAgADEgM8GRoKKgoEBAECARIDPQIeIh0gZS5n
LiAiZm9vIiwgImZvby5iYXIiLCBldGMuCgoMCgUEAQIBBBIDPQIKCgwKBQQB
AgEFEgM9CxEKDAoFBAECAQESAz0SGQoMCgUEAQIBAxIDPRwdCjQKBAQBAgIS
A0ACIRonIE5hbWVzIG9mIGZpbGVzIGltcG9ydGVkIGJ5IHRoaXMgZmlsZS4K
CgwKBQQBAgIEEgNAAgoKDAoFBAECAgUSA0ALEQoMCgUEAQICARIDQBIcCgwK
BQQBAgIDEgNAHyAKUQoEBAECAxIDQgIoGkQgSW5kZXhlcyBvZiB0aGUgcHVi
bGljIGltcG9ydGVkIGZpbGVzIGluIHRoZSBkZXBlbmRlbmN5IGxpc3QgYWJv
dmUuCgoMCgUEAQIDBBIDQgIKCgwKBQQBAgMFEgNCCxAKDAoFBAECAwESA0IR
IgoMCgUEAQIDAxIDQiUnCnoKBAQBAgQSA0UCJhptIEluZGV4ZXMgb2YgdGhl
IHdlYWsgaW1wb3J0ZWQgZmlsZXMgaW4gdGhlIGRlcGVuZGVuY3kgbGlzdC4K
IEZvciBHb29nbGUtaW50ZXJuYWwgbWlncmF0aW9uIG9ubHkuIERvIG5vdCB1
c2UuCgoMCgUEAQIEBBIDRQIKCgwKBQQBAgQFEgNFCxAKDAoFBAECBAESA0UR
IAoMCgUEAQIEAxIDRSMlCjYKBAQBAgUSA0gCLBopIEFsbCB0b3AtbGV2ZWwg
ZGVmaW5pdGlvbnMgaW4gdGhpcyBmaWxlLgoKDAoFBAECBQQSA0gCCgoMCgUE
AQIFBhIDSAsaCgwKBQQBAgUBEgNIGycKDAoFBAECBQMSA0gqKwoLCgQEAQIG
EgNJAi0KDAoFBAECBgQSA0kCCgoMCgUEAQIGBhIDSQseCgwKBQQBAgYBEgNJ
HygKDAoFBAECBgMSA0krLAoLCgQEAQIHEgNKAi4KDAoFBAECBwQSA0oCCgoM
CgUEAQIHBhIDSgshCgwKBQQBAgcBEgNKIikKDAoFBAECBwMSA0osLQoLCgQE
AQIIEgNLAi4KDAoFBAECCAQSA0sCCgoMCgUEAQIIBhIDSwsfCgwKBQQBAggB
EgNLICkKDAoFBAECCAMSA0ssLQoLCgQEAQIJEgNNAiMKDAoFBAECCQQSA00C
CgoMCgUEAQIJBhIDTQsWCgwKBQQBAgkBEgNNFx4KDAoFBAECCQMSA00hIgr0
AQoEBAECChIDUwIvGuYBIFRoaXMgZmllbGQgY29udGFpbnMgb3B0aW9uYWwg
aW5mb3JtYXRpb24gYWJvdXQgdGhlIG9yaWdpbmFsIHNvdXJjZSBjb2RlLgog
WW91IG1heSBzYWZlbHkgcmVtb3ZlIHRoaXMgZW50aXJlIGZpZWxkIHdpdGhv
dXQgaGFybWluZyBydW50aW1lCiBmdW5jdGlvbmFsaXR5IG9mIHRoZSBkZXNj
cmlwdG9ycyAtLSB0aGUgaW5mb3JtYXRpb24gaXMgbmVlZGVkIG9ubHkgYnkK
IGRldmVsb3BtZW50IHRvb2xzLgoKDAoFBAECCgQSA1MCCgoMCgUEAQIKBhID
UwsZCgwKBQQBAgoBEgNTGioKDAoFBAECCgMSA1MtLgpdCgQEAQILEgNXAh4a
UCBUaGUgc3ludGF4IG9mIHRoZSBwcm90byBmaWxlLgogVGhlIHN1cHBvcnRl
ZCB2YWx1ZXMgYXJlICJwcm90bzIiIGFuZCAicHJvdG8zIi4KCgwKBQQBAgsE
EgNXAgoKDAoFBAECCwUSA1cLEQoMCgUEAQILARIDVxIYCgwKBQQBAgsDEgNX
Gx0KJwoCBAISBFsAeQEaGyBEZXNjcmliZXMgYSBtZXNzYWdlIHR5cGUuCgoK
CgMEAgESA1sIFwoLCgQEAgIAEgNcAhsKDAoFBAICAAQSA1wCCgoMCgUEAgIA
BRIDXAsRCgwKBQQCAgABEgNcEhYKDAoFBAICAAMSA1wZGgoLCgQEAgIBEgNe
AioKDAoFBAICAQQSA14CCgoMCgUEAgIBBhIDXgsfCgwKBQQCAgEBEgNeICUK
DAoFBAICAQMSA14oKQoLCgQEAgICEgNfAi4KDAoFBAICAgQSA18CCgoMCgUE
AgICBhIDXwsfCgwKBQQCAgIBEgNfICkKDAoFBAICAgMSA18sLQoLCgQEAgID
EgNhAisKDAoFBAICAwQSA2ECCgoMCgUEAgIDBhIDYQsaCgwKBQQCAgMBEgNh
GyYKDAoFBAICAwMSA2EpKgoLCgQEAgIEEgNiAi0KDAoFBAICBAQSA2ICCgoM
CgUEAgIEBhIDYgseCgwKBQQCAgQBEgNiHygKDAoFBAICBAMSA2IrLAoMCgQE
AgMAEgRkAmcDCgwKBQQCAwABEgNkChgKDQoGBAIDAAIAEgNlBB0KDgoHBAID
AAIABBIDZQQMCg4KBwQCAwACAAUSA2UNEgoOCgcEAgMAAgABEgNlExgKDgoH
BAIDAAIAAxIDZRscCg0KBgQCAwACARIDZgQbCg4KBwQCAwACAQQSA2YEDAoO
CgcEAgMAAgEFEgNmDRIKDgoHBAIDAAIBARIDZhMWCg4KBwQCAwACAQMSA2YZ
GgoLCgQEAgIFEgNoAi4KDAoFBAICBQQSA2gCCgoMCgUEAgIFBhIDaAsZCgwK
BQQCAgUBEgNoGikKDAoFBAICBQMSA2gsLQoLCgQEAgIGEgNqAi8KDAoFBAIC
BgQSA2oCCgoMCgUEAgIGBhIDagsfCgwKBQQCAgYBEgNqICoKDAoFBAICBgMS
A2otLgoLCgQEAgIHEgNsAiYKDAoFBAICBwQSA2wCCgoMCgUEAgIHBhIDbAsZ
CgwKBQQCAgcBEgNsGiEKDAoFBAICBwMSA2wkJQqqAQoEBAIDARIEcQJ0Axqb
ASBSYW5nZSBvZiByZXNlcnZlZCB0YWcgbnVtYmVycy4gUmVzZXJ2ZWQgdGFn
IG51bWJlcnMgbWF5IG5vdCBiZSB1c2VkIGJ5CiBmaWVsZHMgb3IgZXh0ZW5z
aW9uIHJhbmdlcyBpbiB0aGUgc2FtZSBtZXNzYWdlLiBSZXNlcnZlZCByYW5n
ZXMgbWF5CiBub3Qgb3ZlcmxhcC4KCgwKBQQCAwEBEgNxChcKGwoGBAIDAQIA
EgNyBB0iDCBJbmNsdXNpdmUuCgoOCgcEAgMBAgAEEgNyBAwKDgoHBAIDAQIA
BRIDcg0SCg4KBwQCAwECAAESA3ITGAoOCgcEAgMBAgADEgNyGxwKGwoGBAID
AQIBEgNzBBsiDCBFeGNsdXNpdmUuCgoOCgcEAgMBAgEEEgNzBAwKDgoHBAID
AQIBBRIDcw0SCg4KBwQCAwECAQESA3MTFgoOCgcEAgMBAgEDEgNzGRoKCwoE
BAICCBIDdQIsCgwKBQQCAggEEgN1AgoKDAoFBAICCAYSA3ULGAoMCgUEAgII
ARIDdRknCgwKBQQCAggDEgN1KisKggEKBAQCAgkSA3gCJRp1IFJlc2VydmVk
IGZpZWxkIG5hbWVzLCB3aGljaCBtYXkgbm90IGJlIHVzZWQgYnkgZmllbGRz
IGluIHRoZSBzYW1lIG1lc3NhZ2UuCiBBIGdpdmVuIG5hbWUgbWF5IG9ubHkg
YmUgcmVzZXJ2ZWQgb25jZS4KCgwKBQQCAgkEEgN4AgoKDAoFBAICCQUSA3gL
EQoMCgUEAgIJARIDeBIfCgwKBQQCAgkDEgN4IiQKMgoCBAMSBXwAxwEBGiUg
RGVzY3JpYmVzIGEgZmllbGQgd2l0aGluIGEgbWVzc2FnZS4KCgoKAwQDARID
fAgcCg0KBAQDBAASBX0CmAEDCgwKBQQDBAABEgN9BwsKUwoGBAMEAAIAEgSA
AQQcGkMgMCBpcyByZXNlcnZlZCBmb3IgZXJyb3JzLgogT3JkZXIgaXMgd2Vp
cmQgZm9yIGhpc3RvcmljYWwgcmVhc29ucy4KCg8KBwQDBAACAAESBIABBA8K
DwoHBAMEAAIAAhIEgAEaGwoOCgYEAwQAAgESBIEBBBwKDwoHBAMEAAIBARIE
gQEEDgoPCgcEAwQAAgECEgSBARobCncKBgQDBAACAhIEhAEEHBpnIE5vdCBa
aWdaYWcgZW5jb2RlZC4gIE5lZ2F0aXZlIG51bWJlcnMgdGFrZSAxMCBieXRl
cy4gIFVzZSBUWVBFX1NJTlQ2NCBpZgogbmVnYXRpdmUgdmFsdWVzIGFyZSBs
aWtlbHkuCgoPCgcEAwQAAgIBEgSEAQQOCg8KBwQDBAACAgISBIQBGhsKDgoG
BAMEAAIDEgSFAQQcCg8KBwQDBAACAwESBIUBBA8KDwoHBAMEAAIDAhIEhQEa
Gwp3CgYEAwQAAgQSBIgBBBwaZyBOb3QgWmlnWmFnIGVuY29kZWQuICBOZWdh
dGl2ZSBudW1iZXJzIHRha2UgMTAgYnl0ZXMuICBVc2UgVFlQRV9TSU5UMzIg
aWYKIG5lZ2F0aXZlIHZhbHVlcyBhcmUgbGlrZWx5LgoKDwoHBAMEAAIEARIE
iAEEDgoPCgcEAwQAAgQCEgSIARobCg4KBgQDBAACBRIEiQEEHAoPCgcEAwQA
AgUBEgSJAQQQCg8KBwQDBAACBQISBIkBGhsKDgoGBAMEAAIGEgSKAQQcCg8K
BwQDBAACBgESBIoBBBAKDwoHBAMEAAIGAhIEigEaGwoOCgYEAwQAAgcSBIsB
BBwKDwoHBAMEAAIHARIEiwEEDQoPCgcEAwQAAgcCEgSLARobCg4KBgQDBAAC
CBIEjAEEHAoPCgcEAwQAAggBEgSMAQQPCg8KBwQDBAACCAISBIwBGhsKKgoG
BAMEAAIJEgSNAQQdIhogVGFnLWRlbGltaXRlZCBhZ2dyZWdhdGUuCgoPCgcE
AwQAAgkBEgSNAQQOCg8KBwQDBAACCQISBI0BGhwKLQoGBAMEAAIKEgSOAQQd
Ih0gTGVuZ3RoLWRlbGltaXRlZCBhZ2dyZWdhdGUuCgoPCgcEAwQAAgoBEgSO
AQQQCg8KBwQDBAACCgISBI4BGhwKIwoGBAMEAAILEgSRAQQdGhMgTmV3IGlu
IHZlcnNpb24gMi4KCg8KBwQDBAACCwESBJEBBA4KDwoHBAMEAAILAhIEkQEa
HAoOCgYEAwQAAgwSBJIBBB0KDwoHBAMEAAIMARIEkgEEDwoPCgcEAwQAAgwC
EgSSARocCg4KBgQDBAACDRIEkwEEHQoPCgcEAwQAAg0BEgSTAQQNCg8KBwQD
BAACDQISBJMBGhwKDgoGBAMEAAIOEgSUAQQdCg8KBwQDBAACDgESBJQBBBEK
DwoHBAMEAAIOAhIElAEaHAoOCgYEAwQAAg8SBJUBBB0KDwoHBAMEAAIPARIE
lQEEEQoPCgcEAwQAAg8CEgSVARocCicKBgQDBAACEBIElgEEHSIXIFVzZXMg
WmlnWmFnIGVuY29kaW5nLgoKDwoHBAMEAAIQARIElgEEDwoPCgcEAwQAAhAC
EgSWARocCicKBgQDBAACERIElwEEHSIXIFVzZXMgWmlnWmFnIGVuY29kaW5n
LgoKDwoHBAMEAAIRARIElwEEDwoPCgcEAwQAAhECEgSXARocCg4KBAQDBAES
BpoBAqABAwoNCgUEAwQBARIEmgEHDAoqCgYEAwQBAgASBJwBBBwaGiAwIGlz
IHJlc2VydmVkIGZvciBlcnJvcnMKCg8KBwQDBAECAAESBJwBBBIKDwoHBAME
AQIAAhIEnAEaGwoOCgYEAwQBAgESBJ0BBBwKDwoHBAMEAQIBARIEnQEEEgoP
CgcEAwQBAgECEgSdARobCjgKBgQDBAECAhIEngEEHCIoIFRPRE8oc2FuamF5
KTogU2hvdWxkIHdlIGFkZCBMQUJFTF9NQVA/CgoPCgcEAwQBAgIBEgSeAQQS
Cg8KBwQDBAECAgISBJ4BGhsKDAoEBAMCABIEogECGwoNCgUEAwIABBIEogEC
CgoNCgUEAwIABRIEogELEQoNCgUEAwIAARIEogESFgoNCgUEAwIAAxIEogEZ
GgoMCgQEAwIBEgSjAQIcCg0KBQQDAgEEEgSjAQIKCg0KBQQDAgEFEgSjAQsQ
Cg0KBQQDAgEBEgSjAREXCg0KBQQDAgEDEgSjARobCgwKBAQDAgISBKQBAhsK
DQoFBAMCAgQSBKQBAgoKDQoFBAMCAgYSBKQBCxAKDQoFBAMCAgESBKQBERYK
DQoFBAMCAgMSBKQBGRoKnAEKBAQDAgMSBKgBAhkajQEgSWYgdHlwZV9uYW1l
IGlzIHNldCwgdGhpcyBuZWVkIG5vdCBiZSBzZXQuICBJZiBib3RoIHRoaXMg
YW5kIHR5cGVfbmFtZQogYXJlIHNldCwgdGhpcyBtdXN0IGJlIG9uZSBvZiBU
WVBFX0VOVU0sIFRZUEVfTUVTU0FHRSBvciBUWVBFX0dST1VQLgoKDQoFBAMC
AwQSBKgBAgoKDQoFBAMCAwYSBKgBCw8KDQoFBAMCAwESBKgBEBQKDQoFBAMC
AwMSBKgBFxgKtwIKBAQDAgQSBK8BAiAaqAIgRm9yIG1lc3NhZ2UgYW5kIGVu
dW0gdHlwZXMsIHRoaXMgaXMgdGhlIG5hbWUgb2YgdGhlIHR5cGUuICBJZiB0
aGUgbmFtZQogc3RhcnRzIHdpdGggYSAnLicsIGl0IGlzIGZ1bGx5LXF1YWxp
ZmllZC4gIE90aGVyd2lzZSwgQysrLWxpa2Ugc2NvcGluZwogcnVsZXMgYXJl
IHVzZWQgdG8gZmluZCB0aGUgdHlwZSAoaS5lLiBmaXJzdCB0aGUgbmVzdGVk
IHR5cGVzIHdpdGhpbiB0aGlzCiBtZXNzYWdlIGFyZSBzZWFyY2hlZCwgdGhl
biB3aXRoaW4gdGhlIHBhcmVudCwgb24gdXAgdG8gdGhlIHJvb3QKIG5hbWVz
cGFjZSkuCgoNCgUEAwIEBBIErwECCgoNCgUEAwIEBRIErwELEQoNCgUEAwIE
ARIErwESGwoNCgUEAwIEAxIErwEeHwp+CgQEAwIFEgSzAQIfGnAgRm9yIGV4
dGVuc2lvbnMsIHRoaXMgaXMgdGhlIG5hbWUgb2YgdGhlIHR5cGUgYmVpbmcg
ZXh0ZW5kZWQuICBJdCBpcwogcmVzb2x2ZWQgaW4gdGhlIHNhbWUgbWFubmVy
IGFzIHR5cGVfbmFtZS4KCg0KBQQDAgUEEgSzAQIKCg0KBQQDAgUFEgSzAQsR
Cg0KBQQDAgUBEgSzARIaCg0KBQQDAgUDEgSzAR0eCrECCgQEAwIGEgS6AQIk
GqICIEZvciBudW1lcmljIHR5cGVzLCBjb250YWlucyB0aGUgb3JpZ2luYWwg
dGV4dCByZXByZXNlbnRhdGlvbiBvZiB0aGUgdmFsdWUuCiBGb3IgYm9vbGVh
bnMsICJ0cnVlIiBvciAiZmFsc2UiLgogRm9yIHN0cmluZ3MsIGNvbnRhaW5z
IHRoZSBkZWZhdWx0IHRleHQgY29udGVudHMgKG5vdCBlc2NhcGVkIGluIGFu
eSB3YXkpLgogRm9yIGJ5dGVzLCBjb250YWlucyB0aGUgQyBlc2NhcGVkIHZh
bHVlLiAgQWxsIGJ5dGVzID49IDEyOCBhcmUgZXNjYXBlZC4KIFRPRE8oa2Vu
dG9uKTogIEJhc2UtNjQgZW5jb2RlPwoKDQoFBAMCBgQSBLoBAgoKDQoFBAMC
BgUSBLoBCxEKDQoFBAMCBgESBLoBEh8KDQoFBAMCBgMSBLoBIiMKhAEKBAQD
AgcSBL4BAiEadiBJZiBzZXQsIGdpdmVzIHRoZSBpbmRleCBvZiBhIG9uZW9m
IGluIHRoZSBjb250YWluaW5nIHR5cGUncyBvbmVvZl9kZWNsCiBsaXN0LiAg
VGhpcyBmaWVsZCBpcyBhIG1lbWJlciBvZiB0aGF0IG9uZW9mLgoKDQoFBAMC
BwQSBL4BAgoKDQoFBAMCBwUSBL4BCxAKDQoFBAMCBwESBL4BERwKDQoFBAMC
BwMSBL4BHyAK+gEKBAQDAggSBMQBAiEa6wEgSlNPTiBuYW1lIG9mIHRoaXMg
ZmllbGQuIFRoZSB2YWx1ZSBpcyBzZXQgYnkgcHJvdG9jb2wgY29tcGlsZXIu
IElmIHRoZQogdXNlciBoYXMgc2V0IGEgImpzb25fbmFtZSIgb3B0aW9uIG9u
IHRoaXMgZmllbGQsIHRoYXQgb3B0aW9uJ3MgdmFsdWUKIHdpbGwgYmUgdXNl
ZC4gT3RoZXJ3aXNlLCBpdCdzIGRlZHVjZWQgZnJvbSB0aGUgZmllbGQncyBu
YW1lIGJ5IGNvbnZlcnRpbmcKIGl0IHRvIGNhbWVsQ2FzZS4KCg0KBQQDAggE
EgTEAQIKCg0KBQQDAggFEgTEAQsRCg0KBQQDAggBEgTEARIbCg0KBQQDAggD
EgTEAR4gCgwKBAQDAgkSBMYBAiQKDQoFBAMCCQQSBMYBAgoKDQoFBAMCCQYS
BMYBCxcKDQoFBAMCCQESBMYBGB8KDQoFBAMCCQMSBMYBIiMKIgoCBAQSBsoB
AMwBARoUIERlc2NyaWJlcyBhIG9uZW9mLgoKCwoDBAQBEgTKAQgcCgwKBAQE
AgASBMsBAhsKDQoFBAQCAAQSBMsBAgoKDQoFBAQCAAUSBMsBCxEKDQoFBAQC
AAESBMsBEhYKDQoFBAQCAAMSBMsBGRoKJwoCBAUSBs8BANUBARoZIERlc2Ny
aWJlcyBhbiBlbnVtIHR5cGUuCgoLCgMEBQESBM8BCBsKDAoEBAUCABIE0AEC
GwoNCgUEBQIABBIE0AECCgoNCgUEBQIABRIE0AELEQoNCgUEBQIAARIE0AES
FgoNCgUEBQIAAxIE0AEZGgoMCgQEBQIBEgTSAQIuCg0KBQQFAgEEEgTSAQIK
Cg0KBQQFAgEGEgTSAQsjCg0KBQQFAgEBEgTSASQpCg0KBQQFAgEDEgTSASwt
CgwKBAQFAgISBNQBAiMKDQoFBAUCAgQSBNQBAgoKDQoFBAUCAgYSBNQBCxYK
DQoFBAUCAgESBNQBFx4KDQoFBAUCAgMSBNQBISIKMQoCBAYSBtgBAN0BARoj
IERlc2NyaWJlcyBhIHZhbHVlIHdpdGhpbiBhbiBlbnVtLgoKCwoDBAYBEgTY
AQggCgwKBAQGAgASBNkBAhsKDQoFBAYCAAQSBNkBAgoKDQoFBAYCAAUSBNkB
CxEKDQoFBAYCAAESBNkBEhYKDQoFBAYCAAMSBNkBGRoKDAoEBAYCARIE2gEC
HAoNCgUEBgIBBBIE2gECCgoNCgUEBgIBBRIE2gELEAoNCgUEBgIBARIE2gER
FwoNCgUEBgIBAxIE2gEaGwoMCgQEBgICEgTcAQIoCg0KBQQGAgIEEgTcAQIK
Cg0KBQQGAgIGEgTcAQsbCg0KBQQGAgIBEgTcARwjCg0KBQQGAgIDEgTcASYn
CiQKAgQHEgbgAQDlAQEaFiBEZXNjcmliZXMgYSBzZXJ2aWNlLgoKCwoDBAcB
EgTgAQgeCgwKBAQHAgASBOEBAhsKDQoFBAcCAAQSBOEBAgoKDQoFBAcCAAUS
BOEBCxEKDQoFBAcCAAESBOEBEhYKDQoFBAcCAAMSBOEBGRoKDAoEBAcCARIE
4gECLAoNCgUEBwIBBBIE4gECCgoNCgUEBwIBBhIE4gELIAoNCgUEBwIBARIE
4gEhJwoNCgUEBwIBAxIE4gEqKwoMCgQEBwICEgTkAQImCg0KBQQHAgIEEgTk
AQIKCg0KBQQHAgIGEgTkAQsZCg0KBQQHAgIBEgTkARohCg0KBQQHAgIDEgTk
ASQlCjAKAgQIEgboAQD2AQEaIiBEZXNjcmliZXMgYSBtZXRob2Qgb2YgYSBz
ZXJ2aWNlLgoKCwoDBAgBEgToAQgdCgwKBAQIAgASBOkBAhsKDQoFBAgCAAQS
BOkBAgoKDQoFBAgCAAUSBOkBCxEKDQoFBAgCAAESBOkBEhYKDQoFBAgCAAMS
BOkBGRoKlwEKBAQIAgESBO0BAiEaiAEgSW5wdXQgYW5kIG91dHB1dCB0eXBl
IG5hbWVzLiAgVGhlc2UgYXJlIHJlc29sdmVkIGluIHRoZSBzYW1lIHdheSBh
cwogRmllbGREZXNjcmlwdG9yUHJvdG8udHlwZV9uYW1lLCBidXQgbXVzdCBy
ZWZlciB0byBhIG1lc3NhZ2UgdHlwZS4KCg0KBQQIAgEEEgTtAQIKCg0KBQQI
AgEFEgTtAQsRCg0KBQQIAgEBEgTtARIcCg0KBQQIAgEDEgTtAR8gCgwKBAQI
AgISBO4BAiIKDQoFBAgCAgQSBO4BAgoKDQoFBAgCAgUSBO4BCxEKDQoFBAgC
AgESBO4BEh0KDQoFBAgCAgMSBO4BICEKDAoEBAgCAxIE8AECJQoNCgUECAID
BBIE8AECCgoNCgUECAIDBhIE8AELGAoNCgUECAIDARIE8AEZIAoNCgUECAID
AxIE8AEjJApFCgQECAIEEgTzAQI1GjcgSWRlbnRpZmllcyBpZiBjbGllbnQg
c3RyZWFtcyBtdWx0aXBsZSBjbGllbnQgbWVzc2FnZXMKCg0KBQQIAgQEEgTz
AQIKCg0KBQQIAgQFEgTzAQsPCg0KBQQIAgQBEgTzARAgCg0KBQQIAgQDEgTz
ASMkCg0KBQQIAgQIEgTzASU0Cg0KBQQIAgQHEgTzAS4zCkUKBAQIAgUSBPUB
AjUaNyBJZGVudGlmaWVzIGlmIHNlcnZlciBzdHJlYW1zIG11bHRpcGxlIHNl
cnZlciBtZXNzYWdlcwoKDQoFBAgCBQQSBPUBAgoKDQoFBAgCBQUSBPUBCw8K
DQoFBAgCBQESBPUBECAKDQoFBAgCBQMSBPUBIyQKDQoFBAgCBQgSBPUBJTQK
DQoFBAgCBQcSBPUBLjMKrw4KAgQJEgaaAgCEAwEyTiA9PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09CiBPcHRpb25zCjLQDSBFYWNoIG9mIHRoZSBkZWZpbml0aW9u
cyBhYm92ZSBtYXkgaGF2ZSAib3B0aW9ucyIgYXR0YWNoZWQuICBUaGVzZSBh
cmUKIGp1c3QgYW5ub3RhdGlvbnMgd2hpY2ggbWF5IGNhdXNlIGNvZGUgdG8g
YmUgZ2VuZXJhdGVkIHNsaWdodGx5IGRpZmZlcmVudGx5CiBvciBtYXkgY29u
dGFpbiBoaW50cyBmb3IgY29kZSB0aGF0IG1hbmlwdWxhdGVzIHByb3RvY29s
IG1lc3NhZ2VzLgoKIENsaWVudHMgbWF5IGRlZmluZSBjdXN0b20gb3B0aW9u
cyBhcyBleHRlbnNpb25zIG9mIHRoZSAqT3B0aW9ucyBtZXNzYWdlcy4KIFRo
ZXNlIGV4dGVuc2lvbnMgbWF5IG5vdCB5ZXQgYmUga25vd24gYXQgcGFyc2lu
ZyB0aW1lLCBzbyB0aGUgcGFyc2VyIGNhbm5vdAogc3RvcmUgdGhlIHZhbHVl
cyBpbiB0aGVtLiAgSW5zdGVhZCBpdCBzdG9yZXMgdGhlbSBpbiBhIGZpZWxk
IGluIHRoZSAqT3B0aW9ucwogbWVzc2FnZSBjYWxsZWQgdW5pbnRlcnByZXRl
ZF9vcHRpb24uIFRoaXMgZmllbGQgbXVzdCBoYXZlIHRoZSBzYW1lIG5hbWUK
IGFjcm9zcyBhbGwgKk9wdGlvbnMgbWVzc2FnZXMuIFdlIHRoZW4gdXNlIHRo
aXMgZmllbGQgdG8gcG9wdWxhdGUgdGhlCiBleHRlbnNpb25zIHdoZW4gd2Ug
YnVpbGQgYSBkZXNjcmlwdG9yLCBhdCB3aGljaCBwb2ludCBhbGwgcHJvdG9z
IGhhdmUgYmVlbgogcGFyc2VkIGFuZCBzbyBhbGwgZXh0ZW5zaW9ucyBhcmUg
a25vd24uCgogRXh0ZW5zaW9uIG51bWJlcnMgZm9yIGN1c3RvbSBvcHRpb25z
IG1heSBiZSBjaG9zZW4gYXMgZm9sbG93czoKICogRm9yIG9wdGlvbnMgd2hp
Y2ggd2lsbCBvbmx5IGJlIHVzZWQgd2l0aGluIGEgc2luZ2xlIGFwcGxpY2F0
aW9uIG9yCiAgIG9yZ2FuaXphdGlvbiwgb3IgZm9yIGV4cGVyaW1lbnRhbCBv
cHRpb25zLCB1c2UgZmllbGQgbnVtYmVycyA1MDAwMAogICB0aHJvdWdoIDk5
OTk5LiAgSXQgaXMgdXAgdG8geW91IHRvIGVuc3VyZSB0aGF0IHlvdSBkbyBu
b3QgdXNlIHRoZQogICBzYW1lIG51bWJlciBmb3IgbXVsdGlwbGUgb3B0aW9u
cy4KICogRm9yIG9wdGlvbnMgd2hpY2ggd2lsbCBiZSBwdWJsaXNoZWQgYW5k
IHVzZWQgcHVibGljbHkgYnkgbXVsdGlwbGUKICAgaW5kZXBlbmRlbnQgZW50
aXRpZXMsIGUtbWFpbCBwcm90b2J1Zi1nbG9iYWwtZXh0ZW5zaW9uLXJlZ2lz
dHJ5QGdvb2dsZS5jb20KICAgdG8gcmVzZXJ2ZSBleHRlbnNpb24gbnVtYmVy
cy4gU2ltcGx5IHByb3ZpZGUgeW91ciBwcm9qZWN0IG5hbWUgKGUuZy4KICAg
T2JqZWN0aXZlLUMgcGx1Z2luKSBhbmQgeW91ciBwcm9qZWN0IHdlYnNpdGUg
KGlmIGF2YWlsYWJsZSkgLS0gdGhlcmUncyBubwogICBuZWVkIHRvIGV4cGxh
aW4gaG93IHlvdSBpbnRlbmQgdG8gdXNlIHRoZW0uIFVzdWFsbHkgeW91IG9u
bHkgbmVlZCBvbmUKICAgZXh0ZW5zaW9uIG51bWJlci4gWW91IGNhbiBkZWNs
YXJlIG11bHRpcGxlIG9wdGlvbnMgd2l0aCBvbmx5IG9uZSBleHRlbnNpb24K
ICAgbnVtYmVyIGJ5IHB1dHRpbmcgdGhlbSBpbiBhIHN1Yi1tZXNzYWdlLiBT
ZWUgdGhlIEN1c3RvbSBPcHRpb25zIHNlY3Rpb24gb2YKICAgdGhlIGRvY3Mg
Zm9yIGV4YW1wbGVzOgogICBodHRwczovL2RldmVsb3BlcnMuZ29vZ2xlLmNv
bS9wcm90b2NvbC1idWZmZXJzL2RvY3MvcHJvdG8jb3B0aW9ucwogICBJZiB0
aGlzIHR1cm5zIG91dCB0byBiZSBwb3B1bGFyLCBhIHdlYiBzZXJ2aWNlIHdp
bGwgYmUgc2V0IHVwCiAgIHRvIGF1dG9tYXRpY2FsbHkgYXNzaWduIG9wdGlv
biBudW1iZXJzLgoKCwoDBAkBEgSaAggTCvQBCgQECQIAEgSgAgIjGuUBIFNl
dHMgdGhlIEphdmEgcGFja2FnZSB3aGVyZSBjbGFzc2VzIGdlbmVyYXRlZCBm
cm9tIHRoaXMgLnByb3RvIHdpbGwgYmUKIHBsYWNlZC4gIEJ5IGRlZmF1bHQs
IHRoZSBwcm90byBwYWNrYWdlIGlzIHVzZWQsIGJ1dCB0aGlzIGlzIG9mdGVu
CiBpbmFwcHJvcHJpYXRlIGJlY2F1c2UgcHJvdG8gcGFja2FnZXMgZG8gbm90
IG5vcm1hbGx5IHN0YXJ0IHdpdGggYmFja3dhcmRzCiBkb21haW4gbmFtZXMu
CgoNCgUECQIABBIEoAICCgoNCgUECQIABRIEoAILEQoNCgUECQIAARIEoAIS
HgoNCgUECQIAAxIEoAIhIgq/AgoEBAkCARIEqAICKxqwAiBJZiBzZXQsIGFs
bCB0aGUgY2xhc3NlcyBmcm9tIHRoZSAucHJvdG8gZmlsZSBhcmUgd3JhcHBl
ZCBpbiBhIHNpbmdsZQogb3V0ZXIgY2xhc3Mgd2l0aCB0aGUgZ2l2ZW4gbmFt
ZS4gIFRoaXMgYXBwbGllcyB0byBib3RoIFByb3RvMQogKGVxdWl2YWxlbnQg
dG8gdGhlIG9sZCAiLS1vbmVfamF2YV9maWxlIiBvcHRpb24pIGFuZCBQcm90
bzIgKHdoZXJlCiBhIC5wcm90byBhbHdheXMgdHJhbnNsYXRlcyB0byBhIHNp
bmdsZSBjbGFzcywgYnV0IHlvdSBtYXkgd2FudCB0bwogZXhwbGljaXRseSBj
aG9vc2UgdGhlIGNsYXNzIG5hbWUpLgoKDQoFBAkCAQQSBKgCAgoKDQoFBAkC
AQUSBKgCCxEKDQoFBAkCAQESBKgCEiYKDQoFBAkCAQMSBKgCKSoKowMKBAQJ
AgISBLACAjkalAMgSWYgc2V0IHRydWUsIHRoZW4gdGhlIEphdmEgY29kZSBn
ZW5lcmF0b3Igd2lsbCBnZW5lcmF0ZSBhIHNlcGFyYXRlIC5qYXZhCiBmaWxl
IGZvciBlYWNoIHRvcC1sZXZlbCBtZXNzYWdlLCBlbnVtLCBhbmQgc2Vydmlj
ZSBkZWZpbmVkIGluIHRoZSAucHJvdG8KIGZpbGUuICBUaHVzLCB0aGVzZSB0
eXBlcyB3aWxsICpub3QqIGJlIG5lc3RlZCBpbnNpZGUgdGhlIG91dGVyIGNs
YXNzCiBuYW1lZCBieSBqYXZhX291dGVyX2NsYXNzbmFtZS4gIEhvd2V2ZXIs
IHRoZSBvdXRlciBjbGFzcyB3aWxsIHN0aWxsIGJlCiBnZW5lcmF0ZWQgdG8g
Y29udGFpbiB0aGUgZmlsZSdzIGdldERlc2NyaXB0b3IoKSBtZXRob2QgYXMg
d2VsbCBhcyBhbnkKIHRvcC1sZXZlbCBleHRlbnNpb25zIGRlZmluZWQgaW4g
dGhlIGZpbGUuCgoNCgUECQICBBIEsAICCgoNCgUECQICBRIEsAILDwoNCgUE
CQICARIEsAIQIwoNCgUECQICAxIEsAImKAoNCgUECQICCBIEsAIpOAoNCgUE
CQICBxIEsAIyNwqbBgoEBAkCAxIEvgICQxqMBiBJZiBzZXQgdHJ1ZSwgdGhl
biB0aGUgSmF2YSBjb2RlIGdlbmVyYXRvciB3aWxsIGdlbmVyYXRlIGVxdWFs
cygpIGFuZAogaGFzaENvZGUoKSBtZXRob2RzIGZvciBhbGwgbWVzc2FnZXMg
ZGVmaW5lZCBpbiB0aGUgLnByb3RvIGZpbGUuCiBUaGlzIGluY3JlYXNlcyBn
ZW5lcmF0ZWQgY29kZSBzaXplLCBwb3RlbnRpYWxseSBzdWJzdGFudGlhbGx5
IGZvciBsYXJnZQogcHJvdG9zLCB3aGljaCBtYXkgaGFybSBhIG1lbW9yeS1j
b25zdHJhaW5lZCBhcHBsaWNhdGlvbi4KIC0gSW4gdGhlIGZ1bGwgcnVudGlt
ZSB0aGlzIGlzIGEgc3BlZWQgb3B0aW1pemF0aW9uLCBhcyB0aGUKIEFic3Ry
YWN0TWVzc2FnZSBiYXNlIGNsYXNzIGluY2x1ZGVzIHJlZmxlY3Rpb24tYmFz
ZWQgaW1wbGVtZW50YXRpb25zIG9mCiB0aGVzZSBtZXRob2RzLgogLSBJbiB0
aGUgbGl0ZSBydW50aW1lLCBzZXR0aW5nIHRoaXMgb3B0aW9uIGNoYW5nZXMg
dGhlIHNlbWFudGljcyBvZgogZXF1YWxzKCkgYW5kIGhhc2hDb2RlKCkgdG8g
bW9yZSBjbG9zZWx5IG1hdGNoIHRob3NlIG9mIHRoZSBmdWxsIHJ1bnRpbWU7
CiB0aGUgZ2VuZXJhdGVkIG1ldGhvZHMgY29tcHV0ZSB0aGVpciByZXN1bHRz
IGJhc2VkIG9uIGZpZWxkIHZhbHVlcyByYXRoZXIKIHRoYW4gb2JqZWN0IGlk
ZW50aXR5LiAoSW1wbGVtZW50YXRpb25zIHNob3VsZCBub3QgYXNzdW1lIHRo
YXQgaGFzaGNvZGVzCiB3aWxsIGJlIGNvbnNpc3RlbnQgYWNyb3NzIHJ1bnRp
bWVzIG9yIHZlcnNpb25zIG9mIHRoZSBwcm90b2NvbCBjb21waWxlci4pCgoN
CgUECQIDBBIEvgICCgoNCgUECQIDBRIEvgILDwoNCgUECQIDARIEvgIQLQoN
CgUECQIDAxIEvgIwMgoNCgUECQIDCBIEvgIzQgoNCgUECQIDBxIEvgI8QQrm
AgoEBAkCBBIExgICPBrXAiBJZiBzZXQgdHJ1ZSwgdGhlbiB0aGUgSmF2YTIg
Y29kZSBnZW5lcmF0b3Igd2lsbCBnZW5lcmF0ZSBjb2RlIHRoYXQKIHRocm93
cyBhbiBleGNlcHRpb24gd2hlbmV2ZXIgYW4gYXR0ZW1wdCBpcyBtYWRlIHRv
IGFzc2lnbiBhIG5vbi1VVEYtOAogYnl0ZSBzZXF1ZW5jZSB0byBhIHN0cmlu
ZyBmaWVsZC4KIE1lc3NhZ2UgcmVmbGVjdGlvbiB3aWxsIGRvIHRoZSBzYW1l
LgogSG93ZXZlciwgYW4gZXh0ZW5zaW9uIGZpZWxkIHN0aWxsIGFjY2VwdHMg
bm9uLVVURi04IGJ5dGUgc2VxdWVuY2VzLgogVGhpcyBvcHRpb24gaGFzIG5v
IGVmZmVjdCBvbiB3aGVuIHVzZWQgd2l0aCB0aGUgbGl0ZSBydW50aW1lLgoK
DQoFBAkCBAQSBMYCAgoKDQoFBAkCBAUSBMYCCw8KDQoFBAkCBAESBMYCECYK
DQoFBAkCBAMSBMYCKSsKDQoFBAkCBAgSBMYCLDsKDQoFBAkCBAcSBMYCNToK
TAoEBAkEABIGygICzwIDGjwgR2VuZXJhdGVkIGNsYXNzZXMgY2FuIGJlIG9w
dGltaXplZCBmb3Igc3BlZWQgb3IgY29kZSBzaXplLgoKDQoFBAkEAAESBMoC
BxMKRAoGBAkEAAIAEgTLAgQOIjQgR2VuZXJhdGUgY29tcGxldGUgY29kZSBm
b3IgcGFyc2luZywgc2VyaWFsaXphdGlvbiwKCg8KBwQJBAACAAESBMsCBAkK
DwoHBAkEAAIAAhIEywIMDQpHCgYECQQAAgESBM0CBBIaBiBldGMuCiIvIFVz
ZSBSZWZsZWN0aW9uT3BzIHRvIGltcGxlbWVudCB0aGVzZSBtZXRob2RzLgoK
DwoHBAkEAAIBARIEzQIEDQoPCgcECQQAAgECEgTNAhARCkcKBgQJBAACAhIE
zgIEFSI3IEdlbmVyYXRlIGNvZGUgdXNpbmcgTWVzc2FnZUxpdGUgYW5kIHRo
ZSBsaXRlIHJ1bnRpbWUuCgoPCgcECQQAAgIBEgTOAgQQCg8KBwQJBAACAgIS
BM4CExQKDAoEBAkCBRIE0AICOQoNCgUECQIFBBIE0AICCgoNCgUECQIFBhIE
0AILFwoNCgUECQIFARIE0AIYJAoNCgUECQIFAxIE0AInKAoNCgUECQIFCBIE
0AIpOAoNCgUECQIFBxIE0AIyNwriAgoEBAkCBhIE1wICIhrTAiBTZXRzIHRo
ZSBHbyBwYWNrYWdlIHdoZXJlIHN0cnVjdHMgZ2VuZXJhdGVkIGZyb20gdGhp
cyAucHJvdG8gd2lsbCBiZQogcGxhY2VkLiBJZiBvbWl0dGVkLCB0aGUgR28g
cGFja2FnZSB3aWxsIGJlIGRlcml2ZWQgZnJvbSB0aGUgZm9sbG93aW5nOgog
ICAtIFRoZSBiYXNlbmFtZSBvZiB0aGUgcGFja2FnZSBpbXBvcnQgcGF0aCwg
aWYgcHJvdmlkZWQuCiAgIC0gT3RoZXJ3aXNlLCB0aGUgcGFja2FnZSBzdGF0
ZW1lbnQgaW4gdGhlIC5wcm90byBmaWxlLCBpZiBwcmVzZW50LgogICAtIE90
aGVyd2lzZSwgdGhlIGJhc2VuYW1lIG9mIHRoZSAucHJvdG8gZmlsZSwgd2l0
aG91dCBleHRlbnNpb24uCgoNCgUECQIGBBIE1wICCgoNCgUECQIGBRIE1wIL
EQoNCgUECQIGARIE1wISHAoNCgUECQIGAxIE1wIfIQrUBAoEBAkCBxIE5QIC
ORrFBCBTaG91bGQgZ2VuZXJpYyBzZXJ2aWNlcyBiZSBnZW5lcmF0ZWQgaW4g
ZWFjaCBsYW5ndWFnZT8gICJHZW5lcmljIiBzZXJ2aWNlcwogYXJlIG5vdCBz
cGVjaWZpYyB0byBhbnkgcGFydGljdWxhciBSUEMgc3lzdGVtLiAgVGhleSBh
cmUgZ2VuZXJhdGVkIGJ5IHRoZQogbWFpbiBjb2RlIGdlbmVyYXRvcnMgaW4g
ZWFjaCBsYW5ndWFnZSAod2l0aG91dCBhZGRpdGlvbmFsIHBsdWdpbnMpLgog
R2VuZXJpYyBzZXJ2aWNlcyB3ZXJlIHRoZSBvbmx5IGtpbmQgb2Ygc2Vydmlj
ZSBnZW5lcmF0aW9uIHN1cHBvcnRlZCBieQogZWFybHkgdmVyc2lvbnMgb2Yg
Z29vZ2xlLnByb3RvYnVmLgoKIEdlbmVyaWMgc2VydmljZXMgYXJlIG5vdyBj
b25zaWRlcmVkIGRlcHJlY2F0ZWQgaW4gZmF2b3Igb2YgdXNpbmcgcGx1Z2lu
cwogdGhhdCBnZW5lcmF0ZSBjb2RlIHNwZWNpZmljIHRvIHlvdXIgcGFydGlj
dWxhciBSUEMgc3lzdGVtLiAgVGhlcmVmb3JlLAogdGhlc2UgZGVmYXVsdCB0
byBmYWxzZS4gIE9sZCBjb2RlIHdoaWNoIGRlcGVuZHMgb24gZ2VuZXJpYyBz
ZXJ2aWNlcyBzaG91bGQKIGV4cGxpY2l0bHkgc2V0IHRoZW0gdG8gdHJ1ZS4K
Cg0KBQQJAgcEEgTlAgIKCg0KBQQJAgcFEgTlAgsPCg0KBQQJAgcBEgTlAhAj
Cg0KBQQJAgcDEgTlAiYoCg0KBQQJAgcIEgTlAik4Cg0KBQQJAgcHEgTlAjI3
CgwKBAQJAggSBOYCAjsKDQoFBAkCCAQSBOYCAgoKDQoFBAkCCAUSBOYCCw8K
DQoFBAkCCAESBOYCECUKDQoFBAkCCAMSBOYCKCoKDQoFBAkCCAgSBOYCKzoK
DQoFBAkCCAcSBOYCNDkKDAoEBAkCCRIE5wICOQoNCgUECQIJBBIE5wICCgoN
CgUECQIJBRIE5wILDwoNCgUECQIJARIE5wIQIwoNCgUECQIJAxIE5wImKAoN
CgUECQIJCBIE5wIpOAoNCgUECQIJBxIE5wIyNwrzAQoEBAkCChIE7QICMBrk
ASBJcyB0aGlzIGZpbGUgZGVwcmVjYXRlZD8KIERlcGVuZGluZyBvbiB0aGUg
dGFyZ2V0IHBsYXRmb3JtLCB0aGlzIGNhbiBlbWl0IERlcHJlY2F0ZWQgYW5u
b3RhdGlvbnMKIGZvciBldmVyeXRoaW5nIGluIHRoZSBmaWxlLCBvciBpdCB3
aWxsIGJlIGNvbXBsZXRlbHkgaWdub3JlZDsgaW4gdGhlIHZlcnkKIGxlYXN0
LCB0aGlzIGlzIGEgZm9ybWFsaXphdGlvbiBmb3IgZGVwcmVjYXRpbmcgZmls
ZXMuCgoNCgUECQIKBBIE7QICCgoNCgUECQIKBRIE7QILDwoNCgUECQIKARIE
7QIQGgoNCgUECQIKAxIE7QIdHwoNCgUECQIKCBIE7QIgLwoNCgUECQIKBxIE
7QIpLgp/CgQECQILEgTxAgI2GnEgRW5hYmxlcyB0aGUgdXNlIG9mIGFyZW5h
cyBmb3IgdGhlIHByb3RvIG1lc3NhZ2VzIGluIHRoaXMgZmlsZS4gVGhpcyBh
cHBsaWVzCiBvbmx5IHRvIGdlbmVyYXRlZCBjbGFzc2VzIGZvciBDKysuCgoN
CgUECQILBBIE8QICCgoNCgUECQILBRIE8QILDwoNCgUECQILARIE8QIQIAoN
CgUECQILAxIE8QIjJQoNCgUECQILCBIE8QImNQoNCgUECQILBxIE8QIvNAqS
AQoEBAkCDBIE9gICKRqDASBTZXRzIHRoZSBvYmplY3RpdmUgYyBjbGFzcyBw
cmVmaXggd2hpY2ggaXMgcHJlcGVuZGVkIHRvIGFsbCBvYmplY3RpdmUgYwog
Z2VuZXJhdGVkIGNsYXNzZXMgZnJvbSB0aGlzIC5wcm90by4gVGhlcmUgaXMg
bm8gZGVmYXVsdC4KCg0KBQQJAgwEEgT2AgIKCg0KBQQJAgwFEgT2AgsRCg0K
BQQJAgwBEgT2AhIjCg0KBQQJAgwDEgT2AiYoCkkKBAQJAg0SBPkCAigaOyBO
YW1lc3BhY2UgZm9yIGdlbmVyYXRlZCBjbGFzc2VzOyBkZWZhdWx0cyB0byB0
aGUgcGFja2FnZS4KCg0KBQQJAg0EEgT5AgIKCg0KBQQJAg0FEgT5AgsRCg0K
BQQJAg0BEgT5AhIiCg0KBQQJAg0DEgT5AiUnCm0KBAQJAg4SBP0CAjUaXyBX
aGV0aGVyIHRoZSBuYW5vIHByb3RvIGNvbXBpbGVyIHNob3VsZCBnZW5lcmF0
ZSBpbiB0aGUgZGVwcmVjYXRlZCBub24tbmFubwogc3VmZml4ZWQgcGFja2Fn
ZS4KCg0KBQQJAg4EEgT9AgIKCg0KBQQJAg4FEgT9AgsPCg0KBQQJAg4BEgT9
AhAvCg0KBQQJAg4DEgT9AjI0Ck8KBAQJAg8SBIADAjoaQSBUaGUgcGFyc2Vy
IHN0b3JlcyBvcHRpb25zIGl0IGRvZXNuJ3QgcmVjb2duaXplIGhlcmUuIFNl
ZSBhYm92ZS4KCg0KBQQJAg8EEgSAAwIKCg0KBQQJAg8GEgSAAwseCg0KBQQJ
Ag8BEgSAAx8zCg0KBQQJAg8DEgSAAzY5CloKAwQJBRIEgwMCGRpNIENsaWVu
dHMgY2FuIGRlZmluZSBjdXN0b20gb3B0aW9ucyBpbiBleHRlbnNpb25zIG9m
IHRoaXMgbWVzc2FnZS4gU2VlIGFib3ZlLgoKDAoEBAkFABIEgwMNGAoNCgUE
CQUAARIEgwMNEQoNCgUECQUAAhIEgwMVGAoMCgIEChIGhgMAwgMBCgsKAwQK
ARIEhgMIFgrYBQoEBAoCABIEmQMCPBrJBSBTZXQgdHJ1ZSB0byB1c2UgdGhl
IG9sZCBwcm90bzEgTWVzc2FnZVNldCB3aXJlIGZvcm1hdCBmb3IgZXh0ZW5z
aW9ucy4KIFRoaXMgaXMgcHJvdmlkZWQgZm9yIGJhY2t3YXJkcy1jb21wYXRp
YmlsaXR5IHdpdGggdGhlIE1lc3NhZ2VTZXQgd2lyZQogZm9ybWF0LiAgWW91
IHNob3VsZCBub3QgdXNlIHRoaXMgZm9yIGFueSBvdGhlciByZWFzb246ICBJ
dCdzIGxlc3MKIGVmZmljaWVudCwgaGFzIGZld2VyIGZlYXR1cmVzLCBhbmQg
aXMgbW9yZSBjb21wbGljYXRlZC4KCiBUaGUgbWVzc2FnZSBtdXN0IGJlIGRl
ZmluZWQgZXhhY3RseSBhcyBmb2xsb3dzOgogICBtZXNzYWdlIEZvbyB7CiAg
ICAgb3B0aW9uIG1lc3NhZ2Vfc2V0X3dpcmVfZm9ybWF0ID0gdHJ1ZTsKICAg
ICBleHRlbnNpb25zIDQgdG8gbWF4OwogICB9CiBOb3RlIHRoYXQgdGhlIG1l
c3NhZ2UgY2Fubm90IGhhdmUgYW55IGRlZmluZWQgZmllbGRzOyBNZXNzYWdl
U2V0cyBvbmx5CiBoYXZlIGV4dGVuc2lvbnMuCgogQWxsIGV4dGVuc2lvbnMg
b2YgeW91ciB0eXBlIG11c3QgYmUgc2luZ3VsYXIgbWVzc2FnZXM7IGUuZy4g
dGhleSBjYW5ub3QKIGJlIGludDMycywgZW51bXMsIG9yIHJlcGVhdGVkIG1l
c3NhZ2VzLgoKIEJlY2F1c2UgdGhpcyBpcyBhbiBvcHRpb24sIHRoZSBhYm92
ZSB0d28gcmVzdHJpY3Rpb25zIGFyZSBub3QgZW5mb3JjZWQgYnkKIHRoZSBw
cm90b2NvbCBjb21waWxlci4KCg0KBQQKAgAEEgSZAwIKCg0KBQQKAgAFEgSZ
AwsPCg0KBQQKAgABEgSZAxAnCg0KBQQKAgADEgSZAyorCg0KBQQKAgAIEgSZ
Ayw7Cg0KBQQKAgAHEgSZAzU6CusBCgQECgIBEgSeAwJEGtwBIERpc2FibGVz
IHRoZSBnZW5lcmF0aW9uIG9mIHRoZSBzdGFuZGFyZCAiZGVzY3JpcHRvcigp
IiBhY2Nlc3Nvciwgd2hpY2ggY2FuCiBjb25mbGljdCB3aXRoIGEgZmllbGQg
b2YgdGhlIHNhbWUgbmFtZS4gIFRoaXMgaXMgbWVhbnQgdG8gbWFrZSBtaWdy
YXRpb24KIGZyb20gcHJvdG8xIGVhc2llcjsgbmV3IGNvZGUgc2hvdWxkIGF2
b2lkIGZpZWxkcyBuYW1lZCAiZGVzY3JpcHRvciIuCgoNCgUECgIBBBIEngMC
CgoNCgUECgIBBRIEngMLDwoNCgUECgIBARIEngMQLwoNCgUECgIBAxIEngMy
MwoNCgUECgIBCBIEngM0QwoNCgUECgIBBxIEngM9QgruAQoEBAoCAhIEpAMC
LxrfASBJcyB0aGlzIG1lc3NhZ2UgZGVwcmVjYXRlZD8KIERlcGVuZGluZyBv
biB0aGUgdGFyZ2V0IHBsYXRmb3JtLCB0aGlzIGNhbiBlbWl0IERlcHJlY2F0
ZWQgYW5ub3RhdGlvbnMKIGZvciB0aGUgbWVzc2FnZSwgb3IgaXQgd2lsbCBi
ZSBjb21wbGV0ZWx5IGlnbm9yZWQ7IGluIHRoZSB2ZXJ5IGxlYXN0LAogdGhp
cyBpcyBhIGZvcm1hbGl6YXRpb24gZm9yIGRlcHJlY2F0aW5nIG1lc3NhZ2Vz
LgoKDQoFBAoCAgQSBKQDAgoKDQoFBAoCAgUSBKQDCw8KDQoFBAoCAgESBKQD
EBoKDQoFBAoCAgMSBKQDHR4KDQoFBAoCAggSBKQDHy4KDQoFBAoCAgcSBKQD
KC0KngYKBAQKAgMSBLsDAh4ajwYgV2hldGhlciB0aGUgbWVzc2FnZSBpcyBh
biBhdXRvbWF0aWNhbGx5IGdlbmVyYXRlZCBtYXAgZW50cnkgdHlwZSBmb3Ig
dGhlCiBtYXBzIGZpZWxkLgoKIEZvciBtYXBzIGZpZWxkczoKICAgICBtYXA8
S2V5VHlwZSwgVmFsdWVUeXBlPiBtYXBfZmllbGQgPSAxOwogVGhlIHBhcnNl
ZCBkZXNjcmlwdG9yIGxvb2tzIGxpa2U6CiAgICAgbWVzc2FnZSBNYXBGaWVs
ZEVudHJ5IHsKICAgICAgICAgb3B0aW9uIG1hcF9lbnRyeSA9IHRydWU7CiAg
ICAgICAgIG9wdGlvbmFsIEtleVR5cGUga2V5ID0gMTsKICAgICAgICAgb3B0
aW9uYWwgVmFsdWVUeXBlIHZhbHVlID0gMjsKICAgICB9CiAgICAgcmVwZWF0
ZWQgTWFwRmllbGRFbnRyeSBtYXBfZmllbGQgPSAxOwoKIEltcGxlbWVudGF0
aW9ucyBtYXkgY2hvb3NlIG5vdCB0byBnZW5lcmF0ZSB0aGUgbWFwX2VudHJ5
PXRydWUgbWVzc2FnZSwgYnV0CiB1c2UgYSBuYXRpdmUgbWFwIGluIHRoZSB0
YXJnZXQgbGFuZ3VhZ2UgdG8gaG9sZCB0aGUga2V5cyBhbmQgdmFsdWVzLgog
VGhlIHJlZmxlY3Rpb24gQVBJcyBpbiBzdWNoIGltcGxlbWVudGlvbnMgc3Rp
bGwgbmVlZCB0byB3b3JrIGFzCiBpZiB0aGUgZmllbGQgaXMgYSByZXBlYXRl
ZCBtZXNzYWdlIGZpZWxkLgoKIE5PVEU6IERvIG5vdCBzZXQgdGhlIG9wdGlv
biBpbiAucHJvdG8gZmlsZXMuIEFsd2F5cyB1c2UgdGhlIG1hcHMgc3ludGF4
CiBpbnN0ZWFkLiBUaGUgb3B0aW9uIHNob3VsZCBvbmx5IGJlIGltcGxpY2l0
bHkgc2V0IGJ5IHRoZSBwcm90byBjb21waWxlcgogcGFyc2VyLgoKDQoFBAoC
AwQSBLsDAgoKDQoFBAoCAwUSBLsDCw8KDQoFBAoCAwESBLsDEBkKDQoFBAoC
AwMSBLsDHB0KTwoEBAoCBBIEvgMCOhpBIFRoZSBwYXJzZXIgc3RvcmVzIG9w
dGlvbnMgaXQgZG9lc24ndCByZWNvZ25pemUgaGVyZS4gU2VlIGFib3ZlLgoK
DQoFBAoCBAQSBL4DAgoKDQoFBAoCBAYSBL4DCx4KDQoFBAoCBAESBL4DHzMK
DQoFBAoCBAMSBL4DNjkKWgoDBAoFEgTBAwIZGk0gQ2xpZW50cyBjYW4gZGVm
aW5lIGN1c3RvbSBvcHRpb25zIGluIGV4dGVuc2lvbnMgb2YgdGhpcyBtZXNz
YWdlLiBTZWUgYWJvdmUuCgoMCgQECgUAEgTBAw0YCg0KBQQKBQABEgTBAw0R
Cg0KBQQKBQACEgTBAxUYCgwKAgQLEgbEAwCcBAEKCwoDBAsBEgTEAwgUCqMC
CgQECwIAEgTJAwIuGpQCIFRoZSBjdHlwZSBvcHRpb24gaW5zdHJ1Y3RzIHRo
ZSBDKysgY29kZSBnZW5lcmF0b3IgdG8gdXNlIGEgZGlmZmVyZW50CiByZXBy
ZXNlbnRhdGlvbiBvZiB0aGUgZmllbGQgdGhhbiBpdCBub3JtYWxseSB3b3Vs
ZC4gIFNlZSB0aGUgc3BlY2lmaWMKIG9wdGlvbnMgYmVsb3cuICBUaGlzIG9w
dGlvbiBpcyBub3QgeWV0IGltcGxlbWVudGVkIGluIHRoZSBvcGVuIHNvdXJj
ZQogcmVsZWFzZSAtLSBzb3JyeSwgd2UnbGwgdHJ5IHRvIGluY2x1ZGUgaXQg
aW4gYSBmdXR1cmUgdmVyc2lvbiEKCg0KBQQLAgAEEgTJAwIKCg0KBQQLAgAG
EgTJAwsQCg0KBQQLAgABEgTJAxEWCg0KBQQLAgADEgTJAxkaCg0KBQQLAgAI
EgTJAxstCg0KBQQLAgAHEgTJAyYsCg4KBAQLBAASBsoDAtEDAwoNCgUECwQA
ARIEygMHDAofCgYECwQAAgASBMwDBA8aDyBEZWZhdWx0IG1vZGUuCgoPCgcE
CwQAAgABEgTMAwQKCg8KBwQLBAACAAISBMwDDQ4KDgoGBAsEAAIBEgTOAwQN
Cg8KBwQLBAACAQESBM4DBAgKDwoHBAsEAAIBAhIEzgMLDAoOCgYECwQAAgIS
BNADBBUKDwoHBAsEAAICARIE0AMEEAoPCgcECwQAAgICEgTQAxMUCtoCCgQE
CwIBEgTXAwIbGssCIFRoZSBwYWNrZWQgb3B0aW9uIGNhbiBiZSBlbmFibGVk
IGZvciByZXBlYXRlZCBwcmltaXRpdmUgZmllbGRzIHRvIGVuYWJsZQogYSBt
b3JlIGVmZmljaWVudCByZXByZXNlbnRhdGlvbiBvbiB0aGUgd2lyZS4gUmF0
aGVyIHRoYW4gcmVwZWF0ZWRseQogd3JpdGluZyB0aGUgdGFnIGFuZCB0eXBl
IGZvciBlYWNoIGVsZW1lbnQsIHRoZSBlbnRpcmUgYXJyYXkgaXMgZW5jb2Rl
ZCBhcwogYSBzaW5nbGUgbGVuZ3RoLWRlbGltaXRlZCBibG9iLiBJbiBwcm90
bzMsIG9ubHkgZXhwbGljaXQgc2V0dGluZyBpdCB0bwogZmFsc2Ugd2lsbCBh
dm9pZCB1c2luZyBwYWNrZWQgZW5jb2RpbmcuCgoNCgUECwIBBBIE1wMCCgoN
CgUECwIBBRIE1wMLDwoNCgUECwIBARIE1wMQFgoNCgUECwIBAxIE1wMZGgrk
BAoEBAsCAhIE4wMCMxrVBCBUaGUganN0eXBlIG9wdGlvbiBkZXRlcm1pbmVz
IHRoZSBKYXZhU2NyaXB0IHR5cGUgdXNlZCBmb3IgdmFsdWVzIG9mIHRoZQog
ZmllbGQuICBUaGUgb3B0aW9uIGlzIHBlcm1pdHRlZCBvbmx5IGZvciA2NCBi
aXQgaW50ZWdyYWwgYW5kIGZpeGVkIHR5cGVzCiAoaW50NjQsIHVpbnQ2NCwg
c2ludDY0LCBmaXhlZDY0LCBzZml4ZWQ2NCkuICBCeSBkZWZhdWx0IHRoZXNl
IHR5cGVzIGFyZQogcmVwcmVzZW50ZWQgYXMgSmF2YVNjcmlwdCBzdHJpbmdz
LiAgVGhpcyBhdm9pZHMgbG9zcyBvZiBwcmVjaXNpb24gdGhhdCBjYW4KIGhh
cHBlbiB3aGVuIGEgbGFyZ2UgdmFsdWUgaXMgY29udmVydGVkIHRvIGEgZmxv
YXRpbmcgcG9pbnQgSmF2YVNjcmlwdAogbnVtYmVycy4gIFNwZWNpZnlpbmcg
SlNfTlVNQkVSIGZvciB0aGUganN0eXBlIGNhdXNlcyB0aGUgZ2VuZXJhdGVk
CiBKYXZhU2NyaXB0IGNvZGUgdG8gdXNlIHRoZSBKYXZhU2NyaXB0ICJudW1i
ZXIiIHR5cGUgaW5zdGVhZCBvZiBzdHJpbmdzLgogVGhpcyBvcHRpb24gaXMg
YW4gZW51bSB0byBwZXJtaXQgYWRkaXRpb25hbCB0eXBlcyB0byBiZSBhZGRl
ZCwKIGUuZy4gZ29vZy5tYXRoLkludGVnZXIuCgoNCgUECwICBBIE4wMCCgoN
CgUECwICBhIE4wMLEQoNCgUECwICARIE4wMSGAoNCgUECwICAxIE4wMbHAoN
CgUECwICCBIE4wMdMgoNCgUECwICBxIE4wMoMQoOCgQECwQBEgbkAwLtAwMK
DQoFBAsEAQESBOQDBw0KJwoGBAsEAQIAEgTmAwQSGhcgVXNlIHRoZSBkZWZh
dWx0IHR5cGUuCgoPCgcECwQBAgABEgTmAwQNCg8KBwQLBAECAAISBOYDEBEK
KQoGBAsEAQIBEgTpAwQSGhkgVXNlIEphdmFTY3JpcHQgc3RyaW5ncy4KCg8K
BwQLBAECAQESBOkDBA0KDwoHBAsEAQIBAhIE6QMQEQopCgYECwQBAgISBOwD
BBIaGSBVc2UgSmF2YVNjcmlwdCBudW1iZXJzLgoKDwoHBAsEAQICARIE7AME
DQoPCgcECwQBAgICEgTsAxARCvAMCgQECwIDEgSLBAIpGuEMIFNob3VsZCB0
aGlzIGZpZWxkIGJlIHBhcnNlZCBsYXppbHk/ICBMYXp5IGFwcGxpZXMgb25s
eSB0byBtZXNzYWdlLXR5cGUKIGZpZWxkcy4gIEl0IG1lYW5zIHRoYXQgd2hl
biB0aGUgb3V0ZXIgbWVzc2FnZSBpcyBpbml0aWFsbHkgcGFyc2VkLCB0aGUK
IGlubmVyIG1lc3NhZ2UncyBjb250ZW50cyB3aWxsIG5vdCBiZSBwYXJzZWQg
YnV0IGluc3RlYWQgc3RvcmVkIGluIGVuY29kZWQKIGZvcm0uICBUaGUgaW5u
ZXIgbWVzc2FnZSB3aWxsIGFjdHVhbGx5IGJlIHBhcnNlZCB3aGVuIGl0IGlz
IGZpcnN0IGFjY2Vzc2VkLgoKIFRoaXMgaXMgb25seSBhIGhpbnQuICBJbXBs
ZW1lbnRhdGlvbnMgYXJlIGZyZWUgdG8gY2hvb3NlIHdoZXRoZXIgdG8gdXNl
CiBlYWdlciBvciBsYXp5IHBhcnNpbmcgcmVnYXJkbGVzcyBvZiB0aGUgdmFs
dWUgb2YgdGhpcyBvcHRpb24uICBIb3dldmVyLAogc2V0dGluZyB0aGlzIG9w
dGlvbiB0cnVlIHN1Z2dlc3RzIHRoYXQgdGhlIHByb3RvY29sIGF1dGhvciBi
ZWxpZXZlcyB0aGF0CiB1c2luZyBsYXp5IHBhcnNpbmcgb24gdGhpcyBmaWVs
ZCBpcyB3b3J0aCB0aGUgYWRkaXRpb25hbCBib29ra2VlcGluZwogb3Zlcmhl
YWQgdHlwaWNhbGx5IG5lZWRlZCB0byBpbXBsZW1lbnQgaXQuCgogVGhpcyBv
cHRpb24gZG9lcyBub3QgYWZmZWN0IHRoZSBwdWJsaWMgaW50ZXJmYWNlIG9m
IGFueSBnZW5lcmF0ZWQgY29kZTsKIGFsbCBtZXRob2Qgc2lnbmF0dXJlcyBy
ZW1haW4gdGhlIHNhbWUuICBGdXJ0aGVybW9yZSwgdGhyZWFkLXNhZmV0eSBv
ZiB0aGUKIGludGVyZmFjZSBpcyBub3QgYWZmZWN0ZWQgYnkgdGhpcyBvcHRp
b247IGNvbnN0IG1ldGhvZHMgcmVtYWluIHNhZmUgdG8KIGNhbGwgZnJvbSBt
dWx0aXBsZSB0aHJlYWRzIGNvbmN1cnJlbnRseSwgd2hpbGUgbm9uLWNvbnN0
IG1ldGhvZHMgY29udGludWUKIHRvIHJlcXVpcmUgZXhjbHVzaXZlIGFjY2Vz
cy4KCgogTm90ZSB0aGF0IGltcGxlbWVudGF0aW9ucyBtYXkgY2hvb3NlIG5v
dCB0byBjaGVjayByZXF1aXJlZCBmaWVsZHMgd2l0aGluCiBhIGxhenkgc3Vi
LW1lc3NhZ2UuICBUaGF0IGlzLCBjYWxsaW5nIElzSW5pdGlhbGl6ZWQoKSBv
biB0aGUgb3V0aGVyIG1lc3NhZ2UKIG1heSByZXR1cm4gdHJ1ZSBldmVuIGlm
IHRoZSBpbm5lciBtZXNzYWdlIGhhcyBtaXNzaW5nIHJlcXVpcmVkIGZpZWxk
cy4KIFRoaXMgaXMgbmVjZXNzYXJ5IGJlY2F1c2Ugb3RoZXJ3aXNlIHRoZSBp
bm5lciBtZXNzYWdlIHdvdWxkIGhhdmUgdG8gYmUKIHBhcnNlZCBpbiBvcmRl
ciB0byBwZXJmb3JtIHRoZSBjaGVjaywgZGVmZWF0aW5nIHRoZSBwdXJwb3Nl
IG9mIGxhenkKIHBhcnNpbmcuICBBbiBpbXBsZW1lbnRhdGlvbiB3aGljaCBj
aG9vc2VzIG5vdCB0byBjaGVjayByZXF1aXJlZCBmaWVsZHMKIG11c3QgYmUg
Y29uc2lzdGVudCBhYm91dCBpdC4gIFRoYXQgaXMsIGZvciBhbnkgcGFydGlj
dWxhciBzdWItbWVzc2FnZSwgdGhlCiBpbXBsZW1lbnRhdGlvbiBtdXN0IGVp
dGhlciAqYWx3YXlzKiBjaGVjayBpdHMgcmVxdWlyZWQgZmllbGRzLCBvciAq
bmV2ZXIqCiBjaGVjayBpdHMgcmVxdWlyZWQgZmllbGRzLCByZWdhcmRsZXNz
IG9mIHdoZXRoZXIgb3Igbm90IHRoZSBtZXNzYWdlIGhhcwogYmVlbiBwYXJz
ZWQuCgoNCgUECwIDBBIEiwQCCgoNCgUECwIDBRIEiwQLDwoNCgUECwIDARIE
iwQQFAoNCgUECwIDAxIEiwQXGAoNCgUECwIDCBIEiwQZKAoNCgUECwIDBxIE
iwQiJwroAQoEBAsCBBIEkQQCLxrZASBJcyB0aGlzIGZpZWxkIGRlcHJlY2F0
ZWQ/CiBEZXBlbmRpbmcgb24gdGhlIHRhcmdldCBwbGF0Zm9ybSwgdGhpcyBj
YW4gZW1pdCBEZXByZWNhdGVkIGFubm90YXRpb25zCiBmb3IgYWNjZXNzb3Jz
LCBvciBpdCB3aWxsIGJlIGNvbXBsZXRlbHkgaWdub3JlZDsgaW4gdGhlIHZl
cnkgbGVhc3QsIHRoaXMKIGlzIGEgZm9ybWFsaXphdGlvbiBmb3IgZGVwcmVj
YXRpbmcgZmllbGRzLgoKDQoFBAsCBAQSBJEEAgoKDQoFBAsCBAUSBJEECw8K
DQoFBAsCBAESBJEEEBoKDQoFBAsCBAMSBJEEHR4KDQoFBAsCBAgSBJEEHy4K
DQoFBAsCBAcSBJEEKC0KPwoEBAsCBRIElAQCKhoxIEZvciBHb29nbGUtaW50
ZXJuYWwgbWlncmF0aW9uIG9ubHkuIERvIG5vdCB1c2UuCgoNCgUECwIFBBIE
lAQCCgoNCgUECwIFBRIElAQLDwoNCgUECwIFARIElAQQFAoNCgUECwIFAxIE
lAQXGQoNCgUECwIFCBIElAQaKQoNCgUECwIFBxIElAQjKApPCgQECwIGEgSY
BAI6GkEgVGhlIHBhcnNlciBzdG9yZXMgb3B0aW9ucyBpdCBkb2Vzbid0IHJl
Y29nbml6ZSBoZXJlLiBTZWUgYWJvdmUuCgoNCgUECwIGBBIEmAQCCgoNCgUE
CwIGBhIEmAQLHgoNCgUECwIGARIEmAQfMwoNCgUECwIGAxIEmAQ2OQpaCgME
CwUSBJsEAhkaTSBDbGllbnRzIGNhbiBkZWZpbmUgY3VzdG9tIG9wdGlvbnMg
aW4gZXh0ZW5zaW9ucyBvZiB0aGlzIG1lc3NhZ2UuIFNlZSBhYm92ZS4KCgwK
BAQLBQASBJsEDRgKDQoFBAsFAAESBJsEDREKDQoFBAsFAAISBJsEFRgKDAoC
BAwSBp4EAK8EAQoLCgMEDAESBJ4ECBMKYAoEBAwCABIEogQCIBpSIFNldCB0
aGlzIG9wdGlvbiB0byB0cnVlIHRvIGFsbG93IG1hcHBpbmcgZGlmZmVyZW50
IHRhZyBuYW1lcyB0byB0aGUgc2FtZQogdmFsdWUuCgoNCgUEDAIABBIEogQC
CgoNCgUEDAIABRIEogQLDwoNCgUEDAIAARIEogQQGwoNCgUEDAIAAxIEogQe
HwrlAQoEBAwCARIEqAQCLxrWASBJcyB0aGlzIGVudW0gZGVwcmVjYXRlZD8K
IERlcGVuZGluZyBvbiB0aGUgdGFyZ2V0IHBsYXRmb3JtLCB0aGlzIGNhbiBl
bWl0IERlcHJlY2F0ZWQgYW5ub3RhdGlvbnMKIGZvciB0aGUgZW51bSwgb3Ig
aXQgd2lsbCBiZSBjb21wbGV0ZWx5IGlnbm9yZWQ7IGluIHRoZSB2ZXJ5IGxl
YXN0LCB0aGlzCiBpcyBhIGZvcm1hbGl6YXRpb24gZm9yIGRlcHJlY2F0aW5n
IGVudW1zLgoKDQoFBAwCAQQSBKgEAgoKDQoFBAwCAQUSBKgECw8KDQoFBAwC
AQESBKgEEBoKDQoFBAwCAQMSBKgEHR4KDQoFBAwCAQgSBKgEHy4KDQoFBAwC
AQcSBKgEKC0KTwoEBAwCAhIEqwQCOhpBIFRoZSBwYXJzZXIgc3RvcmVzIG9w
dGlvbnMgaXQgZG9lc24ndCByZWNvZ25pemUgaGVyZS4gU2VlIGFib3ZlLgoK
DQoFBAwCAgQSBKsEAgoKDQoFBAwCAgYSBKsECx4KDQoFBAwCAgESBKsEHzMK
DQoFBAwCAgMSBKsENjkKWgoDBAwFEgSuBAIZGk0gQ2xpZW50cyBjYW4gZGVm
aW5lIGN1c3RvbSBvcHRpb25zIGluIGV4dGVuc2lvbnMgb2YgdGhpcyBtZXNz
YWdlLiBTZWUgYWJvdmUuCgoMCgQEDAUAEgSuBA0YCg0KBQQMBQABEgSuBA0R
Cg0KBQQMBQACEgSuBBUYCgwKAgQNEgaxBAC9BAEKCwoDBA0BEgSxBAgYCvcB
CgQEDQIAEgS2BAIvGugBIElzIHRoaXMgZW51bSB2YWx1ZSBkZXByZWNhdGVk
PwogRGVwZW5kaW5nIG9uIHRoZSB0YXJnZXQgcGxhdGZvcm0sIHRoaXMgY2Fu
IGVtaXQgRGVwcmVjYXRlZCBhbm5vdGF0aW9ucwogZm9yIHRoZSBlbnVtIHZh
bHVlLCBvciBpdCB3aWxsIGJlIGNvbXBsZXRlbHkgaWdub3JlZDsgaW4gdGhl
IHZlcnkgbGVhc3QsCiB0aGlzIGlzIGEgZm9ybWFsaXphdGlvbiBmb3IgZGVw
cmVjYXRpbmcgZW51bSB2YWx1ZXMuCgoNCgUEDQIABBIEtgQCCgoNCgUEDQIA
BRIEtgQLDwoNCgUEDQIAARIEtgQQGgoNCgUEDQIAAxIEtgQdHgoNCgUEDQIA
CBIEtgQfLgoNCgUEDQIABxIEtgQoLQpPCgQEDQIBEgS5BAI6GkEgVGhlIHBh
cnNlciBzdG9yZXMgb3B0aW9ucyBpdCBkb2Vzbid0IHJlY29nbml6ZSBoZXJl
LiBTZWUgYWJvdmUuCgoNCgUEDQIBBBIEuQQCCgoNCgUEDQIBBhIEuQQLHgoN
CgUEDQIBARIEuQQfMwoNCgUEDQIBAxIEuQQ2OQpaCgMEDQUSBLwEAhkaTSBD
bGllbnRzIGNhbiBkZWZpbmUgY3VzdG9tIG9wdGlvbnMgaW4gZXh0ZW5zaW9u
cyBvZiB0aGlzIG1lc3NhZ2UuIFNlZSBhYm92ZS4KCgwKBAQNBQASBLwEDRgK
DQoFBA0FAAESBLwEDREKDQoFBA0FAAISBLwEFRgKDAoCBA4SBr8EANEEAQoL
CgMEDgESBL8ECBYK2QMKBAQOAgASBMoEAjAa3wEgSXMgdGhpcyBzZXJ2aWNl
IGRlcHJlY2F0ZWQ/CiBEZXBlbmRpbmcgb24gdGhlIHRhcmdldCBwbGF0Zm9y
bSwgdGhpcyBjYW4gZW1pdCBEZXByZWNhdGVkIGFubm90YXRpb25zCiBmb3Ig
dGhlIHNlcnZpY2UsIG9yIGl0IHdpbGwgYmUgY29tcGxldGVseSBpZ25vcmVk
OyBpbiB0aGUgdmVyeSBsZWFzdCwKIHRoaXMgaXMgYSBmb3JtYWxpemF0aW9u
IGZvciBkZXByZWNhdGluZyBzZXJ2aWNlcy4KMugBIE5vdGU6ICBGaWVsZCBu
dW1iZXJzIDEgdGhyb3VnaCAzMiBhcmUgcmVzZXJ2ZWQgZm9yIEdvb2dsZSdz
IGludGVybmFsIFJQQwogICBmcmFtZXdvcmsuICBXZSBhcG9sb2dpemUgZm9y
IGhvYXJkaW5nIHRoZXNlIG51bWJlcnMgdG8gb3Vyc2VsdmVzLCBidXQKICAg
d2Ugd2VyZSBhbHJlYWR5IHVzaW5nIHRoZW0gbG9uZyBiZWZvcmUgd2UgZGVj
aWRlZCB0byByZWxlYXNlIFByb3RvY29sCiAgIEJ1ZmZlcnMuCgoNCgUEDgIA
BBIEygQCCgoNCgUEDgIABRIEygQLDwoNCgUEDgIAARIEygQQGgoNCgUEDgIA
AxIEygQdHwoNCgUEDgIACBIEygQgLwoNCgUEDgIABxIEygQpLgpPCgQEDgIB
EgTNBAI6GkEgVGhlIHBhcnNlciBzdG9yZXMgb3B0aW9ucyBpdCBkb2Vzbid0
IHJlY29nbml6ZSBoZXJlLiBTZWUgYWJvdmUuCgoNCgUEDgIBBBIEzQQCCgoN
CgUEDgIBBhIEzQQLHgoNCgUEDgIBARIEzQQfMwoNCgUEDgIBAxIEzQQ2OQpa
CgMEDgUSBNAEAhkaTSBDbGllbnRzIGNhbiBkZWZpbmUgY3VzdG9tIG9wdGlv
bnMgaW4gZXh0ZW5zaW9ucyBvZiB0aGlzIG1lc3NhZ2UuIFNlZSBhYm92ZS4K
CgwKBAQOBQASBNAEDRgKDQoFBA4FAAESBNAEDREKDQoFBA4FAAISBNAEFRgK
DAoCBA8SBtMEAOUEAQoLCgMEDwESBNMECBUK1gMKBAQPAgASBN4EAjAa3AEg
SXMgdGhpcyBtZXRob2QgZGVwcmVjYXRlZD8KIERlcGVuZGluZyBvbiB0aGUg
dGFyZ2V0IHBsYXRmb3JtLCB0aGlzIGNhbiBlbWl0IERlcHJlY2F0ZWQgYW5u
b3RhdGlvbnMKIGZvciB0aGUgbWV0aG9kLCBvciBpdCB3aWxsIGJlIGNvbXBs
ZXRlbHkgaWdub3JlZDsgaW4gdGhlIHZlcnkgbGVhc3QsCiB0aGlzIGlzIGEg
Zm9ybWFsaXphdGlvbiBmb3IgZGVwcmVjYXRpbmcgbWV0aG9kcy4KMugBIE5v
dGU6ICBGaWVsZCBudW1iZXJzIDEgdGhyb3VnaCAzMiBhcmUgcmVzZXJ2ZWQg
Zm9yIEdvb2dsZSdzIGludGVybmFsIFJQQwogICBmcmFtZXdvcmsuICBXZSBh
cG9sb2dpemUgZm9yIGhvYXJkaW5nIHRoZXNlIG51bWJlcnMgdG8gb3Vyc2Vs
dmVzLCBidXQKICAgd2Ugd2VyZSBhbHJlYWR5IHVzaW5nIHRoZW0gbG9uZyBi
ZWZvcmUgd2UgZGVjaWRlZCB0byByZWxlYXNlIFByb3RvY29sCiAgIEJ1ZmZl
cnMuCgoNCgUEDwIABBIE3gQCCgoNCgUEDwIABRIE3gQLDwoNCgUEDwIAARIE
3gQQGgoNCgUEDwIAAxIE3gQdHwoNCgUEDwIACBIE3gQgLwoNCgUEDwIABxIE
3gQpLgpPCgQEDwIBEgThBAI6GkEgVGhlIHBhcnNlciBzdG9yZXMgb3B0aW9u
cyBpdCBkb2Vzbid0IHJlY29nbml6ZSBoZXJlLiBTZWUgYWJvdmUuCgoNCgUE
DwIBBBIE4QQCCgoNCgUEDwIBBhIE4QQLHgoNCgUEDwIBARIE4QQfMwoNCgUE
DwIBAxIE4QQ2OQpaCgMEDwUSBOQEAhkaTSBDbGllbnRzIGNhbiBkZWZpbmUg
Y3VzdG9tIG9wdGlvbnMgaW4gZXh0ZW5zaW9ucyBvZiB0aGlzIG1lc3NhZ2Uu
IFNlZSBhYm92ZS4KCgwKBAQPBQASBOQEDRgKDQoFBA8FAAESBOQEDREKDQoF
BA8FAAISBOQEFRgKiwMKAgQQEgbuBACCBQEa/AIgQSBtZXNzYWdlIHJlcHJl
c2VudGluZyBhIG9wdGlvbiB0aGUgcGFyc2VyIGRvZXMgbm90IHJlY29nbml6
ZS4gVGhpcyBvbmx5CiBhcHBlYXJzIGluIG9wdGlvbnMgcHJvdG9zIGNyZWF0
ZWQgYnkgdGhlIGNvbXBpbGVyOjpQYXJzZXIgY2xhc3MuCiBEZXNjcmlwdG9y
UG9vbCByZXNvbHZlcyB0aGVzZSB3aGVuIGJ1aWxkaW5nIERlc2NyaXB0b3Ig
b2JqZWN0cy4gVGhlcmVmb3JlLAogb3B0aW9ucyBwcm90b3MgaW4gZGVzY3Jp
cHRvciBvYmplY3RzIChlLmcuIHJldHVybmVkIGJ5IERlc2NyaXB0b3I6Om9w
dGlvbnMoKSwKIG9yIHByb2R1Y2VkIGJ5IERlc2NyaXB0b3I6OkNvcHlUbygp
KSB3aWxsIG5ldmVyIGhhdmUgVW5pbnRlcnByZXRlZE9wdGlvbnMKIGluIHRo
ZW0uCgoLCgMEEAESBO4ECBsKywIKBAQQAwASBvQEAvcEAxq6AiBUaGUgbmFt
ZSBvZiB0aGUgdW5pbnRlcnByZXRlZCBvcHRpb24uICBFYWNoIHN0cmluZyBy
ZXByZXNlbnRzIGEgc2VnbWVudCBpbgogYSBkb3Qtc2VwYXJhdGVkIG5hbWUu
ICBpc19leHRlbnNpb24gaXMgdHJ1ZSBpZmYgYSBzZWdtZW50IHJlcHJlc2Vu
dHMgYW4KIGV4dGVuc2lvbiAoZGVub3RlZCB3aXRoIHBhcmVudGhlc2VzIGlu
IG9wdGlvbnMgc3BlY3MgaW4gLnByb3RvIGZpbGVzKS4KIEUuZy4seyBbImZv
byIsIGZhbHNlXSwgWyJiYXIuYmF6IiwgdHJ1ZV0sIFsicXV4IiwgZmFsc2Vd
IH0gcmVwcmVzZW50cwogImZvby4oYmFyLmJheikucXV4Ii4KCg0KBQQQAwAB
EgT0BAoSCg4KBgQQAwACABIE9QQEIgoPCgcEEAMAAgAEEgT1BAQMCg8KBwQQ
AwACAAUSBPUEDRMKDwoHBBADAAIAARIE9QQUHQoPCgcEEAMAAgADEgT1BCAh
Cg4KBgQQAwACARIE9gQEIwoPCgcEEAMAAgEEEgT2BAQMCg8KBwQQAwACAQUS
BPYEDREKDwoHBBADAAIBARIE9gQSHgoPCgcEEAMAAgEDEgT2BCEiCgwKBAQQ
AgASBPgEAh0KDQoFBBACAAQSBPgEAgoKDQoFBBACAAYSBPgECxMKDQoFBBAC
AAESBPgEFBgKDQoFBBACAAMSBPgEGxwKnAEKBAQQAgESBPwEAicajQEgVGhl
IHZhbHVlIG9mIHRoZSB1bmludGVycHJldGVkIG9wdGlvbiwgaW4gd2hhdGV2
ZXIgdHlwZSB0aGUgdG9rZW5pemVyCiBpZGVudGlmaWVkIGl0IGFzIGR1cmlu
ZyBwYXJzaW5nLiBFeGFjdGx5IG9uZSBvZiB0aGVzZSBzaG91bGQgYmUgc2V0
LgoKDQoFBBACAQQSBPwEAgoKDQoFBBACAQUSBPwECxEKDQoFBBACAQESBPwE
EiIKDQoFBBACAQMSBPwEJSYKDAoEBBACAhIE/QQCKQoNCgUEEAICBBIE/QQC
CgoNCgUEEAICBRIE/QQLEQoNCgUEEAICARIE/QQSJAoNCgUEEAICAxIE/QQn
KAoMCgQEEAIDEgT+BAIoCg0KBQQQAgMEEgT+BAIKCg0KBQQQAgMFEgT+BAsQ
Cg0KBQQQAgMBEgT+BBEjCg0KBQQQAgMDEgT+BCYnCgwKBAQQAgQSBP8EAiMK
DQoFBBACBAQSBP8EAgoKDQoFBBACBAUSBP8ECxEKDQoFBBACBAESBP8EEh4K
DQoFBBACBAMSBP8EISIKDAoEBBACBRIEgAUCIgoNCgUEEAIFBBIEgAUCCgoN
CgUEEAIFBRIEgAULEAoNCgUEEAIFARIEgAURHQoNCgUEEAIFAxIEgAUgIQoM
CgQEEAIGEgSBBQImCg0KBQQQAgYEEgSBBQIKCg0KBQQQAgYFEgSBBQsRCg0K
BQQQAgYBEgSBBRIhCg0KBQQQAgYDEgSBBSQlCtoBCgIEERIGiQUAigYBGmog
RW5jYXBzdWxhdGVzIGluZm9ybWF0aW9uIGFib3V0IHRoZSBvcmlnaW5hbCBz
b3VyY2UgZmlsZSBmcm9tIHdoaWNoIGEKIEZpbGVEZXNjcmlwdG9yUHJvdG8g
d2FzIGdlbmVyYXRlZC4KMmAgPT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PQogT3B0
aW9uYWwgc291cmNlIGNvZGUgaW5mbwoKCwoDBBEBEgSJBQgWCoIRCgQEEQIA
EgS1BQIhGvMQIEEgTG9jYXRpb24gaWRlbnRpZmllcyBhIHBpZWNlIG9mIHNv
dXJjZSBjb2RlIGluIGEgLnByb3RvIGZpbGUgd2hpY2gKIGNvcnJlc3BvbmRz
IHRvIGEgcGFydGljdWxhciBkZWZpbml0aW9uLiAgVGhpcyBpbmZvcm1hdGlv
biBpcyBpbnRlbmRlZAogdG8gYmUgdXNlZnVsIHRvIElERXMsIGNvZGUgaW5k
ZXhlcnMsIGRvY3VtZW50YXRpb24gZ2VuZXJhdG9ycywgYW5kIHNpbWlsYXIK
IHRvb2xzLgoKIEZvciBleGFtcGxlLCBzYXkgd2UgaGF2ZSBhIGZpbGUgbGlr
ZToKICAgbWVzc2FnZSBGb28gewogICAgIG9wdGlvbmFsIHN0cmluZyBmb28g
PSAxOwogICB9CiBMZXQncyBsb29rIGF0IGp1c3QgdGhlIGZpZWxkIGRlZmlu
aXRpb246CiAgIG9wdGlvbmFsIHN0cmluZyBmb28gPSAxOwogICBeICAgICAg
IF5eICAgICBeXiAgXiAgXl5eCiAgIGEgICAgICAgYmMgICAgIGRlICBmICBn
aGkKIFdlIGhhdmUgdGhlIGZvbGxvd2luZyBsb2NhdGlvbnM6CiAgIHNwYW4g
ICBwYXRoICAgICAgICAgICAgICAgcmVwcmVzZW50cwogICBbYSxpKSAgWyA0
LCAwLCAyLCAwIF0gICAgIFRoZSB3aG9sZSBmaWVsZCBkZWZpbml0aW9uLgog
ICBbYSxiKSAgWyA0LCAwLCAyLCAwLCA0IF0gIFRoZSBsYWJlbCAob3B0aW9u
YWwpLgogICBbYyxkKSAgWyA0LCAwLCAyLCAwLCA1IF0gIFRoZSB0eXBlIChz
dHJpbmcpLgogICBbZSxmKSAgWyA0LCAwLCAyLCAwLCAxIF0gIFRoZSBuYW1l
IChmb28pLgogICBbZyxoKSAgWyA0LCAwLCAyLCAwLCAzIF0gIFRoZSBudW1i
ZXIgKDEpLgoKIE5vdGVzOgogLSBBIGxvY2F0aW9uIG1heSByZWZlciB0byBh
IHJlcGVhdGVkIGZpZWxkIGl0c2VsZiAoaS5lLiBub3QgdG8gYW55CiAgIHBh
cnRpY3VsYXIgaW5kZXggd2l0aGluIGl0KS4gIFRoaXMgaXMgdXNlZCB3aGVu
ZXZlciBhIHNldCBvZiBlbGVtZW50cyBhcmUKICAgbG9naWNhbGx5IGVuY2xv
c2VkIGluIGEgc2luZ2xlIGNvZGUgc2VnbWVudC4gIEZvciBleGFtcGxlLCBh
biBlbnRpcmUKICAgZXh0ZW5kIGJsb2NrIChwb3NzaWJseSBjb250YWluaW5n
IG11bHRpcGxlIGV4dGVuc2lvbiBkZWZpbml0aW9ucykgd2lsbAogICBoYXZl
IGFuIG91dGVyIGxvY2F0aW9uIHdob3NlIHBhdGggcmVmZXJzIHRvIHRoZSAi
ZXh0ZW5zaW9ucyIgcmVwZWF0ZWQKICAgZmllbGQgd2l0aG91dCBhbiBpbmRl
eC4KIC0gTXVsdGlwbGUgbG9jYXRpb25zIG1heSBoYXZlIHRoZSBzYW1lIHBh
dGguICBUaGlzIGhhcHBlbnMgd2hlbiBhIHNpbmdsZQogICBsb2dpY2FsIGRl
Y2xhcmF0aW9uIGlzIHNwcmVhZCBvdXQgYWNyb3NzIG11bHRpcGxlIHBsYWNl
cy4gIFRoZSBtb3N0CiAgIG9idmlvdXMgZXhhbXBsZSBpcyB0aGUgImV4dGVu
ZCIgYmxvY2sgYWdhaW4gLS0gdGhlcmUgbWF5IGJlIG11bHRpcGxlCiAgIGV4
dGVuZCBibG9ja3MgaW4gdGhlIHNhbWUgc2NvcGUsIGVhY2ggb2Ygd2hpY2gg
d2lsbCBoYXZlIHRoZSBzYW1lIHBhdGguCiAtIEEgbG9jYXRpb24ncyBzcGFu
IGlzIG5vdCBhbHdheXMgYSBzdWJzZXQgb2YgaXRzIHBhcmVudCdzIHNwYW4u
ICBGb3IKICAgZXhhbXBsZSwgdGhlICJleHRlbmRlZSIgb2YgYW4gZXh0ZW5z
aW9uIGRlY2xhcmF0aW9uIGFwcGVhcnMgYXQgdGhlCiAgIGJlZ2lubmluZyBv
ZiB0aGUgImV4dGVuZCIgYmxvY2sgYW5kIGlzIHNoYXJlZCBieSBhbGwgZXh0
ZW5zaW9ucyB3aXRoaW4KICAgdGhlIGJsb2NrLgogLSBKdXN0IGJlY2F1c2Ug
YSBsb2NhdGlvbidzIHNwYW4gaXMgYSBzdWJzZXQgb2Ygc29tZSBvdGhlciBs
b2NhdGlvbidzIHNwYW4KICAgZG9lcyBub3QgbWVhbiB0aGF0IGl0IGlzIGEg
ZGVzY2VuZGVudC4gIEZvciBleGFtcGxlLCBhICJncm91cCIgZGVmaW5lcwog
ICBib3RoIGEgdHlwZSBhbmQgYSBmaWVsZCBpbiBhIHNpbmdsZSBkZWNsYXJh
dGlvbi4gIFRodXMsIHRoZSBsb2NhdGlvbnMKICAgY29ycmVzcG9uZGluZyB0
byB0aGUgdHlwZSBhbmQgZmllbGQgYW5kIHRoZWlyIGNvbXBvbmVudHMgd2ls
bCBvdmVybGFwLgogLSBDb2RlIHdoaWNoIHRyaWVzIHRvIGludGVycHJldCBs
b2NhdGlvbnMgc2hvdWxkIHByb2JhYmx5IGJlIGRlc2lnbmVkIHRvCiAgIGln
bm9yZSB0aG9zZSB0aGF0IGl0IGRvZXNuJ3QgdW5kZXJzdGFuZCwgYXMgbW9y
ZSB0eXBlcyBvZiBsb2NhdGlvbnMgY291bGQKICAgYmUgcmVjb3JkZWQgaW4g
dGhlIGZ1dHVyZS4KCg0KBQQRAgAEEgS1BQIKCg0KBQQRAgAGEgS1BQsTCg0K
BQQRAgABEgS1BRQcCg0KBQQRAgADEgS1BR8gCg4KBAQRAwASBrYFAokGAwoN
CgUEEQMAARIEtgUKEgqDBwoGBBEDAAIAEgTOBQQqGvIGIElkZW50aWZpZXMg
d2hpY2ggcGFydCBvZiB0aGUgRmlsZURlc2NyaXB0b3JQcm90byB3YXMgZGVm
aW5lZCBhdCB0aGlzCiBsb2NhdGlvbi4KCiBFYWNoIGVsZW1lbnQgaXMgYSBm
aWVsZCBudW1iZXIgb3IgYW4gaW5kZXguICBUaGV5IGZvcm0gYSBwYXRoIGZy
b20KIHRoZSByb290IEZpbGVEZXNjcmlwdG9yUHJvdG8gdG8gdGhlIHBsYWNl
IHdoZXJlIHRoZSBkZWZpbml0aW9uLiAgRm9yCiBleGFtcGxlLCB0aGlzIHBh
dGg6CiAgIFsgNCwgMywgMiwgNywgMSBdCiByZWZlcnMgdG86CiAgIGZpbGUu
bWVzc2FnZV90eXBlKDMpICAvLyA0LCAzCiAgICAgICAuZmllbGQoNykgICAg
ICAgICAvLyAyLCA3CiAgICAgICAubmFtZSgpICAgICAgICAgICAvLyAxCiBU
aGlzIGlzIGJlY2F1c2UgRmlsZURlc2NyaXB0b3JQcm90by5tZXNzYWdlX3R5
cGUgaGFzIGZpZWxkIG51bWJlciA0OgogICByZXBlYXRlZCBEZXNjcmlwdG9y
UHJvdG8gbWVzc2FnZV90eXBlID0gNDsKIGFuZCBEZXNjcmlwdG9yUHJvdG8u
ZmllbGQgaGFzIGZpZWxkIG51bWJlciAyOgogICByZXBlYXRlZCBGaWVsZERl
c2NyaXB0b3JQcm90byBmaWVsZCA9IDI7CiBhbmQgRmllbGREZXNjcmlwdG9y
UHJvdG8ubmFtZSBoYXMgZmllbGQgbnVtYmVyIDE6CiAgIG9wdGlvbmFsIHN0
cmluZyBuYW1lID0gMTsKCiBUaHVzLCB0aGUgYWJvdmUgcGF0aCBnaXZlcyB0
aGUgbG9jYXRpb24gb2YgYSBmaWVsZCBuYW1lLiAgSWYgd2UgcmVtb3ZlZAog
dGhlIGxhc3QgZWxlbWVudDoKICAgWyA0LCAzLCAyLCA3IF0KIHRoaXMgcGF0
aCByZWZlcnMgdG8gdGhlIHdob2xlIGZpZWxkIGRlY2xhcmF0aW9uIChmcm9t
IHRoZSBiZWdpbm5pbmcKIG9mIHRoZSBsYWJlbCB0byB0aGUgdGVybWluYXRp
bmcgc2VtaWNvbG9uKS4KCg8KBwQRAwACAAQSBM4FBAwKDwoHBBEDAAIABRIE
zgUNEgoPCgcEEQMAAgABEgTOBRMXCg8KBwQRAwACAAMSBM4FGhsKDwoHBBED
AAIACBIEzgUcKQoQCggEEQMAAgAIAhIEzgUdKArSAgoGBBEDAAIBEgTVBQQq
GsECIEFsd2F5cyBoYXMgZXhhY3RseSB0aHJlZSBvciBmb3VyIGVsZW1lbnRz
OiBzdGFydCBsaW5lLCBzdGFydCBjb2x1bW4sCiBlbmQgbGluZSAob3B0aW9u
YWwsIG90aGVyd2lzZSBhc3N1bWVkIHNhbWUgYXMgc3RhcnQgbGluZSksIGVu
ZCBjb2x1bW4uCiBUaGVzZSBhcmUgcGFja2VkIGludG8gYSBzaW5nbGUgZmll
bGQgZm9yIGVmZmljaWVuY3kuICBOb3RlIHRoYXQgbGluZQogYW5kIGNvbHVt
biBudW1iZXJzIGFyZSB6ZXJvLWJhc2VkIC0tIHR5cGljYWxseSB5b3Ugd2ls
bCB3YW50IHRvIGFkZAogMSB0byBlYWNoIGJlZm9yZSBkaXNwbGF5aW5nIHRv
IGEgdXNlci4KCg8KBwQRAwACAQQSBNUFBAwKDwoHBBEDAAIBBRIE1QUNEgoP
CgcEEQMAAgEBEgTVBRMXCg8KBwQRAwACAQMSBNUFGhsKDwoHBBEDAAIBCBIE
1QUcKQoQCggEEQMAAgEIAhIE1QUdKAqlDAoGBBEDAAICEgSGBgQpGpQMIElm
IHRoaXMgU291cmNlQ29kZUluZm8gcmVwcmVzZW50cyBhIGNvbXBsZXRlIGRl
Y2xhcmF0aW9uLCB0aGVzZSBhcmUgYW55CiBjb21tZW50cyBhcHBlYXJpbmcg
YmVmb3JlIGFuZCBhZnRlciB0aGUgZGVjbGFyYXRpb24gd2hpY2ggYXBwZWFy
IHRvIGJlCiBhdHRhY2hlZCB0byB0aGUgZGVjbGFyYXRpb24uCgogQSBzZXJp
ZXMgb2YgbGluZSBjb21tZW50cyBhcHBlYXJpbmcgb24gY29uc2VjdXRpdmUg
bGluZXMsIHdpdGggbm8gb3RoZXIKIHRva2VucyBhcHBlYXJpbmcgb24gdGhv
c2UgbGluZXMsIHdpbGwgYmUgdHJlYXRlZCBhcyBhIHNpbmdsZSBjb21tZW50
LgoKIGxlYWRpbmdfZGV0YWNoZWRfY29tbWVudHMgd2lsbCBrZWVwIHBhcmFn
cmFwaHMgb2YgY29tbWVudHMgdGhhdCBhcHBlYXIKIGJlZm9yZSAoYnV0IG5v
dCBjb25uZWN0ZWQgdG8pIHRoZSBjdXJyZW50IGVsZW1lbnQuIEVhY2ggcGFy
YWdyYXBoLAogc2VwYXJhdGVkIGJ5IGVtcHR5IGxpbmVzLCB3aWxsIGJlIG9u
ZSBjb21tZW50IGVsZW1lbnQgaW4gdGhlIHJlcGVhdGVkCiBmaWVsZC4KCiBP
bmx5IHRoZSBjb21tZW50IGNvbnRlbnQgaXMgcHJvdmlkZWQ7IGNvbW1lbnQg
bWFya2VycyAoZS5nLiAvLykgYXJlCiBzdHJpcHBlZCBvdXQuICBGb3IgYmxv
Y2sgY29tbWVudHMsIGxlYWRpbmcgd2hpdGVzcGFjZSBhbmQgYW4gYXN0ZXJp
c2sKIHdpbGwgYmUgc3RyaXBwZWQgZnJvbSB0aGUgYmVnaW5uaW5nIG9mIGVh
Y2ggbGluZSBvdGhlciB0aGFuIHRoZSBmaXJzdC4KIE5ld2xpbmVzIGFyZSBp
bmNsdWRlZCBpbiB0aGUgb3V0cHV0LgoKIEV4YW1wbGVzOgoKICAgb3B0aW9u
YWwgaW50MzIgZm9vID0gMTsgIC8vIENvbW1lbnQgYXR0YWNoZWQgdG8gZm9v
LgogICAvLyBDb21tZW50IGF0dGFjaGVkIHRvIGJhci4KICAgb3B0aW9uYWwg
aW50MzIgYmFyID0gMjsKCiAgIG9wdGlvbmFsIHN0cmluZyBiYXogPSAzOwog
ICAvLyBDb21tZW50IGF0dGFjaGVkIHRvIGJhei4KICAgLy8gQW5vdGhlciBs
aW5lIGF0dGFjaGVkIHRvIGJhei4KCiAgIC8vIENvbW1lbnQgYXR0YWNoZWQg
dG8gcXV4LgogICAvLwogICAvLyBBbm90aGVyIGxpbmUgYXR0YWNoZWQgdG8g
cXV4LgogICBvcHRpb25hbCBkb3VibGUgcXV4ID0gNDsKCiAgIC8vIERldGFj
aGVkIGNvbW1lbnQgZm9yIGNvcmdlLiBUaGlzIGlzIG5vdCBsZWFkaW5nIG9y
IHRyYWlsaW5nIGNvbW1lbnRzCiAgIC8vIHRvIHF1eCBvciBjb3JnZSBiZWNh
dXNlIHRoZXJlIGFyZSBibGFuayBsaW5lcyBzZXBhcmF0aW5nIGl0IGZyb20K
ICAgLy8gYm90aC4KCiAgIC8vIERldGFjaGVkIGNvbW1lbnQgZm9yIGNvcmdl
IHBhcmFncmFwaCAyLgoKICAgb3B0aW9uYWwgc3RyaW5nIGNvcmdlID0gNTsK
ICAgLyogQmxvY2sgY29tbWVudCBhdHRhY2hlZAogICAgKiB0byBjb3JnZS4g
IExlYWRpbmcgYXN0ZXJpc2tzCiAgICAqIHdpbGwgYmUgcmVtb3ZlZC4gKi8K
ICAgLyogQmxvY2sgY29tbWVudCBhdHRhY2hlZCB0bwogICAgKiBncmF1bHQu
ICovCiAgIG9wdGlvbmFsIGludDMyIGdyYXVsdCA9IDY7CgogICAvLyBpZ25v
cmVkIGRldGFjaGVkIGNvbW1lbnRzLgoKDwoHBBEDAAICBBIEhgYEDAoPCgcE
EQMAAgIFEgSGBg0TCg8KBwQRAwACAgESBIYGFCQKDwoHBBEDAAICAxIEhgYn
KAoOCgYEEQMAAgMSBIcGBCoKDwoHBBEDAAIDBBIEhwYEDAoPCgcEEQMAAgMF
EgSHBg0TCg8KBwQRAwACAwESBIcGFCUKDwoHBBEDAAIDAxIEhwYoKQoOCgYE
EQMAAgQSBIgGBDIKDwoHBBEDAAIEBBIEiAYEDAoPCgcEEQMAAgQFEgSIBg0T
Cg8KBwQRAwACBAESBIgGFC0KDwoHBBEDAAIEAxIEiAYwMQ==
