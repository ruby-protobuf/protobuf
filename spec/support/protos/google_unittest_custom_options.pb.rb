# encoding: utf-8
# frozen_string_literal: true

##
# This file is auto-generated. DO NOT EDIT!
#
require 'base64'
require 'set'
require 'protobuf'
require 'protobuf/rpc/service'


##
# Imports
#
require 'google/protobuf/descriptor.pb'

module Protobuf_unittest
  FULLY_QUALIFIED_NAME = 'protobuf_unittest' unless defined?(self::FULLY_QUALIFIED_NAME)

  @descriptors = [] unless instance_variable_defined?(:@descriptors)
  @descriptors << lambda do
    bytes = File.read(__FILE__, mode: 'rb').split(/^__END__$/, 2).last
    ::Google::Protobuf::FileDescriptorProto.decode(Base64.decode64(bytes))
  end

  @descriptor_dependencies = Set.new unless instance_variable_defined?(:@descriptor_dependencies)
  @descriptor_dependencies |= [Google::Protobuf]

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
  # Enum Classes
  #
  class MethodOpt1 < ::Protobuf::Enum
    FULLY_QUALIFIED_NAME = FULLY_QUALIFIED_NAME + '.MethodOpt1'

    define :METHODOPT1_VAL1, 1
    define :METHODOPT1_VAL2, 2
  end

  class AggregateEnum < ::Protobuf::Enum
    FULLY_QUALIFIED_NAME = FULLY_QUALIFIED_NAME + '.AggregateEnum'

    set_option :".protobuf_unittest.enumopt", { :s => "EnumAnnotation" }

    define :VALUE, 1
  end


  ##
  # Message Classes
  #
  class TestMessageWithCustomOptions < ::Protobuf::Message
    class AnEnum < ::Protobuf::Enum
      FULLY_QUALIFIED_NAME = FULLY_QUALIFIED_NAME + '.AnEnum'

      set_option :".protobuf_unittest.enum_opt1", -789

      define :ANENUM_VAL1, 1
      define :ANENUM_VAL2, 2
    end

  end

  class CustomOptionFooRequest < ::Protobuf::Message; end
  class CustomOptionFooResponse < ::Protobuf::Message; end
  class CustomOptionFooClientMessage < ::Protobuf::Message; end
  class CustomOptionFooServerMessage < ::Protobuf::Message; end
  class DummyMessageContainingEnum < ::Protobuf::Message
    class TestEnumType < ::Protobuf::Enum
      FULLY_QUALIFIED_NAME = FULLY_QUALIFIED_NAME + '.TestEnumType'

      define :TEST_OPTION_ENUM_TYPE1, 22
      define :TEST_OPTION_ENUM_TYPE2, -23
    end

  end

  class DummyMessageInvalidAsOptionType < ::Protobuf::Message; end
  class CustomOptionMinIntegerValues < ::Protobuf::Message; end
  class CustomOptionMaxIntegerValues < ::Protobuf::Message; end
  class CustomOptionOtherValues < ::Protobuf::Message; end
  class SettingRealsFromPositiveInts < ::Protobuf::Message; end
  class SettingRealsFromNegativeInts < ::Protobuf::Message; end
  class ComplexOptionType1 < ::Protobuf::Message; end
  class ComplexOptionType2 < ::Protobuf::Message
    class ComplexOptionType4 < ::Protobuf::Message; end

  end

  class ComplexOptionType3 < ::Protobuf::Message; end
  class VariousComplexOptions < ::Protobuf::Message; end
  class AggregateMessageSet < ::Protobuf::Message; end
  class AggregateMessageSetElement < ::Protobuf::Message; end
  class Aggregate < ::Protobuf::Message; end
  class AggregateMessage < ::Protobuf::Message; end
  class NestedOptionType < ::Protobuf::Message
    class NestedEnum < ::Protobuf::Enum
      FULLY_QUALIFIED_NAME = FULLY_QUALIFIED_NAME + '.NestedEnum'

      set_option :".protobuf_unittest.enum_opt1", 1003

      define :NESTED_ENUM_VALUE, 1
    end

    class NestedMessage < ::Protobuf::Message; end

  end

  class OldOptionType < ::Protobuf::Message
    class TestEnum < ::Protobuf::Enum
      FULLY_QUALIFIED_NAME = FULLY_QUALIFIED_NAME + '.TestEnum'

      define :OLD_VALUE, 0
    end

  end

  class NewOptionType < ::Protobuf::Message
    class TestEnum < ::Protobuf::Enum
      FULLY_QUALIFIED_NAME = FULLY_QUALIFIED_NAME + '.TestEnum'

      define :OLD_VALUE, 0
      define :NEW_VALUE, 1
    end

  end

  class TestMessageWithRequiredEnumOption < ::Protobuf::Message; end


  ##
  # File Options
  #
  set_option :cc_generic_services, true
  set_option :java_generic_services, true
  set_option :py_generic_services, true
  set_option :".protobuf_unittest.file_opt1", 9876543210
  set_option :".protobuf_unittest.fileopt", { :i => 100, :s => "FileAnnotation", :sub => { :s => "NestedFileAnnotation" }, :file => { :".protobuf_unittest.fileopt" => { :s => "FileExtensionAnnotation" } }, :mset => { :".protobuf_unittest.AggregateMessageSetElement.message_set_extension" => { :s => "EmbeddedMessageSetElement" } } }


  ##
  # Message Fields
  #
  class TestMessageWithCustomOptions
    FULLY_QUALIFIED_NAME = FULLY_QUALIFIED_NAME + '.TestMessageWithCustomOptions'
    # Message Options
    set_option :message_set_wire_format, false
    set_option :".protobuf_unittest.message_opt1", -56

    optional :string, :field1, 1, :ctype => ::Google::Protobuf::FieldOptions::CType::CORD, :".protobuf_unittest.field_opt1" => 8765432109
  end

  class CustomOptionMinIntegerValues
    FULLY_QUALIFIED_NAME = FULLY_QUALIFIED_NAME + '.CustomOptionMinIntegerValues'
    # Message Options
    set_option :".protobuf_unittest.sfixed64_opt", -9223372036854775808
    set_option :".protobuf_unittest.sfixed32_opt", -2147483648
    set_option :".protobuf_unittest.fixed64_opt", 0
    set_option :".protobuf_unittest.fixed32_opt", 0
    set_option :".protobuf_unittest.sint64_opt", -9223372036854775808
    set_option :".protobuf_unittest.sint32_opt", -2147483648
    set_option :".protobuf_unittest.uint64_opt", 0
    set_option :".protobuf_unittest.uint32_opt", 0
    set_option :".protobuf_unittest.int64_opt", -9223372036854775808
    set_option :".protobuf_unittest.int32_opt", -2147483648
    set_option :".protobuf_unittest.bool_opt", false

  end

  class CustomOptionMaxIntegerValues
    FULLY_QUALIFIED_NAME = FULLY_QUALIFIED_NAME + '.CustomOptionMaxIntegerValues'
    # Message Options
    set_option :".protobuf_unittest.sfixed64_opt", 9223372036854775807
    set_option :".protobuf_unittest.sfixed32_opt", 2147483647
    set_option :".protobuf_unittest.fixed64_opt", 18446744073709551615
    set_option :".protobuf_unittest.fixed32_opt", 4294967295
    set_option :".protobuf_unittest.sint64_opt", 9223372036854775807
    set_option :".protobuf_unittest.sint32_opt", 2147483647
    set_option :".protobuf_unittest.uint64_opt", 18446744073709551615
    set_option :".protobuf_unittest.uint32_opt", 4294967295
    set_option :".protobuf_unittest.int64_opt", 9223372036854775807
    set_option :".protobuf_unittest.int32_opt", 2147483647
    set_option :".protobuf_unittest.bool_opt", true

  end

  class CustomOptionOtherValues
    FULLY_QUALIFIED_NAME = FULLY_QUALIFIED_NAME + '.CustomOptionOtherValues'
    # Message Options
    set_option :".protobuf_unittest.enum_opt", ::Protobuf_unittest::DummyMessageContainingEnum::TestEnumType::TEST_OPTION_ENUM_TYPE2
    set_option :".protobuf_unittest.bytes_opt", "Hello\x00World"
    set_option :".protobuf_unittest.string_opt", "Hello, \"World\""
    set_option :".protobuf_unittest.double_opt", 1.2345678901234567
    set_option :".protobuf_unittest.float_opt", 12.34567928314209
    set_option :".protobuf_unittest.int32_opt", -100

  end

  class SettingRealsFromPositiveInts
    FULLY_QUALIFIED_NAME = FULLY_QUALIFIED_NAME + '.SettingRealsFromPositiveInts'
    # Message Options
    set_option :".protobuf_unittest.double_opt", 154.0
    set_option :".protobuf_unittest.float_opt", 12.0

  end

  class SettingRealsFromNegativeInts
    FULLY_QUALIFIED_NAME = FULLY_QUALIFIED_NAME + '.SettingRealsFromNegativeInts'
    # Message Options
    set_option :".protobuf_unittest.double_opt", -154.0
    set_option :".protobuf_unittest.float_opt", -12.0

  end

  class ComplexOptionType1
    FULLY_QUALIFIED_NAME = FULLY_QUALIFIED_NAME + '.ComplexOptionType1'
    optional :int32, :foo, 1
    optional :int32, :foo2, 2
    optional :int32, :foo3, 3
    repeated :int32, :foo4, 4
    # Extension Fields
    extensions 100...536870912
    optional :int32, :".protobuf_unittest.quux", 7663707, :extension => true
    optional ::Protobuf_unittest::ComplexOptionType3, :".protobuf_unittest.corge", 7663442, :extension => true
  end

  class ComplexOptionType2
    FULLY_QUALIFIED_NAME = FULLY_QUALIFIED_NAME + '.ComplexOptionType2'
    class ComplexOptionType4
      FULLY_QUALIFIED_NAME = FULLY_QUALIFIED_NAME + '.ComplexOptionType4'
      optional :int32, :waldo, 1
    end

    optional ::Protobuf_unittest::ComplexOptionType1, :bar, 1
    optional :int32, :baz, 2
    optional ::Protobuf_unittest::ComplexOptionType2::ComplexOptionType4, :fred, 3
    repeated ::Protobuf_unittest::ComplexOptionType2::ComplexOptionType4, :barney, 4
    # Extension Fields
    extensions 100...536870912
    optional :int32, :".protobuf_unittest.grault", 7650927, :extension => true
    optional ::Protobuf_unittest::ComplexOptionType1, :".protobuf_unittest.garply", 7649992, :extension => true
  end

  class ComplexOptionType3
    FULLY_QUALIFIED_NAME = FULLY_QUALIFIED_NAME + '.ComplexOptionType3'
    optional :int32, :qux, 1
  end

  class VariousComplexOptions
    FULLY_QUALIFIED_NAME = FULLY_QUALIFIED_NAME + '.VariousComplexOptions'
    # Message Options
    set_option :".protobuf_unittest.ComplexOptionType2.ComplexOptionType4.complex_opt4", { :waldo => 1971 }
    set_option :".protobuf_unittest.complex_opt3", { :qux => 9 }
    set_option :".protobuf_unittest.repeated_opt1", [1, 2]
    set_option :".protobuf_unittest.repeated_opt2", [{ :qux => 3 }, { :qux => 4 }]
    set_option :".protobuf_unittest.complex_opt2", { :bar => { :foo => 743, :".protobuf_unittest.corge" => { :qux => 2008 }, :".protobuf_unittest.quux" => 1999 }, :baz => 987, :fred => { :waldo => 321 }, :barney => [{ :waldo => 101 }, { :waldo => 212 }], :".protobuf_unittest.garply" => { :foo => 741, :".protobuf_unittest.corge" => { :qux => 2121 }, :".protobuf_unittest.quux" => 1998 }, :".protobuf_unittest.grault" => 654 }
    set_option :".protobuf_unittest.complex_opt1", { :foo => 42, :foo4 => [99, 88], :".protobuf_unittest.corge" => { :qux => 876 }, :".protobuf_unittest.quux" => 324 }

  end

  class AggregateMessageSet
    FULLY_QUALIFIED_NAME = FULLY_QUALIFIED_NAME + '.AggregateMessageSet'
    # Message Options
    set_option :message_set_wire_format, false

    # Extension Fields
    extensions 4...536870912
    optional ::Protobuf_unittest::AggregateMessageSetElement, :".protobuf_unittest.AggregateMessageSetElement.message_set_extension", 15447542, :extension => true
  end

  class AggregateMessageSetElement
    FULLY_QUALIFIED_NAME = FULLY_QUALIFIED_NAME + '.AggregateMessageSetElement'
    optional :string, :s, 1
  end

  class Aggregate
    FULLY_QUALIFIED_NAME = FULLY_QUALIFIED_NAME + '.Aggregate'
    optional :int32, :i, 1
    optional :string, :s, 2
    optional ::Protobuf_unittest::Aggregate, :sub, 3
    optional ::Google::Protobuf::FileOptions, :file, 4
    optional ::Protobuf_unittest::AggregateMessageSet, :mset, 5
  end

  class AggregateMessage
    FULLY_QUALIFIED_NAME = FULLY_QUALIFIED_NAME + '.AggregateMessage'
    # Message Options
    set_option :".protobuf_unittest.msgopt", { :i => 101, :s => "MessageAnnotation" }

    optional :int32, :fieldname, 1, :".protobuf_unittest.fieldopt" => { :s => "FieldAnnotation" }
  end

  class NestedOptionType
    FULLY_QUALIFIED_NAME = FULLY_QUALIFIED_NAME + '.NestedOptionType'
    class NestedMessage
      FULLY_QUALIFIED_NAME = FULLY_QUALIFIED_NAME + '.NestedMessage'
      # Message Options
      set_option :".protobuf_unittest.message_opt1", 1001

      optional :int32, :nested_field, 1, :".protobuf_unittest.field_opt1" => 1002
    end

  end

  class OldOptionType
    FULLY_QUALIFIED_NAME = FULLY_QUALIFIED_NAME + '.OldOptionType'
    required ::Protobuf_unittest::OldOptionType::TestEnum, :value, 1
  end

  class NewOptionType
    FULLY_QUALIFIED_NAME = FULLY_QUALIFIED_NAME + '.NewOptionType'
    required ::Protobuf_unittest::NewOptionType::TestEnum, :value, 1
  end

  class TestMessageWithRequiredEnumOption
    FULLY_QUALIFIED_NAME = FULLY_QUALIFIED_NAME + '.TestMessageWithRequiredEnumOption'
    # Message Options
    set_option :".protobuf_unittest.required_enum_opt", { :value => ::Protobuf_unittest::OldOptionType::TestEnum::OLD_VALUE }

  end


  ##
  # Extended Message Fields
  #
  class ::Google::Protobuf::FileOptions < ::Protobuf::Message
    optional :uint64, :".protobuf_unittest.file_opt1", 7736974, :extension => true
    optional ::Protobuf_unittest::Aggregate, :".protobuf_unittest.fileopt", 15478479, :extension => true
    optional ::Protobuf_unittest::Aggregate, :".protobuf_unittest.Aggregate.nested", 15476903, :extension => true
    optional :int32, :".protobuf_unittest.NestedOptionType.nested_extension", 7912573, :extension => true, :".protobuf_unittest.field_opt2" => 1005
  end

  class ::Google::Protobuf::MessageOptions < ::Protobuf::Message
    optional :int32, :".protobuf_unittest.message_opt1", 7739036, :extension => true
    optional :bool, :".protobuf_unittest.bool_opt", 7706090, :extension => true
    optional :int32, :".protobuf_unittest.int32_opt", 7705709, :extension => true
    optional :int64, :".protobuf_unittest.int64_opt", 7705542, :extension => true
    optional :uint32, :".protobuf_unittest.uint32_opt", 7704880, :extension => true
    optional :uint64, :".protobuf_unittest.uint64_opt", 7702367, :extension => true
    optional :sint32, :".protobuf_unittest.sint32_opt", 7701568, :extension => true
    optional :sint64, :".protobuf_unittest.sint64_opt", 7700863, :extension => true
    optional :fixed32, :".protobuf_unittest.fixed32_opt", 7700307, :extension => true
    optional :fixed64, :".protobuf_unittest.fixed64_opt", 7700194, :extension => true
    optional :sfixed32, :".protobuf_unittest.sfixed32_opt", 7698645, :extension => true
    optional :sfixed64, :".protobuf_unittest.sfixed64_opt", 7685475, :extension => true
    optional :float, :".protobuf_unittest.float_opt", 7675390, :extension => true
    optional :double, :".protobuf_unittest.double_opt", 7673293, :extension => true
    optional :string, :".protobuf_unittest.string_opt", 7673285, :extension => true
    optional :bytes, :".protobuf_unittest.bytes_opt", 7673238, :extension => true
    optional ::Protobuf_unittest::DummyMessageContainingEnum::TestEnumType, :".protobuf_unittest.enum_opt", 7673233, :extension => true
    optional ::Protobuf_unittest::DummyMessageInvalidAsOptionType, :".protobuf_unittest.message_type_opt", 7665967, :extension => true
    optional ::Protobuf_unittest::ComplexOptionType1, :".protobuf_unittest.complex_opt1", 7646756, :extension => true
    optional ::Protobuf_unittest::ComplexOptionType2, :".protobuf_unittest.complex_opt2", 7636949, :extension => true
    optional ::Protobuf_unittest::ComplexOptionType3, :".protobuf_unittest.complex_opt3", 7636463, :extension => true
    repeated :int32, :".protobuf_unittest.repeated_opt1", 7636464, :extension => true
    repeated ::Protobuf_unittest::ComplexOptionType3, :".protobuf_unittest.repeated_opt2", 7636465, :extension => true
    optional ::Protobuf_unittest::Aggregate, :".protobuf_unittest.msgopt", 15480088, :extension => true
    optional ::Protobuf_unittest::OldOptionType, :".protobuf_unittest.required_enum_opt", 106161807, :extension => true
    optional ::Protobuf_unittest::ComplexOptionType2::ComplexOptionType4, :".protobuf_unittest.ComplexOptionType2.ComplexOptionType4.complex_opt4", 7633546, :extension => true
  end

  class ::Google::Protobuf::FieldOptions < ::Protobuf::Message
    optional :fixed64, :".protobuf_unittest.field_opt1", 7740936, :extension => true
    optional :int32, :".protobuf_unittest.field_opt2", 7753913, :default => 42, :extension => true
    optional ::Protobuf_unittest::Aggregate, :".protobuf_unittest.fieldopt", 15481374, :extension => true
  end

  class ::Google::Protobuf::EnumOptions < ::Protobuf::Message
    optional :sfixed32, :".protobuf_unittest.enum_opt1", 7753576, :extension => true
    optional ::Protobuf_unittest::Aggregate, :".protobuf_unittest.enumopt", 15483218, :extension => true
  end

  class ::Google::Protobuf::EnumValueOptions < ::Protobuf::Message
    optional :int32, :".protobuf_unittest.enum_value_opt1", 1560678, :extension => true
    optional ::Protobuf_unittest::Aggregate, :".protobuf_unittest.enumvalopt", 15486921, :extension => true
  end

  class ::Google::Protobuf::ServiceOptions < ::Protobuf::Message
    optional :sint64, :".protobuf_unittest.service_opt1", 7887650, :extension => true
    optional ::Protobuf_unittest::Aggregate, :".protobuf_unittest.serviceopt", 15497145, :extension => true
  end

  class ::Google::Protobuf::MethodOptions < ::Protobuf::Message
    optional ::Protobuf_unittest::MethodOpt1, :".protobuf_unittest.method_opt1", 7890860, :extension => true
    optional ::Protobuf_unittest::Aggregate, :".protobuf_unittest.methodopt", 15512713, :extension => true
  end


  ##
  # Service Classes
  #
  class TestServiceWithCustomOptions < ::Protobuf::Rpc::Service
    FULLY_QUALIFIED_NAME = FULLY_QUALIFIED_NAME + '.TestServiceWithCustomOptions'

    set_option :".protobuf_unittest.service_opt1", -9876543210
    rpc :foo, ::Protobuf_unittest::CustomOptionFooRequest, ::Protobuf_unittest::CustomOptionFooResponse do
      set_option :".protobuf_unittest.method_opt1", ::Protobuf_unittest::MethodOpt1::METHODOPT1_VAL2
    end
  end

  class AggregateService < ::Protobuf::Rpc::Service
    FULLY_QUALIFIED_NAME = FULLY_QUALIFIED_NAME + '.AggregateService'

    set_option :".protobuf_unittest.serviceopt", { :s => "ServiceAnnotation" }
    rpc :method, ::Protobuf_unittest::AggregateMessage, ::Protobuf_unittest::AggregateMessage do
      set_option :".protobuf_unittest.methodopt", { :s => "MethodAnnotation" }
    end
  end

end


# Raw descriptor bytes below
__END__
Citwcm90b3MvZ29vZ2xlX3VuaXR0ZXN0X2N1c3RvbV9vcHRpb25zLnByb3Rv
EhFwcm90b2J1Zl91bml0dGVzdBogZ29vZ2xlL3Byb3RvYnVmL2Rlc2NyaXB0
b3IucHJvdG8ilQEKHFRlc3RNZXNzYWdlV2l0aEN1c3RvbU9wdGlvbnMSJgoG
ZmllbGQxGAEgASgJQg4IAcHgwx0t4XUKAgAAAFIGZmllbGQxIjsKBkFuRW51
bRIPCgtBTkVOVU1fVkFMMRABEhYKC0FORU5VTV9WQUwyEAIaBbCG+gV7GgjF
9skd6/z//zoQCADg6cIdyP//////////ASIYChZDdXN0b21PcHRpb25Gb29S
ZXF1ZXN0IhkKF0N1c3RvbU9wdGlvbkZvb1Jlc3BvbnNlIh4KHEN1c3RvbU9w
dGlvbkZvb0NsaWVudE1lc3NhZ2UiHgocQ3VzdG9tT3B0aW9uRm9vU2VydmVy
TWVzc2FnZSJtChpEdW1teU1lc3NhZ2VDb250YWluaW5nRW51bSJPCgxUZXN0
RW51bVR5cGUSGgoWVEVTVF9PUFRJT05fRU5VTV9UWVBFMRAWEiMKFlRFU1Rf
T1BUSU9OX0VOVU1fVFlQRTIQ6f//////////ASIhCh9EdW1teU1lc3NhZ2VJ
bnZhbGlkQXNPcHRpb25UeXBlIooBChxDdXN0b21PcHRpb25NaW5JbnRlZ2Vy
VmFsdWVzOmrQ3rIdAOjGsh2AgICA+P////8BsLyyHYCAgICAgICAgAGAk7Id
APj1sB0AgMSwHf////8P+JewHf///////////wGd9a8dAAAAAJHurx0AAAAA
AAAAAK2Nrx0AAACAmdaoHQAAAAAAAACAIpEBChxDdXN0b21PcHRpb25NYXhJ
bnRlZ2VyVmFsdWVzOnHQ3rIdAejGsh3/////B7C8sh3//////////3+Ak7Id
/////w/49bAd////////////AYDEsB3+////D/iXsB3+//////////8BnfWv
Hf////+R7q8d//////////+tja8d////f5nWqB3/////////fyJuChdDdXN0
b21PcHRpb25PdGhlclZhbHVlczpT6MayHZz//////////wH136Md54dFQenc
oh37WYxCysDzP6rcoh0OSGVsbG8sICJXb3JsZCKy2aIdC0hlbGxvAFdvcmxk
iNmiHen//////////wEiNAocU2V0dGluZ1JlYWxzRnJvbVBvc2l0aXZlSW50
czoU9d+jHQAAQEHp3KIdAAAAAABAY0AiNAocU2V0dGluZ1JlYWxzRnJvbU5l
Z2F0aXZlSW50czoU9d+jHQAAQMHp3KIdAAAAAABAY8AibAoSQ29tcGxleE9w
dGlvblR5cGUxEhAKA2ZvbxgBIAEoBVIDZm9vEhIKBGZvbzIYAiABKAVSBGZv
bzISEgoEZm9vMxgDIAEoBVIEZm9vMxISCgRmb280GAQgAygFUgRmb280KggI
ZBCAgICAAiLxAwoSQ29tcGxleE9wdGlvblR5cGUyEjcKA2JhchgBIAEoCzIl
LnByb3RvYnVmX3VuaXR0ZXN0LkNvbXBsZXhPcHRpb25UeXBlMVIDYmFyEhAK
A2JhehgCIAEoBVIDYmF6EkwKBGZyZWQYAyABKAsyOC5wcm90b2J1Zl91bml0
dGVzdC5Db21wbGV4T3B0aW9uVHlwZTIuQ29tcGxleE9wdGlvblR5cGU0UgRm
cmVkElAKBmJhcm5leRgEIAMoCzI4LnByb3RvYnVmX3VuaXR0ZXN0LkNvbXBs
ZXhPcHRpb25UeXBlMi5Db21wbGV4T3B0aW9uVHlwZTRSBmJhcm5leRrlAQoS
Q29tcGxleE9wdGlvblR5cGU0EhQKBXdhbGRvGAEgASgFUgV3YWxkbzK4AQpF
LnByb3RvYnVmX3VuaXR0ZXN0LkNvbXBsZXhPcHRpb25UeXBlMi5Db21wbGV4
T3B0aW9uVHlwZTQuY29tcGxleF9vcHQ0Eh8uZ29vZ2xlLnByb3RvYnVmLk1l
c3NhZ2VPcHRpb25zGIr10QMgASgLMjgucHJvdG9idWZfdW5pdHRlc3QuQ29t
cGxleE9wdGlvblR5cGUyLkNvbXBsZXhPcHRpb25UeXBlNFILY29tcGxleE9w
dDQqCAhkEICAgIACIiYKEkNvbXBsZXhPcHRpb25UeXBlMxIQCgNxdXgYASAB
KAVSA3F1eCKfAQoVVmFyaW91c0NvbXBsZXhPcHRpb25zOoUBouKVHRQIKtiF
nh3EApL1nR0DCOwGIGMgWKr9kB1AENsH+OaXHY4FChEI5wXYhZ4dzw+S9Z0d
AwjYD8Kslx0RCOUF2IWeHc4PkvWdHQMIyRAaAwjBAiICCGUiAwjUAdKojx0D
CLMP+t6QHQIICYDfkB0BgN+QHQKK35AdAggDit+QHQIIBCIjChNBZ2dyZWdh
dGVNZXNzYWdlU2V0KggIBBCAgICAAjoCCAAi5wEKGkFnZ3JlZ2F0ZU1lc3Nh
Z2VTZXRFbGVtZW50EgwKAXMYASABKAlSAXMyugEKQy5wcm90b2J1Zl91bml0
dGVzdC5BZ2dyZWdhdGVNZXNzYWdlU2V0RWxlbWVudC5tZXNzYWdlX3NldF9l
eHRlbnNpb24SJi5wcm90b2J1Zl91bml0dGVzdC5BZ2dyZWdhdGVNZXNzYWdl
U2V0GPbrrgcgASgLMi0ucHJvdG9idWZfdW5pdHRlc3QuQWdncmVnYXRlTWVz
c2FnZVNldEVsZW1lbnRSE21lc3NhZ2VTZXRFeHRlbnNpb24iuQIKCUFnZ3Jl
Z2F0ZRIMCgFpGAEgASgFUgFpEgwKAXMYAiABKAlSAXMSLgoDc3ViGAMgASgL
MhwucHJvdG9idWZfdW5pdHRlc3QuQWdncmVnYXRlUgNzdWISMAoEZmlsZRgE
IAEoCzIcLmdvb2dsZS5wcm90b2J1Zi5GaWxlT3B0aW9uc1IEZmlsZRI6CgRt
c2V0GAUgASgLMiYucHJvdG9idWZfdW5pdHRlc3QuQWdncmVnYXRlTWVzc2Fn
ZVNldFIEbXNldDJyCiMucHJvdG9idWZfdW5pdHRlc3QuQWdncmVnYXRlLm5l
c3RlZBIcLmdvb2dsZS5wcm90b2J1Zi5GaWxlT3B0aW9ucxin0bAHIAEoCzIc
LnByb3RvYnVmX3VuaXR0ZXN0LkFnZ3JlZ2F0ZVIGbmVzdGVkImQKEEFnZ3Jl
Z2F0ZU1lc3NhZ2USNAoJZmllbGRuYW1lGAEgASgFQhbyoYc7ERIPRmllbGRB
bm5vdGF0aW9uUglmaWVsZG5hbWU6GsLRhjsVCGUSEU1lc3NhZ2VBbm5vdGF0
aW9uIosCChBOZXN0ZWRPcHRpb25UeXBlGkgKDU5lc3RlZE1lc3NhZ2USLwoM
bmVzdGVkX2ZpZWxkGAEgASgFQgzB4MMd6gMAAAAAAABSC25lc3RlZEZpZWxk
Ogbg6cId6QciNQoKTmVzdGVkRW51bRIdChFORVNURURfRU5VTV9WQUxVRRAB
GgawhvoF7AcaCMX2yR3rAwAAMnYKNC5wcm90b2J1Zl91bml0dGVzdC5OZXN0
ZWRPcHRpb25UeXBlLm5lc3RlZF9leHRlbnNpb24SHC5nb29nbGUucHJvdG9i
dWYuRmlsZU9wdGlvbnMY/fjiAyABKAVCBsiLyh3tB1IPbmVzdGVkRXh0ZW5z
aW9uImsKDU9sZE9wdGlvblR5cGUSPwoFdmFsdWUYASACKA4yKS5wcm90b2J1
Zl91bml0dGVzdC5PbGRPcHRpb25UeXBlLlRlc3RFbnVtUgV2YWx1ZSIZCghU
ZXN0RW51bRINCglPTERfVkFMVUUQACJ6Cg1OZXdPcHRpb25UeXBlEj8KBXZh
bHVlGAEgAigOMikucHJvdG9idWZfdW5pdHRlc3QuTmV3T3B0aW9uVHlwZS5U
ZXN0RW51bVIFdmFsdWUiKAoIVGVzdEVudW0SDQoJT0xEX1ZBTFVFEAASDQoJ
TkVXX1ZBTFVFEAEiLQohVGVzdE1lc3NhZ2VXaXRoUmVxdWlyZWRFbnVtT3B0
aW9uOgj66PyUAwIIACo2CgpNZXRob2RPcHQxEhMKD01FVEhPRE9QVDFfVkFM
MRABEhMKD01FVEhPRE9QVDFfVkFMMhACKk0KDUFnZ3JlZ2F0ZUVudW0SJQoF
VkFMVUUQARoayvyJOxUSE0VudW1WYWx1ZUFubm90YXRpb24aFZKViDsQEg5F
bnVtQW5ub3RhdGlvbjKOAQocVGVzdFNlcnZpY2VXaXRoQ3VzdG9tT3B0aW9u
cxJjCgNGb28SKS5wcm90b2J1Zl91bml0dGVzdC5DdXN0b21PcHRpb25Gb29S
ZXF1ZXN0GioucHJvdG9idWZfdW5pdHRlc3QuQ3VzdG9tT3B0aW9uRm9vUmVz
cG9uc2UiBeD6jB4CGgmQsose09uAy0kymQEKEEFnZ3JlZ2F0ZVNlcnZpY2US
awoGTWV0aG9kEiMucHJvdG9idWZfdW5pdHRlc3QuQWdncmVnYXRlTWVzc2Fn
ZRojLnByb3RvYnVmX3VuaXR0ZXN0LkFnZ3JlZ2F0ZU1lc3NhZ2UiF8rIljsS
EhBNZXRob2RBbm5vdGF0aW9uGhjK+447ExIRU2VydmljZUFubm90YXRpb246
TwocLnByb3RvYnVmX3VuaXR0ZXN0LmZpbGVfb3B0MRIcLmdvb2dsZS5wcm90
b2J1Zi5GaWxlT3B0aW9ucxiOndgDIAEoBFIIZmlsZU9wdDE6WAofLnByb3Rv
YnVmX3VuaXR0ZXN0Lm1lc3NhZ2Vfb3B0MRIfLmdvb2dsZS5wcm90b2J1Zi5N
ZXNzYWdlT3B0aW9ucxicrdgDIAEoBVILbWVzc2FnZU9wdDE6UgodLnByb3Rv
YnVmX3VuaXR0ZXN0LmZpZWxkX29wdDESHS5nb29nbGUucHJvdG9idWYuRmll
bGRPcHRpb25zGIi82AMgASgGUglmaWVsZE9wdDE6VgodLnByb3RvYnVmX3Vu
aXR0ZXN0LmZpZWxkX29wdDISHS5nb29nbGUucHJvdG9idWYuRmllbGRPcHRp
b25zGLmh2QMgASgFOgI0MlIJZmllbGRPcHQyOk8KHC5wcm90b2J1Zl91bml0
dGVzdC5lbnVtX29wdDESHC5nb29nbGUucHJvdG9idWYuRW51bU9wdGlvbnMY
6J7ZAyABKA9SCGVudW1PcHQxOl4KIi5wcm90b2J1Zl91bml0dGVzdC5lbnVt
X3ZhbHVlX29wdDESIS5nb29nbGUucHJvdG9idWYuRW51bVZhbHVlT3B0aW9u
cxjmoF8gASgFUg1lbnVtVmFsdWVPcHQxOlgKHy5wcm90b2J1Zl91bml0dGVz
dC5zZXJ2aWNlX29wdDESHy5nb29nbGUucHJvdG9idWYuU2VydmljZU9wdGlv
bnMYorbhAyABKBJSC3NlcnZpY2VPcHQxOnQKHi5wcm90b2J1Zl91bml0dGVz
dC5tZXRob2Rfb3B0MRIeLmdvb2dsZS5wcm90b2J1Zi5NZXRob2RPcHRpb25z
GKzP4QMgASgOMh0ucHJvdG9idWZfdW5pdHRlc3QuTWV0aG9kT3B0MVIKbWV0
aG9kT3B0MTpQChsucHJvdG9idWZfdW5pdHRlc3QuYm9vbF9vcHQSHy5nb29n
bGUucHJvdG9idWYuTWVzc2FnZU9wdGlvbnMY6qvWAyABKAhSB2Jvb2xPcHQ6
UgocLnByb3RvYnVmX3VuaXR0ZXN0LmludDMyX29wdBIfLmdvb2dsZS5wcm90
b2J1Zi5NZXNzYWdlT3B0aW9ucxjtqNYDIAEoBVIIaW50MzJPcHQ6UgocLnBy
b3RvYnVmX3VuaXR0ZXN0LmludDY0X29wdBIfLmdvb2dsZS5wcm90b2J1Zi5N
ZXNzYWdlT3B0aW9ucxjGp9YDIAEoA1IIaW50NjRPcHQ6VAodLnByb3RvYnVm
X3VuaXR0ZXN0LnVpbnQzMl9vcHQSHy5nb29nbGUucHJvdG9idWYuTWVzc2Fn
ZU9wdGlvbnMYsKLWAyABKA1SCXVpbnQzMk9wdDpUCh0ucHJvdG9idWZfdW5p
dHRlc3QudWludDY0X29wdBIfLmdvb2dsZS5wcm90b2J1Zi5NZXNzYWdlT3B0
aW9ucxjfjtYDIAEoBFIJdWludDY0T3B0OlQKHS5wcm90b2J1Zl91bml0dGVz
dC5zaW50MzJfb3B0Eh8uZ29vZ2xlLnByb3RvYnVmLk1lc3NhZ2VPcHRpb25z
GMCI1gMgASgRUglzaW50MzJPcHQ6VAodLnByb3RvYnVmX3VuaXR0ZXN0LnNp
bnQ2NF9vcHQSHy5nb29nbGUucHJvdG9idWYuTWVzc2FnZU9wdGlvbnMY/4LW
AyABKBJSCXNpbnQ2NE9wdDpWCh4ucHJvdG9idWZfdW5pdHRlc3QuZml4ZWQz
Ml9vcHQSHy5nb29nbGUucHJvdG9idWYuTWVzc2FnZU9wdGlvbnMY0/7VAyAB
KAdSCmZpeGVkMzJPcHQ6VgoeLnByb3RvYnVmX3VuaXR0ZXN0LmZpeGVkNjRf
b3B0Eh8uZ29vZ2xlLnByb3RvYnVmLk1lc3NhZ2VPcHRpb25zGOL91QMgASgG
UgpmaXhlZDY0T3B0OlgKHy5wcm90b2J1Zl91bml0dGVzdC5zZml4ZWQzMl9v
cHQSHy5nb29nbGUucHJvdG9idWYuTWVzc2FnZU9wdGlvbnMY1fHVAyABKA9S
C3NmaXhlZDMyT3B0OlgKHy5wcm90b2J1Zl91bml0dGVzdC5zZml4ZWQ2NF9v
cHQSHy5nb29nbGUucHJvdG9idWYuTWVzc2FnZU9wdGlvbnMY44rVAyABKBBS
C3NmaXhlZDY0T3B0OlIKHC5wcm90b2J1Zl91bml0dGVzdC5mbG9hdF9vcHQS
Hy5nb29nbGUucHJvdG9idWYuTWVzc2FnZU9wdGlvbnMY/rvUAyABKAJSCGZs
b2F0T3B0OlQKHS5wcm90b2J1Zl91bml0dGVzdC5kb3VibGVfb3B0Eh8uZ29v
Z2xlLnByb3RvYnVmLk1lc3NhZ2VPcHRpb25zGM2r1AMgASgBUglkb3VibGVP
cHQ6VAodLnByb3RvYnVmX3VuaXR0ZXN0LnN0cmluZ19vcHQSHy5nb29nbGUu
cHJvdG9idWYuTWVzc2FnZU9wdGlvbnMYxavUAyABKAlSCXN0cmluZ09wdDpS
ChwucHJvdG9idWZfdW5pdHRlc3QuYnl0ZXNfb3B0Eh8uZ29vZ2xlLnByb3Rv
YnVmLk1lc3NhZ2VPcHRpb25zGJar1AMgASgMUghieXRlc09wdDqMAQobLnBy
b3RvYnVmX3VuaXR0ZXN0LmVudW1fb3B0Eh8uZ29vZ2xlLnByb3RvYnVmLk1l
c3NhZ2VPcHRpb25zGJGr1AMgASgOMjoucHJvdG9idWZfdW5pdHRlc3QuRHVt
bXlNZXNzYWdlQ29udGFpbmluZ0VudW0uVGVzdEVudW1UeXBlUgdlbnVtT3B0
OpMBCiMucHJvdG9idWZfdW5pdHRlc3QubWVzc2FnZV90eXBlX29wdBIfLmdv
b2dsZS5wcm90b2J1Zi5NZXNzYWdlT3B0aW9ucxiv8tMDIAEoCzIyLnByb3Rv
YnVmX3VuaXR0ZXN0LkR1bW15TWVzc2FnZUludmFsaWRBc09wdGlvblR5cGVS
Dm1lc3NhZ2VUeXBlT3B0Ok8KFy5wcm90b2J1Zl91bml0dGVzdC5xdXV4EiUu
cHJvdG9idWZfdW5pdHRlc3QuQ29tcGxleE9wdGlvblR5cGUxGNvg0wMgASgF
UgRxdXV4OngKGC5wcm90b2J1Zl91bml0dGVzdC5jb3JnZRIlLnByb3RvYnVm
X3VuaXR0ZXN0LkNvbXBsZXhPcHRpb25UeXBlMRjS3tMDIAEoCzIlLnByb3Rv
YnVmX3VuaXR0ZXN0LkNvbXBsZXhPcHRpb25UeXBlM1IFY29yZ2U6UwoZLnBy
b3RvYnVmX3VuaXR0ZXN0LmdyYXVsdBIlLnByb3RvYnVmX3VuaXR0ZXN0LkNv
bXBsZXhPcHRpb25UeXBlMhjv/NIDIAEoBVIGZ3JhdWx0OnoKGS5wcm90b2J1
Zl91bml0dGVzdC5nYXJwbHkSJS5wcm90b2J1Zl91bml0dGVzdC5Db21wbGV4
T3B0aW9uVHlwZTIYyPXSAyABKAsyJS5wcm90b2J1Zl91bml0dGVzdC5Db21w
bGV4T3B0aW9uVHlwZTFSBmdhcnBseTp/Ch8ucHJvdG9idWZfdW5pdHRlc3Qu
Y29tcGxleF9vcHQxEh8uZ29vZ2xlLnByb3RvYnVmLk1lc3NhZ2VPcHRpb25z
GKTc0gMgASgLMiUucHJvdG9idWZfdW5pdHRlc3QuQ29tcGxleE9wdGlvblR5
cGUxUgtjb21wbGV4T3B0MTp/Ch8ucHJvdG9idWZfdW5pdHRlc3QuY29tcGxl
eF9vcHQyEh8uZ29vZ2xlLnByb3RvYnVmLk1lc3NhZ2VPcHRpb25zGNWP0gMg
ASgLMiUucHJvdG9idWZfdW5pdHRlc3QuQ29tcGxleE9wdGlvblR5cGUyUgtj
b21wbGV4T3B0Mjp/Ch8ucHJvdG9idWZfdW5pdHRlc3QuY29tcGxleF9vcHQz
Eh8uZ29vZ2xlLnByb3RvYnVmLk1lc3NhZ2VPcHRpb25zGO+L0gMgASgLMiUu
cHJvdG9idWZfdW5pdHRlc3QuQ29tcGxleE9wdGlvblR5cGUzUgtjb21wbGV4
T3B0MzpaCiAucHJvdG9idWZfdW5pdHRlc3QucmVwZWF0ZWRfb3B0MRIfLmdv
b2dsZS5wcm90b2J1Zi5NZXNzYWdlT3B0aW9ucxjwi9IDIAMoBVIMcmVwZWF0
ZWRPcHQxOoEBCiAucHJvdG9idWZfdW5pdHRlc3QucmVwZWF0ZWRfb3B0MhIf
Lmdvb2dsZS5wcm90b2J1Zi5NZXNzYWdlT3B0aW9ucxjxi9IDIAMoCzIlLnBy
b3RvYnVmX3VuaXR0ZXN0LkNvbXBsZXhPcHRpb25UeXBlM1IMcmVwZWF0ZWRP
cHQyOmoKGi5wcm90b2J1Zl91bml0dGVzdC5maWxlb3B0EhwuZ29vZ2xlLnBy
b3RvYnVmLkZpbGVPcHRpb25zGM/dsAcgASgLMhwucHJvdG9idWZfdW5pdHRl
c3QuQWdncmVnYXRlUgdmaWxlb3B0OmsKGS5wcm90b2J1Zl91bml0dGVzdC5t
c2dvcHQSHy5nb29nbGUucHJvdG9idWYuTWVzc2FnZU9wdGlvbnMYmOqwByAB
KAsyHC5wcm90b2J1Zl91bml0dGVzdC5BZ2dyZWdhdGVSBm1zZ29wdDptChsu
cHJvdG9idWZfdW5pdHRlc3QuZmllbGRvcHQSHS5nb29nbGUucHJvdG9idWYu
RmllbGRPcHRpb25zGJ70sAcgASgLMhwucHJvdG9idWZfdW5pdHRlc3QuQWdn
cmVnYXRlUghmaWVsZG9wdDpqChoucHJvdG9idWZfdW5pdHRlc3QuZW51bW9w
dBIcLmdvb2dsZS5wcm90b2J1Zi5FbnVtT3B0aW9ucxjSgrEHIAEoCzIcLnBy
b3RvYnVmX3VuaXR0ZXN0LkFnZ3JlZ2F0ZVIHZW51bW9wdDp1Ch0ucHJvdG9i
dWZfdW5pdHRlc3QuZW51bXZhbG9wdBIhLmdvb2dsZS5wcm90b2J1Zi5FbnVt
VmFsdWVPcHRpb25zGMmfsQcgASgLMhwucHJvdG9idWZfdW5pdHRlc3QuQWdn
cmVnYXRlUgplbnVtdmFsb3B0OnMKHS5wcm90b2J1Zl91bml0dGVzdC5zZXJ2
aWNlb3B0Eh8uZ29vZ2xlLnByb3RvYnVmLlNlcnZpY2VPcHRpb25zGLnvsQcg
ASgLMhwucHJvdG9idWZfdW5pdHRlc3QuQWdncmVnYXRlUgpzZXJ2aWNlb3B0
OnAKHC5wcm90b2J1Zl91bml0dGVzdC5tZXRob2RvcHQSHi5nb29nbGUucHJv
dG9idWYuTWV0aG9kT3B0aW9ucxiJ6bIHIAEoCzIcLnByb3RvYnVmX3VuaXR0
ZXN0LkFnZ3JlZ2F0ZVIJbWV0aG9kb3B0OoMBCiQucHJvdG9idWZfdW5pdHRl
c3QucmVxdWlyZWRfZW51bV9vcHQSHy5nb29nbGUucHJvdG9idWYuTWVzc2Fn
ZU9wdGlvbnMYj83PMiABKAsyIC5wcm90b2J1Zl91bml0dGVzdC5PbGRPcHRp
b25UeXBlUg9yZXF1aXJlZEVudW1PcHRCgwGAAQGIAQGQAQHw6MEd6q3A5ST6
7IU7bAhkEg5GaWxlQW5ub3RhdGlvbhoWEhROZXN0ZWRGaWxlQW5ub3RhdGlv
biIe+uyFOxkSF0ZpbGVFeHRlbnNpb25Bbm5vdGF0aW9uKiCy3/Y6GwoZRW1i
ZWRkZWRNZXNzYWdlU2V0RWxlbWVudEqYaQoHEgUkAKcDAQqiDgoBDBIDJAAS
MsEMIFByb3RvY29sIEJ1ZmZlcnMgLSBHb29nbGUncyBkYXRhIGludGVyY2hh
bmdlIGZvcm1hdAogQ29weXJpZ2h0IDIwMDggR29vZ2xlIEluYy4gIEFsbCBy
aWdodHMgcmVzZXJ2ZWQuCiBodHRwczovL2RldmVsb3BlcnMuZ29vZ2xlLmNv
bS9wcm90b2NvbC1idWZmZXJzLwoKIFJlZGlzdHJpYnV0aW9uIGFuZCB1c2Ug
aW4gc291cmNlIGFuZCBiaW5hcnkgZm9ybXMsIHdpdGggb3Igd2l0aG91dAog
bW9kaWZpY2F0aW9uLCBhcmUgcGVybWl0dGVkIHByb3ZpZGVkIHRoYXQgdGhl
IGZvbGxvd2luZyBjb25kaXRpb25zIGFyZQogbWV0OgoKICAgICAqIFJlZGlz
dHJpYnV0aW9ucyBvZiBzb3VyY2UgY29kZSBtdXN0IHJldGFpbiB0aGUgYWJv
dmUgY29weXJpZ2h0CiBub3RpY2UsIHRoaXMgbGlzdCBvZiBjb25kaXRpb25z
IGFuZCB0aGUgZm9sbG93aW5nIGRpc2NsYWltZXIuCiAgICAgKiBSZWRpc3Ry
aWJ1dGlvbnMgaW4gYmluYXJ5IGZvcm0gbXVzdCByZXByb2R1Y2UgdGhlIGFi
b3ZlCiBjb3B5cmlnaHQgbm90aWNlLCB0aGlzIGxpc3Qgb2YgY29uZGl0aW9u
cyBhbmQgdGhlIGZvbGxvd2luZyBkaXNjbGFpbWVyCiBpbiB0aGUgZG9jdW1l
bnRhdGlvbiBhbmQvb3Igb3RoZXIgbWF0ZXJpYWxzIHByb3ZpZGVkIHdpdGgg
dGhlCiBkaXN0cmlidXRpb24uCiAgICAgKiBOZWl0aGVyIHRoZSBuYW1lIG9m
IEdvb2dsZSBJbmMuIG5vciB0aGUgbmFtZXMgb2YgaXRzCiBjb250cmlidXRv
cnMgbWF5IGJlIHVzZWQgdG8gZW5kb3JzZSBvciBwcm9tb3RlIHByb2R1Y3Rz
IGRlcml2ZWQgZnJvbQogdGhpcyBzb2Z0d2FyZSB3aXRob3V0IHNwZWNpZmlj
IHByaW9yIHdyaXR0ZW4gcGVybWlzc2lvbi4KCiBUSElTIFNPRlRXQVJFIElT
IFBST1ZJREVEIEJZIFRIRSBDT1BZUklHSFQgSE9MREVSUyBBTkQgQ09OVFJJ
QlVUT1JTCiAiQVMgSVMiIEFORCBBTlkgRVhQUkVTUyBPUiBJTVBMSUVEIFdB
UlJBTlRJRVMsIElOQ0xVRElORywgQlVUIE5PVAogTElNSVRFRCBUTywgVEhF
IElNUExJRUQgV0FSUkFOVElFUyBPRiBNRVJDSEFOVEFCSUxJVFkgQU5EIEZJ
VE5FU1MgRk9SCiBBIFBBUlRJQ1VMQVIgUFVSUE9TRSBBUkUgRElTQ0xBSU1F
RC4gSU4gTk8gRVZFTlQgU0hBTEwgVEhFIENPUFlSSUdIVAogT1dORVIgT1Ig
Q09OVFJJQlVUT1JTIEJFIExJQUJMRSBGT1IgQU5ZIERJUkVDVCwgSU5ESVJF
Q1QsIElOQ0lERU5UQUwsCiBTUEVDSUFMLCBFWEVNUExBUlksIE9SIENPTlNF
UVVFTlRJQUwgREFNQUdFUyAoSU5DTFVESU5HLCBCVVQgTk9UCiBMSU1JVEVE
IFRPLCBQUk9DVVJFTUVOVCBPRiBTVUJTVElUVVRFIEdPT0RTIE9SIFNFUlZJ
Q0VTOyBMT1NTIE9GIFVTRSwKIERBVEEsIE9SIFBST0ZJVFM7IE9SIEJVU0lO
RVNTIElOVEVSUlVQVElPTikgSE9XRVZFUiBDQVVTRUQgQU5EIE9OIEFOWQog
VEhFT1JZIE9GIExJQUJJTElUWSwgV0hFVEhFUiBJTiBDT05UUkFDVCwgU1RS
SUNUIExJQUJJTElUWSwgT1IgVE9SVAogKElOQ0xVRElORyBORUdMSUdFTkNF
IE9SIE9USEVSV0lTRSkgQVJJU0lORyBJTiBBTlkgV0FZIE9VVCBPRiBUSEUg
VVNFCiBPRiBUSElTIFNPRlRXQVJFLCBFVkVOIElGIEFEVklTRUQgT0YgVEhF
IFBPU1NJQklMSVRZIE9GIFNVQ0ggREFNQUdFLgoy0wEgQXV0aG9yOiBiZW5q
eUBnb29nbGUuY29tIChCZW5qeSBXZWluYmVyZ2VyKQogIEJhc2VkIG9uIG9y
aWdpbmFsIFByb3RvY29sIEJ1ZmZlcnMgZGVzaWduIGJ5CiAgU2FuamF5IEdo
ZW1hd2F0LCBKZWZmIERlYW4sIGFuZCBvdGhlcnMuCgogQSBwcm90byBmaWxl
IHVzZWQgdG8gdGVzdCB0aGUgImN1c3RvbSBvcHRpb25zIiBmZWF0dXJlIG9m
IGdvb2dsZS5wcm90b2J1Zi4KCggKAQgSAygAIgqAAQoCCBASAygAIhpnIFNv
bWUgZ2VuZXJpY19zZXJ2aWNlcyBvcHRpb24ocykgYWRkZWQgYXV0b21hdGlj
YWxseS4KIFNlZTogIGh0dHA6Ly9nby9wcm90bzItZ2VuZXJpYy1zZXJ2aWNl
cy1kZWZhdWx0CiIMIGF1dG8tYWRkZWQKCggKAQgSAykAJAoXCgIIERIDKQAk
IgwgYXV0by1hZGRlZAoKCAoBCBIDKgAiCgkKAggSEgMqACIKCAoBCBIDLQAg
CjUKBQiOndgDEgMtACAaJyBBIGN1c3RvbSBmaWxlIG9wdGlvbiAoZGVmaW5l
ZCBiZWxvdykuCgoJCgIDABIDLwAqCqABCgECEgMzABoalQEgV2UgZG9uJ3Qg
cHV0IHRoaXMgaW4gYSBwYWNrYWdlIHdpdGhpbiBwcm90bzIgYmVjYXVzZSB3
ZSBuZWVkIHRvIG1ha2Ugc3VyZQogdGhhdCB0aGUgZ2VuZXJhdGVkIGNvZGUg
ZG9lc24ndCBkZXBlbmQgb24gYmVpbmcgaW4gdGhlIHByb3RvMiBuYW1lc3Bh
Y2UuCgo+CgEHEgQ4ADoBMjMgU29tZSBzaW1wbGUgdGVzdCBjdXN0b20gb3B0
aW9ucyBvZiB2YXJpb3VzIHR5cGVzLgoKCQoCBwASAzkCJgoKCgMHAAISAzgH
IgoKCgMHAAQSAzkCCgoKCgMHAAUSAzkLEQoKCgMHAAESAzkSGwoKCgMHAAMS
AzkeJQoJCgEHEgQ8AD4BCgkKAgcBEgM9AigKCgoDBwECEgM8ByUKCgoDBwEE
EgM9AgoKCgoDBwEFEgM9CxAKCgoDBwEBEgM9ER0KCgoDBwEDEgM9ICcKCQoB
BxIEQABFAQoJCgIHAhIDQQIoCgoKAwcCAhIDQAcjCgoKAwcCBBIDQQIKCgoK
AwcCBRIDQQsSCgoKAwcCARIDQRMdCgoKAwcCAxIDQSAnCmkKAgcDEgNEAjMa
XiBUaGlzIGlzIHVzZWZ1bCBmb3IgdGVzdGluZyB0aGF0IHdlIGNvcnJlY3Rs
eSByZWdpc3RlciBkZWZhdWx0IHZhbHVlcyBmb3IKIGV4dGVuc2lvbiBvcHRp
b25zLgoKCgoDBwMCEgNAByMKCgoDBwMEEgNEAgoKCgoDBwMFEgNECxAKCgoD
BwMBEgNEERsKCgoDBwMDEgNEHiUKCgoDBwMIEgNEJjIKCgoDBwMHEgNELzEK
CQoBBxIERwBJAQoJCgIHBBIDSAIoCgoKAwcEAhIDRwciCgoKAwcEBBIDSAIK
CgoKAwcEBRIDSAsTCgoKAwcEARIDSBQdCgoKAwcEAxIDSCAnCgkKAQcSBEsA
TQEKCQoCBwUSA0wCKwoKCgMHBQISA0sHJwoKCgMHBQQSA0wCCgoKCgMHBQUS
A0wLEAoKCgMHBQESA0wRIAoKCgMHBQMSA0wjKgoJCgEHEgRPAFEBCgkKAgcG
EgNQAikKCgoDBwYCEgNPByUKCgoDBwYEEgNQAgoKCgoDBwYFEgNQCxEKCgoD
BwYBEgNQEh4KCgoDBwYDEgNQISgKCgoCBQASBFMAVgEKCgoDBQABEgNTBQ8K
CwoEBQACABIDVAIWCgwKBQUAAgABEgNUAhEKDAoFBQACAAISA1QUFQoLCgQF
AAIBEgNVAhYKDAoFBQACAQESA1UCEQoMCgUFAAIBAhIDVRQVCgkKAQcSBFgA
WgEKCQoCBwcSA1kCLAoKCgMHBwISA1gHJAoKCgMHBwQSA1kCCgoKCgMHBwYS
A1kLFQoKCgMHBwESA1kWIQoKCgMHBwMSA1kkKwqQAQoCBAASBF4AbAEagwEg
QSB0ZXN0IG1lc3NhZ2Ugd2l0aCBjdXN0b20gb3B0aW9ucyBhdCBhbGwgcG9z
c2libGUgbG9jYXRpb25zIChhbmQgYWxzbyBzb21lCiByZWd1bGFyIG9wdGlv
bnMsIHRvIG1ha2Ugc3VyZSB0aGV5IGludGVyYWN0IG5pY2VseSkuCgoKCgME
AAESA14IJAoKCgMEAAcSA18CKQoLCgQEAAcBEgNfAikKCgoDBAAHEgNhAh4K
DgoHBAAHnK3YAxIDYQIeCgwKBAQAAgASBGMCZDcKDAoFBAACAAQSA2MCCgoM
CgUEAAIABRIDYwsRCgwKBQQAAgABEgNjEhgKDAoFBAACAAMSA2MbHAoNCgUE
AAIACBIEYx1kNgoNCgYEAAIACAESA2MeKAoQCgkEAAIACIi82AMSA2QeNQoM
CgQEAAQAEgRmAmsDCgwKBQQABAABEgNmBw0KDAoFBAAEAAMSA2cEHgoQCgkE
AAQAA+ie2QMSA2cEHgoNCgYEAAQAAgASA2kEFAoOCgcEAAQAAgABEgNpBA8K
DgoHBAAEAAIAAhIDaRITCg0KBgQABAACARIDagQuCg4KBwQABAACAQESA2oE
DwoOCgcEAAQAAgECEgNqEhMKDgoHBAAEAAIBAxIDahQtChEKCgQABAACAQPm
oF8SA2oVLAqUAQoCBAESBHEAcgEahwEgQSB0ZXN0IFJQQyBzZXJ2aWNlIHdp
dGggY3VzdG9tIG9wdGlvbnMgYXQgYWxsIHBvc3NpYmxlIGxvY2F0aW9ucyAo
YW5kIGFsc28KIHNvbWUgcmVndWxhciBvcHRpb25zLCB0byBtYWtlIHN1cmUg
dGhleSBpbnRlcmFjdCBuaWNlbHkpLgoKCgoDBAEBEgNxCB4KCgoCBAISBHQA
dQEKCgoDBAIBEgN0CB8KCgoCBAMSBHcAeAEKCgoDBAMBEgN3CCQKCgoCBAQS
BHoAewEKCgoDBAQBEgN6CCQKCwoCBgASBX0AgwEBCgoKAwYAARIDfQgkCgoK
AwYAAxIDfgImCg4KBwYAA6K24QMSA34CJgoOCgQGAAIAEgaAAQKCAQMKDQoF
BgACAAESBIABBgkKDQoFBgACAAISBIABCiAKDQoFBgACAAMSBIABK0IKDQoF
BgACAAQSBIEBBCsKEQoJBgACAASsz+EDEgSBAQQrClsKAgQFEgaJAQCOAQEy
TSBPcHRpb25zIG9mIGV2ZXJ5IHBvc3NpYmxlIGZpZWxkIHR5cGUsIHNvIHdl
IGNhbiB0ZXN0IHRoZW0gYWxsIGV4aGF1c3RpdmVseS4KCgsKAwQFARIEiQEI
IgoOCgQEBQQAEgaKAQKNAQMKDQoFBAUEAAESBIoBBxMKDgoGBAUEAAIAEgSL
AQQgCg8KBwQFBAACAAESBIsBBBoKDwoHBAUEAAIAAhIEiwEdHwoOCgYEBQQA
AgESBIwBBCEKDwoHBAUEAAIBARIEjAEEGgoPCgcEBQQAAgECEgSMAR0gCgwK
AgQGEgaQAQCRAQEKCwoDBAYBEgSQAQgnCgsKAQcSBpMBAKUBAQoKCgIHCBIE
lAECLwoLCgMHCAISBJMBByUKCwoDBwgEEgSUAQIKCgsKAwcIBRIElAETFwoL
CgMHCAESBJQBHCQKCwoDBwgDEgSUAScuCgoKAgcJEgSVAQIvCgsKAwcJAhIE
kwEHJQoLCgMHCQQSBJUBAgoKCwoDBwkFEgSVARIXCgsKAwcJARIElQEbJAoL
CgMHCQMSBJUBJy4KCgoCBwoSBJYBAi8KCwoDBwoCEgSTAQclCgsKAwcKBBIE
lgECCgoLCgMHCgUSBJYBEhcKCwoDBwoBEgSWARskCgsKAwcKAxIElgEnLgoK
CgIHCxIElwECLwoLCgMHCwISBJMBByUKCwoDBwsEEgSXAQIKCgsKAwcLBRIE
lwERFwoLCgMHCwESBJcBGiQKCwoDBwsDEgSXAScuCgoKAgcMEgSYAQIvCgsK
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
BwQJB/671AMSBMUBAiMKCwoDBAkHEgTGAQItCg8KBwQJB82r1AMSBMYBAi0K
CwoDBAkHEgTHAQIrCg8KBwQJB8Wr1AMSBMcBAisKCwoDBAkHEgTIAQInCg8K
BwQJB5ar1AMSBMgBAicKCwoDBAkHEgTJAQIvCg8KBwQJB5Gr1AMSBMkBAi8K
DAoCBAoSBswBAM8BAQoLCgMECgESBMwBCCQKCwoDBAoHEgTNAQIbCg8KBwQK
B/671AMSBM0BAhsKCwoDBAoHEgTOAQIcCg8KBwQKB82r1AMSBM4BAhwKDAoC
BAsSBtEBANQBAQoLCgMECwESBNEBCCQKCwoDBAsHEgTSAQIcCg8KBwQLB/67
1AMSBNIBAhwKCwoDBAsHEgTTAQIeCg8KBwQLB82r1AMSBNMBAh4KwAEKAgQM
EgbbAQDiAQEaWiBUT0RPOiBkbyB3ZSB3YW50IHRvIHN1cHBvcnQgcGFja2Vk
IGludHM/CiBlLmcuOiByZXBlYXRlZCBpbnQzMiBmb280ID0gNCBbcGFja2Vk
ID0gdHJ1ZV07CjJWIE9wdGlvbnMgb2YgY29tcGxleCBtZXNzYWdlIHR5cGVz
LCB0aGVtc2VsdmVzIGNvbWJpbmVkIGFuZCBleHRlbmRlZCBpbgogdmFyaW91
cyB3YXlzLgoKCwoDBAwBEgTbAQgaCgwKBAQMAgASBNwBAhkKDQoFBAwCAAQS
BNwBAgoKDQoFBAwCAAUSBNwBCxAKDQoFBAwCAAESBNwBERQKDQoFBAwCAAMS
BNwBFxgKDAoEBAwCARIE3QECGgoNCgUEDAIBBBIE3QECCgoNCgUEDAIBBRIE
3QELEAoNCgUEDAIBARIE3QERFQoNCgUEDAIBAxIE3QEYGQoMCgQEDAICEgTe
AQIaCg0KBQQMAgIEEgTeAQIKCg0KBQQMAgIFEgTeAQsQCg0KBQQMAgIBEgTe
AREVCg0KBQQMAgIDEgTeARgZCgwKBAQMAgMSBN8BAhoKDQoFBAwCAwQSBN8B
AgoKDQoFBAwCAwUSBN8BCxAKDQoFBAwCAwESBN8BERUKDQoFBAwCAwMSBN8B
GBkKCwoDBAwFEgThAQIYCgwKBAQMBQASBOEBDRcKDQoFBAwFAAESBOEBDRAK
DQoFBAwFAAISBOEBFBcKDAoCBA0SBuQBAPQBAQoLCgMEDQESBOQBCBoKDAoE
BA0CABIE5QECJgoNCgUEDQIABBIE5QECCgoNCgUEDQIABhIE5QELHQoNCgUE
DQIAARIE5QEeIQoNCgUEDQIAAxIE5QEkJQoMCgQEDQIBEgTmAQIZCg0KBQQN
AgEEEgTmAQIKCg0KBQQNAgEFEgTmAQsQCg0KBQQNAgEBEgTmAREUCg0KBQQN
AgEDEgTmARcYCg4KBAQNAwASBugBAu4BAwoNCgUEDQMAARIE6AEKHAoOCgYE
DQMAAgASBOkBBB0KDwoHBA0DAAIABBIE6QEEDAoPCgcEDQMAAgAFEgTpAQ0S
Cg8KBwQNAwACAAESBOkBExgKDwoHBA0DAAIAAxIE6QEbHAoPCgUEDQMABhIG
6wEE7QEFCg4KBgQNAwAGABIE7AEGOQoPCgcEDQMABgACEgTrAQspCg8KBwQN
AwAGAAQSBOwBBg4KDwoHBA0DAAYABhIE7AEPIQoPCgcEDQMABgABEgTsASIu
Cg8KBwQNAwAGAAMSBOwBMTgKDAoEBA0CAhIE8AECJwoNCgUEDQICBBIE8AEC
CgoNCgUEDQICBhIE8AELHQoNCgUEDQICARIE8AEeIgoNCgUEDQICAxIE8AEl
JgoMCgQEDQIDEgTxAQIpCg0KBQQNAgMEEgTxAQIKCg0KBQQNAgMGEgTxAQsd
Cg0KBQQNAgMBEgTxAR4kCg0KBQQNAgMDEgTxAScoCgsKAwQNBRIE8wECGAoM
CgQEDQUAEgTzAQ0XCg0KBQQNBQABEgTzAQ0QCg0KBQQNBQACEgTzARQXCgwK
AgQOEgb2AQD4AQEKCwoDBA4BEgT2AQgaCgwKBAQOAgASBPcBAhkKDQoFBA4C
AAQSBPcBAgoKDQoFBA4CAAUSBPcBCxAKDQoFBA4CAAESBPcBERQKDQoFBA4C
AAMSBPcBFxgKCwoBBxIG+gEA/QEBCgoKAgcZEgT7AQIgCgsKAwcZAhIE+gEH
GQoLCgMHGQQSBPsBAgoKCwoDBxkFEgT7AQsQCgsKAwcZARIE+wERFQoLCgMH
GQMSBPsBGB8KCgoCBxoSBPwBAi4KCwoDBxoCEgT6AQcZCgsKAwcaBBIE/AEC
CgoLCgMHGgYSBPwBCx0KCwoDBxoBEgT8AR4jCgsKAwcaAxIE/AEmLQoLCgEH
Egb/AQCCAgEKCgoCBxsSBIACAiIKCwoDBxsCEgT/AQcZCgsKAwcbBBIEgAIC
CgoLCgMHGwUSBIACCxAKCwoDBxsBEgSAAhEXCgsKAwcbAxIEgAIaIQoKCgIH
HBIEgQICLwoLCgMHHAISBP8BBxkKCwoDBxwEEgSBAgIKCgsKAwccBhIEgQIL
HQoLCgMHHAESBIECHiQKCwoDBxwDEgSBAicuCgsKAQcSBoQCAIoCAQoKCgIH
HRIEhQICRwoLCgMHHQISBIQCByUKCwoDBx0EEgSFAgIKCgsKAwcdBhIEhQIL
LwoLCgMHHQESBIUCMDwKCwoDBx0DEgSFAj9GCgoKAgceEgSGAgI1CgsKAwce
AhIEhAIHJQoLCgMHHgQSBIYCAgoKCwoDBx4GEgSGAgsdCgsKAwceARIEhgIe
KgoLCgMHHgMSBIYCLTQKCgoCBx8SBIcCAjUKCwoDBx8CEgSEAgclCgsKAwcf
BBIEhwICCgoLCgMHHwYSBIcCCx0KCwoDBx8BEgSHAh4qCgsKAwcfAxIEhwIt
NAoKCgIHIBIEiAICKQoLCgMHIAISBIQCByUKCwoDByAEEgSIAgIKCgsKAwcg
BRIEiAILEAoLCgMHIAESBIgCER4KCwoDByADEgSIAiEoCgoKAgchEgSJAgJI
CgsKAwchAhIEhAIHJQoLCgMHIQQSBIkCAgoKCwoDByEGEgSJAgsvCgsKAwch
ARIEiQIwPQoLCgMHIQMSBIkCQEcKVQoCBA8SBo0CAKYCARpHIE5vdGUgdGhh
dCB3ZSB0cnkgdmFyaW91cyBkaWZmZXJlbnQgd2F5cyBvZiBuYW1pbmcgdGhl
IHNhbWUgZXh0ZW5zaW9uLgoKCwoDBA8BEgSNAggdCgsKAwQPBxIEjgICNAoQ
CggEDwek3NIDARIEjgICNAoLCgMEDwcSBI8CAkoKEwoLBA8HpNzSA9vg0wMS
BI8CAkoKCwoDBA8HEgSQAgJPChQKDAQPB6Tc0gPS3tMDARIEkAICTwoLCgME
DwcSBJECAjQKEQoJBA8HpNzSAwQAEgSRAgI0CgsKAwQPBxIEkgICNAoRCgkE
Dwek3NIDBAESBJICAjQKCwoDBA8HEgSTAgIiChAKCAQPB9WP0gMCEgSTAgIi
CgsKAwQPBxIElAICJwoTCgsEDwfVj9ID7/zSAxIElAICJwoLCgMEDwcSBJUC
AiYKEQoJBA8H1Y/SAwEBEgSVAgImCgsKAwQPBxIElgICKgoUCgwEDwfVj9ID
Advg0wMSBJYCAioKCwoDBA8HEgSXAgJBChUKDQQPB9WP0gMB0t7TAwESBJcC
AkEKCwoDBA8HEgSYAgIrChQKDAQPB9WP0gPI9dIDARIEmAICKwoLCgMEDwcS
BJkCAkIKFwoPBA8H1Y/SA8j10gPb4NMDEgSZAgJCCgsKAwQPBxIEmgICRgoY
ChAEDwfVj9IDyPXSA9Le0wMBEgSaAgJGCgsKAwQPBxIEmwICSwoQCggEDweK
9dEDARIEmwICSwoLCgMEDwcSBJwCAikKEQoJBA8H1Y/SAwMBEgScAgIpCgsK
AwQPBxIEnQICMAoRCgkEDwfVj9IDBAASBJ0CAjAKCwoDBA8HEgSeAgIwChEK
CQQPB9WP0gMEARIEngICMAoLCgMEDwcSBJ8CAjIKEAoIBA8H74vSAwESBJ8C
AjIKCwoDBA8HEgSgAgIdChAKCAQPB/CL0gMAEgSgAgIdCgsKAwQPBxIEoQIC
HQoQCggEDwfwi9IDARIEoQICHQoLCgMEDwcSBKICAiYKEAoIBA8H8YvSAwAS
BKICAiYKCwoDBA8HEgSjAgImCkYKCAQPB/GL0gMBEgSjAgImIjRvcHRpb24g
KGNvbXBsZXhfb3B0MykuY29tcGxleG9wdGlvbnR5cGU1LnBsdWdoID0gMjI7
CpcBCgIEEBIGrAIArwIBMogBIC0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLQogRGVmaW5pdGlvbnMgZm9y
IHRlc3RpbmcgYWdncmVnYXRlIG9wdGlvbiBwYXJzaW5nLgogU2VlIGRlc2Ny
aXB0b3JfdW5pdHRlc3QuY2MuCgoLCgMEEAESBKwCCBsKCwoDBBAHEgStAgIp
CgwKBAQQBwESBK0CAikKCwoDBBAFEgSuAgIWCgwKBAQQBQASBK4CDRUKDQoF
BBAFAAESBK4CDQ4KDQoFBBAFAAISBK4CEhUKDAoCBBESBrECALYCAQoLCgME
EQESBLECCCIKDQoDBBEGEgayAgK0AgMKDAoEBBEGABIEswIESQoNCgUEEQYA
AhIEsgIJHAoNCgUEEQYABBIEswIEDAoNCgUEEQYABhIEswINJwoNCgUEEQYA
ARIEswIoPQoNCgUEEQYAAxIEswJASAoMCgQEEQIAEgS1AgIYCg0KBQQRAgAE
EgS1AgIKCg0KBQQRAgAFEgS1AgsRCg0KBQQRAgABEgS1AhITCg0KBQQRAgAD
EgS1AhYXCkMKAgQSEga5AgDIAgEaNSBBIGhlbHBlciB0eXBlIHVzZWQgdG8g
dGVzdCBhZ2dyZWdhdGUgb3B0aW9uIHBhcnNpbmcKCgsKAwQSARIEuQIIEQoM
CgQEEgIAEgS6AgIXCg0KBQQSAgAEEgS6AgIKCg0KBQQSAgAFEgS6AgsQCg0K
BQQSAgABEgS6AhESCg0KBQQSAgADEgS6AhUWCgwKBAQSAgESBLsCAhgKDQoF
BBICAQQSBLsCAgoKDQoFBBICAQUSBLsCCxEKDQoFBBICAQESBLsCEhMKDQoF
BBICAQMSBLsCFhcKHwoEBBICAhIEvgICHRoRIEEgbmVzdGVkIG9iamVjdAoK
DQoFBBICAgQSBL4CAgoKDQoFBBICAgYSBL4CCxQKDQoFBBICAgESBL4CFRgK
DQoFBBICAgMSBL4CGxwKSQoEBBICAxIEwQICMBo7IFRvIHRlc3QgdGhlIHBh
cnNpbmcgb2YgZXh0ZW5zaW9ucyBpbnNpZGUgYWdncmVnYXRlIHZhbHVlcwoK
DQoFBBICAwQSBMECAgoKDQoFBBICAwYSBMECCyYKDQoFBBICAwESBMECJysK
DQoFBBICAwMSBMECLi8KDQoDBBIGEgbCAgLEAgMKDAoEBBIGABIEwwIEKQoN
CgUEEgYAAhIEwgIJJAoNCgUEEgYABBIEwwIEDAoNCgUEEgYABhIEwwINFgoN
CgUEEgYAARIEwwIXHQoNCgUEEgYAAxIEwwIgKAonCgQEEgIEEgTHAgIoGhkg
QW4gZW1iZWRkZWQgbWVzc2FnZSBzZXQKCg0KBQQSAgQEEgTHAgIKCg0KBQQS
AgQGEgTHAgseCg0KBQQSAgQBEgTHAh8jCg0KBQQSAgQDEgTHAiYnCmYKAQcS
BMwCAFUaWyBBbGxvdyBBZ2dyZWdhdGUgdG8gYmUgdXNlZCBhcyBhbiBvcHRp
b24gYXQgYWxsIHBvc3NpYmxlIGxvY2F0aW9ucwogaW4gdGhlIC5wcm90byBn
cmFtbWVyLgoKCgoCByISBMwCKlMKCwoDByICEgTMAgciCgsKAwciBBIEzAIq
MgoLCgMHIgYSBMwCMzwKCwoDByIBEgTMAj1ECgsKAwciAxIEzAJKUgoJCgEH
EgTNAgBVCgoKAgcjEgTNAipTCgsKAwcjAhIEzQIHJQoLCgMHIwQSBM0CKjIK
CwoDByMGEgTNAjM8CgsKAwcjARIEzQI9QwoLCgMHIwMSBM0CSlIKCQoBBxIE
zgIAVQoKCgIHJBIEzgIqUwoLCgMHJAISBM4CByMKCwoDByQEEgTOAioyCgsK
AwckBhIEzgIzPAoLCgMHJAESBM4CPUUKCwoDByQDEgTOAkpSCgkKAQcSBM8C
AFUKCgoCByUSBM8CKlMKCwoDByUCEgTPAgciCgsKAwclBBIEzwIqMgoLCgMH
JQYSBM8CMzwKCwoDByUBEgTPAj1ECgsKAwclAxIEzwJKUgoJCgEHEgTQAgBV
CgoKAgcmEgTQAipTCgsKAwcmAhIE0AIHJwoLCgMHJgQSBNACKjIKCwoDByYG
EgTQAjM8CgsKAwcmARIE0AI9RwoLCgMHJgMSBNACSlIKCQoBBxIE0QIAVQoK
CgIHJxIE0QIqUwoLCgMHJwISBNECByUKCwoDBycEEgTRAioyCgsKAwcnBhIE
0QIzPAoLCgMHJwESBNECPUcKCwoDBycDEgTRAkpSCgkKAQcSBNICAFUKCgoC
BygSBNICKlMKCwoDBygCEgTSAgckCgsKAwcoBBIE0gIqMgoLCgMHKAYSBNIC
MzwKCwoDBygBEgTSAj1GCgsKAwcoAxIE0gJKUgoLCgEIEgbVAgDqAgIKVQoF
CM/dsAcSBtUCAOoCAhpEIFRyeSB1c2luZyBBZ2dyZWdhdGVPcHRpb24gYXQg
ZGlmZmVyZW50IHBvaW50cyBpbiB0aGUgcHJvdG8gZ3JhbW1hcgoKDAoCBBMS
BuwCAO8CAQoLCgMEEwESBOwCCBgKCwoDBBMHEgTtAgI0Cg8KBwQTB5jqsAcS
BO0CAjQKDAoEBBMCABIE7gICRgoNCgUEEwIABBIE7gICCgoNCgUEEwIABRIE
7gILEAoNCgUEEwIAARIE7gIRGgoNCgUEEwIAAxIE7gIdHgoNCgUEEwIACBIE
7gIfRQoRCgkEEwIACJ70sAcSBO4CIEQKDAoCBgESBvECAPYCAQoLCgMGAQES
BPECCBgKCwoDBgEDEgTyAgIyCg8KBwYBA7nvsQcSBPICAjIKDgoEBgECABIG
8wIC9QIDCg0KBQYBAgABEgTzAgYMCg0KBQYBAgACEgTzAg4eCg0KBQYBAgAD
EgTzAik5Cg0KBQYBAgAEEgT0AgQyChEKCQYBAgAEiemyBxIE9AIEMgoMCgIF
ARIG+AIA/AIBCgsKAwUBARIE+AIFEgoLCgMFAQMSBPkCAiwKDwoHBQED0oKx
BxIE+QICLAowCgQFAQIAEgT7AgI5GiIgVE9ETzogc3VwcG9ydCBlbnVtIHZh
bHVlIG9wdGlvbnMKCg0KBQUBAgABEgT7AgIHCg0KBQUBAgACEgT7AgoLCg0K
BQUBAgADEgT7Agw4ChEKCQUBAgADyZ+xBxIE+wINNwo0CgIEFBIG/wIAjAMB
GiYgVGVzdCBjdXN0b20gb3B0aW9ucyBmb3IgbmVzdGVkIHR5cGUuCgoLCgME
FAESBP8CCBgKDgoEBBQDABIGgAMCgwMDCg0KBQQUAwABEgSAAwoXCg0KBQQU
AwAHEgSBAwQhChEKCQQUAwAHnK3YAxIEgQMEIQoOCgYEFAMAAgASBIIDBDoK
DwoHBBQDAAIABBIEggMEDAoPCgcEFAMAAgAFEgSCAw0SCg8KBwQUAwACAAES
BIIDEx8KDwoHBBQDAAIAAxIEggMiIwoPCgcEFAMAAgAIEgSCAyQ5ChMKCwQU
AwACAAiIvNgDEgSCAyU4Cg4KBAQUBAASBoQDAogDAwoNCgUEFAQAARIEhAMH
EQoNCgUEFAQAAxIEhQMEHgoRCgkEFAQAA+ie2QMSBIUDBB4KMgoGBBQEAAIA
EgSHAwQ1GiIgVE9ETzogc3VwcG9ydCBlbnVtIHZhbHVlIG9wdGlvbnMKCg8K
BwQUBAACAAESBIcDBBUKDwoHBBQEAAIAAhIEhwMYGQoPCgcEFAQAAgADEgSH
Axo0ChIKCgQUBAACAAPmoF8SBIcDGzMKDQoDBBQGEgaJAwKLAwMKDAoEBBQG
ABIEigMERAoNCgUEFAYAAhIEiQMJJAoNCgUEFAYABBIEigMEDAoNCgUEFAYA
BRIEigMNEgoNCgUEFAYAARIEigMTIwoNCgUEFAYAAxIEigMmLQoNCgUEFAYA
CBIEigMuQwoRCgkEFAYACLmh2QMSBIoDL0IKbQoCBBUSBpADAJUDARpfIEN1
c3RvbSBtZXNzYWdlIG9wdGlvbiB0aGF0IGhhcyBhIHJlcXVpcmVkIGVudW0g
ZmllbGQuCiBXQVJOSU5HOiB0aGlzIGlzIHN0cm9uZ2x5IGRpc2NvdXJhZ2Vk
IQoKCwoDBBUBEgSQAwgVCg4KBAQVBAASBpEDApMDAwoNCgUEFQQAARIEkQMH
DwoOCgYEFQQAAgASBJIDBBIKDwoHBBUEAAIAARIEkgMEDQoPCgcEFQQAAgAC
EgSSAxARCgwKBAQVAgASBJQDAh4KDQoFBBUCAAQSBJQDAgoKDQoFBBUCAAYS
BJQDCxMKDQoFBBUCAAESBJQDFBkKDQoFBBUCAAMSBJQDHB0KOwoCBBYSBpgD
AJ4DARotIFVwZGF0ZWQgdmVyc2lvbiBvZiB0aGUgY3VzdG9tIG9wdGlvbiBh
Ym92ZS4KCgsKAwQWARIEmAMIFQoOCgQEFgQAEgaZAwKcAwMKDQoFBBYEAAES
BJkDBw8KDgoGBBYEAAIAEgSaAwQSCg8KBwQWBAACAAESBJoDBA0KDwoHBBYE
AAIAAhIEmgMQEQoOCgYEFgQAAgESBJsDBBIKDwoHBBYEAAIBARIEmwMEDQoP
CgcEFgQAAgECEgSbAxARCgwKBAQWAgASBJ0DAh4KDQoFBBYCAAQSBJ0DAgoK
DQoFBBYCAAYSBJ0DCxMKDQoFBBYCAAESBJ0DFBkKDQoFBBYCAAMSBJ0DHB0K
CwoBBxIGoAMAogMBCgoKAgcpEgShAwI3CgsKAwcpAhIEoAMHJQoLCgMHKQQS
BKEDAgoKCwoDBykGEgShAwsYCgsKAwcpARIEoQMZKgoLCgMHKQMSBKEDLTYK
UAoCBBcSBqUDAKcDARpCIFRlc3QgbWVzc2FnZSB1c2luZyB0aGUgInJlcXVp
cmVkX2VudW1fb3B0IiBvcHRpb24gZGVmaW5lZCBhYm92ZS4KCgsKAwQXARIE
pQMIKQoLCgMEFwcSBKYDAjQKDwoHBBcHj83PMhIEpgMCNA==
