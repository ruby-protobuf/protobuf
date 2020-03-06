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
ZBCAgICAAiK3AwoSQ29tcGxleE9wdGlvblR5cGUyEjcKA2JhchgBIAEoCzIl
LnByb3RvYnVmX3VuaXR0ZXN0LkNvbXBsZXhPcHRpb25UeXBlMVIDYmFyEhAK
A2JhehgCIAEoBVIDYmF6EkwKBGZyZWQYAyABKAsyOC5wcm90b2J1Zl91bml0
dGVzdC5Db21wbGV4T3B0aW9uVHlwZTIuQ29tcGxleE9wdGlvblR5cGU0UgRm
cmVkElAKBmJhcm5leRgEIAMoCzI4LnByb3RvYnVmX3VuaXR0ZXN0LkNvbXBs
ZXhPcHRpb25UeXBlMi5Db21wbGV4T3B0aW9uVHlwZTRSBmJhcm5leRqrAQoS
Q29tcGxleE9wdGlvblR5cGU0EhQKBXdhbGRvGAEgASgFUgV3YWxkbzJ/Cgxj
b21wbGV4X29wdDQSHy5nb29nbGUucHJvdG9idWYuTWVzc2FnZU9wdGlvbnMY
ivXRAyABKAsyOC5wcm90b2J1Zl91bml0dGVzdC5Db21wbGV4T3B0aW9uVHlw
ZTIuQ29tcGxleE9wdGlvblR5cGU0Ugtjb21wbGV4T3B0NCoICGQQgICAgAIi
JgoSQ29tcGxleE9wdGlvblR5cGUzEhAKA3F1eBgBIAEoBVIDcXV4Ip8BChVW
YXJpb3VzQ29tcGxleE9wdGlvbnM6hQGi4pUdFAgq2IWeHcQCkvWdHQMI7AYg
YyBYqv2QHUAQ2wf45pcdjgUKEQjnBdiFnh3PD5L1nR0DCNgPwqyXHREI5QXY
hZ4dzg+S9Z0dAwjJEBoDCMECIgIIZSIDCNQB0qiPHQMIsw/63pAdAggJgN+Q
HQGA35AdAorfkB0CCAOK35AdAggEIiMKE0FnZ3JlZ2F0ZU1lc3NhZ2VTZXQq
CAgEEICAgIACOgIIACK5AQoaQWdncmVnYXRlTWVzc2FnZVNldEVsZW1lbnQS
DAoBcxgBIAEoCVIBczKMAQoVbWVzc2FnZV9zZXRfZXh0ZW5zaW9uEiYucHJv
dG9idWZfdW5pdHRlc3QuQWdncmVnYXRlTWVzc2FnZVNldBj2664HIAEoCzIt
LnByb3RvYnVmX3VuaXR0ZXN0LkFnZ3JlZ2F0ZU1lc3NhZ2VTZXRFbGVtZW50
UhNtZXNzYWdlU2V0RXh0ZW5zaW9uIpwCCglBZ2dyZWdhdGUSDAoBaRgBIAEo
BVIBaRIMCgFzGAIgASgJUgFzEi4KA3N1YhgDIAEoCzIcLnByb3RvYnVmX3Vu
aXR0ZXN0LkFnZ3JlZ2F0ZVIDc3ViEjAKBGZpbGUYBCABKAsyHC5nb29nbGUu
cHJvdG9idWYuRmlsZU9wdGlvbnNSBGZpbGUSOgoEbXNldBgFIAEoCzImLnBy
b3RvYnVmX3VuaXR0ZXN0LkFnZ3JlZ2F0ZU1lc3NhZ2VTZXRSBG1zZXQyVQoG
bmVzdGVkEhwuZ29vZ2xlLnByb3RvYnVmLkZpbGVPcHRpb25zGKfRsAcgASgL
MhwucHJvdG9idWZfdW5pdHRlc3QuQWdncmVnYXRlUgZuZXN0ZWQiZAoQQWdn
cmVnYXRlTWVzc2FnZRI0CglmaWVsZG5hbWUYASABKAVCFvKhhzsREg9GaWVs
ZEFubm90YXRpb25SCWZpZWxkbmFtZToawtGGOxUIZRIRTWVzc2FnZUFubm90
YXRpb24i5wEKEE5lc3RlZE9wdGlvblR5cGUaSAoNTmVzdGVkTWVzc2FnZRIv
CgxuZXN0ZWRfZmllbGQYASABKAVCDMHgwx3qAwAAAAAAAFILbmVzdGVkRmll
bGQ6BuDpwh3pByI1CgpOZXN0ZWRFbnVtEh0KEU5FU1RFRF9FTlVNX1ZBTFVF
EAEaBrCG+gXsBxoIxfbJHesDAAAyUgoQbmVzdGVkX2V4dGVuc2lvbhIcLmdv
b2dsZS5wcm90b2J1Zi5GaWxlT3B0aW9ucxj9+OIDIAEoBUIGyIvKHe0HUg9u
ZXN0ZWRFeHRlbnNpb24iawoNT2xkT3B0aW9uVHlwZRI/CgV2YWx1ZRgBIAIo
DjIpLnByb3RvYnVmX3VuaXR0ZXN0Lk9sZE9wdGlvblR5cGUuVGVzdEVudW1S
BXZhbHVlIhkKCFRlc3RFbnVtEg0KCU9MRF9WQUxVRRAAInoKDU5ld09wdGlv
blR5cGUSPwoFdmFsdWUYASACKA4yKS5wcm90b2J1Zl91bml0dGVzdC5OZXdP
cHRpb25UeXBlLlRlc3RFbnVtUgV2YWx1ZSIoCghUZXN0RW51bRINCglPTERf
VkFMVUUQABINCglORVdfVkFMVUUQASItCiFUZXN0TWVzc2FnZVdpdGhSZXF1
aXJlZEVudW1PcHRpb246CPro/JQDAggAKjYKCk1ldGhvZE9wdDESEwoPTUVU
SE9ET1BUMV9WQUwxEAESEwoPTUVUSE9ET1BUMV9WQUwyEAIqTQoNQWdncmVn
YXRlRW51bRIlCgVWQUxVRRABGhrK/Ik7FRITRW51bVZhbHVlQW5ub3RhdGlv
bhoVkpWIOxASDkVudW1Bbm5vdGF0aW9uMo4BChxUZXN0U2VydmljZVdpdGhD
dXN0b21PcHRpb25zEmMKA0ZvbxIpLnByb3RvYnVmX3VuaXR0ZXN0LkN1c3Rv
bU9wdGlvbkZvb1JlcXVlc3QaKi5wcm90b2J1Zl91bml0dGVzdC5DdXN0b21P
cHRpb25Gb29SZXNwb25zZSIF4PqMHgIaCZCyix7T24DLSTKZAQoQQWdncmVn
YXRlU2VydmljZRJrCgZNZXRob2QSIy5wcm90b2J1Zl91bml0dGVzdC5BZ2dy
ZWdhdGVNZXNzYWdlGiMucHJvdG9idWZfdW5pdHRlc3QuQWdncmVnYXRlTWVz
c2FnZSIXysiWOxISEE1ldGhvZEFubm90YXRpb24aGMr7jjsTEhFTZXJ2aWNl
QW5ub3RhdGlvbjo8CglmaWxlX29wdDESHC5nb29nbGUucHJvdG9idWYuRmls
ZU9wdGlvbnMYjp3YAyABKARSCGZpbGVPcHQxOkUKDG1lc3NhZ2Vfb3B0MRIf
Lmdvb2dsZS5wcm90b2J1Zi5NZXNzYWdlT3B0aW9ucxicrdgDIAEoBVILbWVz
c2FnZU9wdDE6PwoKZmllbGRfb3B0MRIdLmdvb2dsZS5wcm90b2J1Zi5GaWVs
ZE9wdGlvbnMYiLzYAyABKAZSCWZpZWxkT3B0MTpDCgpmaWVsZF9vcHQyEh0u
Z29vZ2xlLnByb3RvYnVmLkZpZWxkT3B0aW9ucxi5odkDIAEoBToCNDJSCWZp
ZWxkT3B0Mjo8CgllbnVtX29wdDESHC5nb29nbGUucHJvdG9idWYuRW51bU9w
dGlvbnMY6J7ZAyABKA9SCGVudW1PcHQxOksKD2VudW1fdmFsdWVfb3B0MRIh
Lmdvb2dsZS5wcm90b2J1Zi5FbnVtVmFsdWVPcHRpb25zGOagXyABKAVSDWVu
dW1WYWx1ZU9wdDE6RQoMc2VydmljZV9vcHQxEh8uZ29vZ2xlLnByb3RvYnVm
LlNlcnZpY2VPcHRpb25zGKK24QMgASgSUgtzZXJ2aWNlT3B0MTphCgttZXRo
b2Rfb3B0MRIeLmdvb2dsZS5wcm90b2J1Zi5NZXRob2RPcHRpb25zGKzP4QMg
ASgOMh0ucHJvdG9idWZfdW5pdHRlc3QuTWV0aG9kT3B0MVIKbWV0aG9kT3B0
MTo9Cghib29sX29wdBIfLmdvb2dsZS5wcm90b2J1Zi5NZXNzYWdlT3B0aW9u
cxjqq9YDIAEoCFIHYm9vbE9wdDo/CglpbnQzMl9vcHQSHy5nb29nbGUucHJv
dG9idWYuTWVzc2FnZU9wdGlvbnMY7ajWAyABKAVSCGludDMyT3B0Oj8KCWlu
dDY0X29wdBIfLmdvb2dsZS5wcm90b2J1Zi5NZXNzYWdlT3B0aW9ucxjGp9YD
IAEoA1IIaW50NjRPcHQ6QQoKdWludDMyX29wdBIfLmdvb2dsZS5wcm90b2J1
Zi5NZXNzYWdlT3B0aW9ucxiwotYDIAEoDVIJdWludDMyT3B0OkEKCnVpbnQ2
NF9vcHQSHy5nb29nbGUucHJvdG9idWYuTWVzc2FnZU9wdGlvbnMY347WAyAB
KARSCXVpbnQ2NE9wdDpBCgpzaW50MzJfb3B0Eh8uZ29vZ2xlLnByb3RvYnVm
Lk1lc3NhZ2VPcHRpb25zGMCI1gMgASgRUglzaW50MzJPcHQ6QQoKc2ludDY0
X29wdBIfLmdvb2dsZS5wcm90b2J1Zi5NZXNzYWdlT3B0aW9ucxj/gtYDIAEo
ElIJc2ludDY0T3B0OkMKC2ZpeGVkMzJfb3B0Eh8uZ29vZ2xlLnByb3RvYnVm
Lk1lc3NhZ2VPcHRpb25zGNP+1QMgASgHUgpmaXhlZDMyT3B0OkMKC2ZpeGVk
NjRfb3B0Eh8uZ29vZ2xlLnByb3RvYnVmLk1lc3NhZ2VPcHRpb25zGOL91QMg
ASgGUgpmaXhlZDY0T3B0OkUKDHNmaXhlZDMyX29wdBIfLmdvb2dsZS5wcm90
b2J1Zi5NZXNzYWdlT3B0aW9ucxjV8dUDIAEoD1ILc2ZpeGVkMzJPcHQ6RQoM
c2ZpeGVkNjRfb3B0Eh8uZ29vZ2xlLnByb3RvYnVmLk1lc3NhZ2VPcHRpb25z
GOOK1QMgASgQUgtzZml4ZWQ2NE9wdDo/CglmbG9hdF9vcHQSHy5nb29nbGUu
cHJvdG9idWYuTWVzc2FnZU9wdGlvbnMY/rvUAyABKAJSCGZsb2F0T3B0OkEK
CmRvdWJsZV9vcHQSHy5nb29nbGUucHJvdG9idWYuTWVzc2FnZU9wdGlvbnMY
zavUAyABKAFSCWRvdWJsZU9wdDpBCgpzdHJpbmdfb3B0Eh8uZ29vZ2xlLnBy
b3RvYnVmLk1lc3NhZ2VPcHRpb25zGMWr1AMgASgJUglzdHJpbmdPcHQ6PwoJ
Ynl0ZXNfb3B0Eh8uZ29vZ2xlLnByb3RvYnVmLk1lc3NhZ2VPcHRpb25zGJar
1AMgASgMUghieXRlc09wdDp5CghlbnVtX29wdBIfLmdvb2dsZS5wcm90b2J1
Zi5NZXNzYWdlT3B0aW9ucxiRq9QDIAEoDjI6LnByb3RvYnVmX3VuaXR0ZXN0
LkR1bW15TWVzc2FnZUNvbnRhaW5pbmdFbnVtLlRlc3RFbnVtVHlwZVIHZW51
bU9wdDqAAQoQbWVzc2FnZV90eXBlX29wdBIfLmdvb2dsZS5wcm90b2J1Zi5N
ZXNzYWdlT3B0aW9ucxiv8tMDIAEoCzIyLnByb3RvYnVmX3VuaXR0ZXN0LkR1
bW15TWVzc2FnZUludmFsaWRBc09wdGlvblR5cGVSDm1lc3NhZ2VUeXBlT3B0
OjwKBHF1dXgSJS5wcm90b2J1Zl91bml0dGVzdC5Db21wbGV4T3B0aW9uVHlw
ZTEY2+DTAyABKAVSBHF1dXg6ZQoFY29yZ2USJS5wcm90b2J1Zl91bml0dGVz
dC5Db21wbGV4T3B0aW9uVHlwZTEY0t7TAyABKAsyJS5wcm90b2J1Zl91bml0
dGVzdC5Db21wbGV4T3B0aW9uVHlwZTNSBWNvcmdlOkAKBmdyYXVsdBIlLnBy
b3RvYnVmX3VuaXR0ZXN0LkNvbXBsZXhPcHRpb25UeXBlMhjv/NIDIAEoBVIG
Z3JhdWx0OmcKBmdhcnBseRIlLnByb3RvYnVmX3VuaXR0ZXN0LkNvbXBsZXhP
cHRpb25UeXBlMhjI9dIDIAEoCzIlLnByb3RvYnVmX3VuaXR0ZXN0LkNvbXBs
ZXhPcHRpb25UeXBlMVIGZ2FycGx5OmwKDGNvbXBsZXhfb3B0MRIfLmdvb2ds
ZS5wcm90b2J1Zi5NZXNzYWdlT3B0aW9ucxik3NIDIAEoCzIlLnByb3RvYnVm
X3VuaXR0ZXN0LkNvbXBsZXhPcHRpb25UeXBlMVILY29tcGxleE9wdDE6bAoM
Y29tcGxleF9vcHQyEh8uZ29vZ2xlLnByb3RvYnVmLk1lc3NhZ2VPcHRpb25z
GNWP0gMgASgLMiUucHJvdG9idWZfdW5pdHRlc3QuQ29tcGxleE9wdGlvblR5
cGUyUgtjb21wbGV4T3B0MjpsCgxjb21wbGV4X29wdDMSHy5nb29nbGUucHJv
dG9idWYuTWVzc2FnZU9wdGlvbnMY74vSAyABKAsyJS5wcm90b2J1Zl91bml0
dGVzdC5Db21wbGV4T3B0aW9uVHlwZTNSC2NvbXBsZXhPcHQzOkcKDXJlcGVh
dGVkX29wdDESHy5nb29nbGUucHJvdG9idWYuTWVzc2FnZU9wdGlvbnMY8IvS
AyADKAVSDHJlcGVhdGVkT3B0MTpuCg1yZXBlYXRlZF9vcHQyEh8uZ29vZ2xl
LnByb3RvYnVmLk1lc3NhZ2VPcHRpb25zGPGL0gMgAygLMiUucHJvdG9idWZf
dW5pdHRlc3QuQ29tcGxleE9wdGlvblR5cGUzUgxyZXBlYXRlZE9wdDI6VwoH
ZmlsZW9wdBIcLmdvb2dsZS5wcm90b2J1Zi5GaWxlT3B0aW9ucxjP3bAHIAEo
CzIcLnByb3RvYnVmX3VuaXR0ZXN0LkFnZ3JlZ2F0ZVIHZmlsZW9wdDpYCgZt
c2dvcHQSHy5nb29nbGUucHJvdG9idWYuTWVzc2FnZU9wdGlvbnMYmOqwByAB
KAsyHC5wcm90b2J1Zl91bml0dGVzdC5BZ2dyZWdhdGVSBm1zZ29wdDpaCghm
aWVsZG9wdBIdLmdvb2dsZS5wcm90b2J1Zi5GaWVsZE9wdGlvbnMYnvSwByAB
KAsyHC5wcm90b2J1Zl91bml0dGVzdC5BZ2dyZWdhdGVSCGZpZWxkb3B0OlcK
B2VudW1vcHQSHC5nb29nbGUucHJvdG9idWYuRW51bU9wdGlvbnMY0oKxByAB
KAsyHC5wcm90b2J1Zl91bml0dGVzdC5BZ2dyZWdhdGVSB2VudW1vcHQ6YgoK
ZW51bXZhbG9wdBIhLmdvb2dsZS5wcm90b2J1Zi5FbnVtVmFsdWVPcHRpb25z
GMmfsQcgASgLMhwucHJvdG9idWZfdW5pdHRlc3QuQWdncmVnYXRlUgplbnVt
dmFsb3B0OmAKCnNlcnZpY2VvcHQSHy5nb29nbGUucHJvdG9idWYuU2Vydmlj
ZU9wdGlvbnMYue+xByABKAsyHC5wcm90b2J1Zl91bml0dGVzdC5BZ2dyZWdh
dGVSCnNlcnZpY2VvcHQ6XQoJbWV0aG9kb3B0Eh4uZ29vZ2xlLnByb3RvYnVm
Lk1ldGhvZE9wdGlvbnMYiemyByABKAsyHC5wcm90b2J1Zl91bml0dGVzdC5B
Z2dyZWdhdGVSCW1ldGhvZG9wdDpwChFyZXF1aXJlZF9lbnVtX29wdBIfLmdv
b2dsZS5wcm90b2J1Zi5NZXNzYWdlT3B0aW9ucxiPzc8yIAEoCzIgLnByb3Rv
YnVmX3VuaXR0ZXN0Lk9sZE9wdGlvblR5cGVSD3JlcXVpcmVkRW51bU9wdEKD
AYABAYgBAZABAfDowR3qrcDlJPrshTtsCGQSDkZpbGVBbm5vdGF0aW9uGhYS
FE5lc3RlZEZpbGVBbm5vdGF0aW9uIh767IU7GRIXRmlsZUV4dGVuc2lvbkFu
bm90YXRpb24qILLf9jobChlFbWJlZGRlZE1lc3NhZ2VTZXRFbGVtZW50Sphp
CgcSBSQApwMBCqIOCgEMEgMkABIywQwgUHJvdG9jb2wgQnVmZmVycyAtIEdv
b2dsZSdzIGRhdGEgaW50ZXJjaGFuZ2UgZm9ybWF0CiBDb3B5cmlnaHQgMjAw
OCBHb29nbGUgSW5jLiAgQWxsIHJpZ2h0cyByZXNlcnZlZC4KIGh0dHBzOi8v
ZGV2ZWxvcGVycy5nb29nbGUuY29tL3Byb3RvY29sLWJ1ZmZlcnMvCgogUmVk
aXN0cmlidXRpb24gYW5kIHVzZSBpbiBzb3VyY2UgYW5kIGJpbmFyeSBmb3Jt
cywgd2l0aCBvciB3aXRob3V0CiBtb2RpZmljYXRpb24sIGFyZSBwZXJtaXR0
ZWQgcHJvdmlkZWQgdGhhdCB0aGUgZm9sbG93aW5nIGNvbmRpdGlvbnMgYXJl
CiBtZXQ6CgogICAgICogUmVkaXN0cmlidXRpb25zIG9mIHNvdXJjZSBjb2Rl
IG11c3QgcmV0YWluIHRoZSBhYm92ZSBjb3B5cmlnaHQKIG5vdGljZSwgdGhp
cyBsaXN0IG9mIGNvbmRpdGlvbnMgYW5kIHRoZSBmb2xsb3dpbmcgZGlzY2xh
aW1lci4KICAgICAqIFJlZGlzdHJpYnV0aW9ucyBpbiBiaW5hcnkgZm9ybSBt
dXN0IHJlcHJvZHVjZSB0aGUgYWJvdmUKIGNvcHlyaWdodCBub3RpY2UsIHRo
aXMgbGlzdCBvZiBjb25kaXRpb25zIGFuZCB0aGUgZm9sbG93aW5nIGRpc2Ns
YWltZXIKIGluIHRoZSBkb2N1bWVudGF0aW9uIGFuZC9vciBvdGhlciBtYXRl
cmlhbHMgcHJvdmlkZWQgd2l0aCB0aGUKIGRpc3RyaWJ1dGlvbi4KICAgICAq
IE5laXRoZXIgdGhlIG5hbWUgb2YgR29vZ2xlIEluYy4gbm9yIHRoZSBuYW1l
cyBvZiBpdHMKIGNvbnRyaWJ1dG9ycyBtYXkgYmUgdXNlZCB0byBlbmRvcnNl
IG9yIHByb21vdGUgcHJvZHVjdHMgZGVyaXZlZCBmcm9tCiB0aGlzIHNvZnR3
YXJlIHdpdGhvdXQgc3BlY2lmaWMgcHJpb3Igd3JpdHRlbiBwZXJtaXNzaW9u
LgoKIFRISVMgU09GVFdBUkUgSVMgUFJPVklERUQgQlkgVEhFIENPUFlSSUdI
VCBIT0xERVJTIEFORCBDT05UUklCVVRPUlMKICJBUyBJUyIgQU5EIEFOWSBF
WFBSRVNTIE9SIElNUExJRUQgV0FSUkFOVElFUywgSU5DTFVESU5HLCBCVVQg
Tk9UCiBMSU1JVEVEIFRPLCBUSEUgSU1QTElFRCBXQVJSQU5USUVTIE9GIE1F
UkNIQU5UQUJJTElUWSBBTkQgRklUTkVTUyBGT1IKIEEgUEFSVElDVUxBUiBQ
VVJQT1NFIEFSRSBESVNDTEFJTUVELiBJTiBOTyBFVkVOVCBTSEFMTCBUSEUg
Q09QWVJJR0hUCiBPV05FUiBPUiBDT05UUklCVVRPUlMgQkUgTElBQkxFIEZP
UiBBTlkgRElSRUNULCBJTkRJUkVDVCwgSU5DSURFTlRBTCwKIFNQRUNJQUws
IEVYRU1QTEFSWSwgT1IgQ09OU0VRVUVOVElBTCBEQU1BR0VTIChJTkNMVURJ
TkcsIEJVVCBOT1QKIExJTUlURUQgVE8sIFBST0NVUkVNRU5UIE9GIFNVQlNU
SVRVVEUgR09PRFMgT1IgU0VSVklDRVM7IExPU1MgT0YgVVNFLAogREFUQSwg
T1IgUFJPRklUUzsgT1IgQlVTSU5FU1MgSU5URVJSVVBUSU9OKSBIT1dFVkVS
IENBVVNFRCBBTkQgT04gQU5ZCiBUSEVPUlkgT0YgTElBQklMSVRZLCBXSEVU
SEVSIElOIENPTlRSQUNULCBTVFJJQ1QgTElBQklMSVRZLCBPUiBUT1JUCiAo
SU5DTFVESU5HIE5FR0xJR0VOQ0UgT1IgT1RIRVJXSVNFKSBBUklTSU5HIElO
IEFOWSBXQVkgT1VUIE9GIFRIRSBVU0UKIE9GIFRISVMgU09GVFdBUkUsIEVW
RU4gSUYgQURWSVNFRCBPRiBUSEUgUE9TU0lCSUxJVFkgT0YgU1VDSCBEQU1B
R0UuCjLTASBBdXRob3I6IGJlbmp5QGdvb2dsZS5jb20gKEJlbmp5IFdlaW5i
ZXJnZXIpCiAgQmFzZWQgb24gb3JpZ2luYWwgUHJvdG9jb2wgQnVmZmVycyBk
ZXNpZ24gYnkKICBTYW5qYXkgR2hlbWF3YXQsIEplZmYgRGVhbiwgYW5kIG90
aGVycy4KCiBBIHByb3RvIGZpbGUgdXNlZCB0byB0ZXN0IHRoZSAiY3VzdG9t
IG9wdGlvbnMiIGZlYXR1cmUgb2YgZ29vZ2xlLnByb3RvYnVmLgoKCAoBCBID
KAAiCoABCgIIEBIDKAAiGmcgU29tZSBnZW5lcmljX3NlcnZpY2VzIG9wdGlv
bihzKSBhZGRlZCBhdXRvbWF0aWNhbGx5LgogU2VlOiAgaHR0cDovL2dvL3By
b3RvMi1nZW5lcmljLXNlcnZpY2VzLWRlZmF1bHQKIgwgYXV0by1hZGRlZAoK
CAoBCBIDKQAkChcKAggREgMpACQiDCBhdXRvLWFkZGVkCgoICgEIEgMqACIK
CQoCCBISAyoAIgoICgEIEgMtACAKNQoFCI6d2AMSAy0AIBonIEEgY3VzdG9t
IGZpbGUgb3B0aW9uIChkZWZpbmVkIGJlbG93KS4KCgkKAgMAEgMvACoKoAEK
AQISAzMAGhqVASBXZSBkb24ndCBwdXQgdGhpcyBpbiBhIHBhY2thZ2Ugd2l0
aGluIHByb3RvMiBiZWNhdXNlIHdlIG5lZWQgdG8gbWFrZSBzdXJlCiB0aGF0
IHRoZSBnZW5lcmF0ZWQgY29kZSBkb2Vzbid0IGRlcGVuZCBvbiBiZWluZyBp
biB0aGUgcHJvdG8yIG5hbWVzcGFjZS4KCj4KAQcSBDgAOgEyMyBTb21lIHNp
bXBsZSB0ZXN0IGN1c3RvbSBvcHRpb25zIG9mIHZhcmlvdXMgdHlwZXMuCgoJ
CgIHABIDOQImCgoKAwcAAhIDOAciCgoKAwcABBIDOQIKCgoKAwcABRIDOQsR
CgoKAwcAARIDORIbCgoKAwcAAxIDOR4lCgkKAQcSBDwAPgEKCQoCBwESAz0C
KAoKCgMHAQISAzwHJQoKCgMHAQQSAz0CCgoKCgMHAQUSAz0LEAoKCgMHAQES
Az0RHQoKCgMHAQMSAz0gJwoJCgEHEgRAAEUBCgkKAgcCEgNBAigKCgoDBwIC
EgNAByMKCgoDBwIEEgNBAgoKCgoDBwIFEgNBCxIKCgoDBwIBEgNBEx0KCgoD
BwIDEgNBICcKaQoCBwMSA0QCMxpeIFRoaXMgaXMgdXNlZnVsIGZvciB0ZXN0
aW5nIHRoYXQgd2UgY29ycmVjdGx5IHJlZ2lzdGVyIGRlZmF1bHQgdmFsdWVz
IGZvcgogZXh0ZW5zaW9uIG9wdGlvbnMuCgoKCgMHAwISA0AHIwoKCgMHAwQS
A0QCCgoKCgMHAwUSA0QLEAoKCgMHAwESA0QRGwoKCgMHAwMSA0QeJQoKCgMH
AwgSA0QmMgoKCgMHAwcSA0QvMQoJCgEHEgRHAEkBCgkKAgcEEgNIAigKCgoD
BwQCEgNHByIKCgoDBwQEEgNIAgoKCgoDBwQFEgNICxMKCgoDBwQBEgNIFB0K
CgoDBwQDEgNIICcKCQoBBxIESwBNAQoJCgIHBRIDTAIrCgoKAwcFAhIDSwcn
CgoKAwcFBBIDTAIKCgoKAwcFBRIDTAsQCgoKAwcFARIDTBEgCgoKAwcFAxID
TCMqCgkKAQcSBE8AUQEKCQoCBwYSA1ACKQoKCgMHBgISA08HJQoKCgMHBgQS
A1ACCgoKCgMHBgUSA1ALEQoKCgMHBgESA1ASHgoKCgMHBgMSA1AhKAoKCgIF
ABIEUwBWAQoKCgMFAAESA1MFDwoLCgQFAAIAEgNUAhYKDAoFBQACAAESA1QC
EQoMCgUFAAIAAhIDVBQVCgsKBAUAAgESA1UCFgoMCgUFAAIBARIDVQIRCgwK
BQUAAgECEgNVFBUKCQoBBxIEWABaAQoJCgIHBxIDWQIsCgoKAwcHAhIDWAck
CgoKAwcHBBIDWQIKCgoKAwcHBhIDWQsVCgoKAwcHARIDWRYhCgoKAwcHAxID
WSQrCpABCgIEABIEXgBsARqDASBBIHRlc3QgbWVzc2FnZSB3aXRoIGN1c3Rv
bSBvcHRpb25zIGF0IGFsbCBwb3NzaWJsZSBsb2NhdGlvbnMgKGFuZCBhbHNv
IHNvbWUKIHJlZ3VsYXIgb3B0aW9ucywgdG8gbWFrZSBzdXJlIHRoZXkgaW50
ZXJhY3QgbmljZWx5KS4KCgoKAwQAARIDXggkCgoKAwQABxIDXwIpCgsKBAQA
BwESA18CKQoKCgMEAAcSA2ECHgoOCgcEAAecrdgDEgNhAh4KDAoEBAACABIE
YwJkNwoMCgUEAAIABBIDYwIKCgwKBQQAAgAFEgNjCxEKDAoFBAACAAESA2MS
GAoMCgUEAAIAAxIDYxscCg0KBQQAAgAIEgRjHWQ2Cg0KBgQAAgAIARIDYx4o
ChAKCQQAAgAIiLzYAxIDZB41CgwKBAQABAASBGYCawMKDAoFBAAEAAESA2YH
DQoMCgUEAAQAAxIDZwQeChAKCQQABAAD6J7ZAxIDZwQeCg0KBgQABAACABID
aQQUCg4KBwQABAACAAESA2kEDwoOCgcEAAQAAgACEgNpEhMKDQoGBAAEAAIB
EgNqBC4KDgoHBAAEAAIBARIDagQPCg4KBwQABAACAQISA2oSEwoOCgcEAAQA
AgEDEgNqFC0KEQoKBAAEAAIBA+agXxIDahUsCpQBCgIEARIEcQByARqHASBB
IHRlc3QgUlBDIHNlcnZpY2Ugd2l0aCBjdXN0b20gb3B0aW9ucyBhdCBhbGwg
cG9zc2libGUgbG9jYXRpb25zIChhbmQgYWxzbwogc29tZSByZWd1bGFyIG9w
dGlvbnMsIHRvIG1ha2Ugc3VyZSB0aGV5IGludGVyYWN0IG5pY2VseSkuCgoK
CgMEAQESA3EIHgoKCgIEAhIEdAB1AQoKCgMEAgESA3QIHwoKCgIEAxIEdwB4
AQoKCgMEAwESA3cIJAoKCgIEBBIEegB7AQoKCgMEBAESA3oIJAoLCgIGABIF
fQCDAQEKCgoDBgABEgN9CCQKCgoDBgADEgN+AiYKDgoHBgADorbhAxIDfgIm
Cg4KBAYAAgASBoABAoIBAwoNCgUGAAIAARIEgAEGCQoNCgUGAAIAAhIEgAEK
IAoNCgUGAAIAAxIEgAErQgoNCgUGAAIABBIEgQEEKwoRCgkGAAIABKzP4QMS
BIEBBCsKWwoCBAUSBokBAI4BATJNIE9wdGlvbnMgb2YgZXZlcnkgcG9zc2li
bGUgZmllbGQgdHlwZSwgc28gd2UgY2FuIHRlc3QgdGhlbSBhbGwgZXhoYXVz
dGl2ZWx5LgoKCwoDBAUBEgSJAQgiCg4KBAQFBAASBooBAo0BAwoNCgUEBQQA
ARIEigEHEwoOCgYEBQQAAgASBIsBBCAKDwoHBAUEAAIAARIEiwEEGgoPCgcE
BQQAAgACEgSLAR0fCg4KBgQFBAACARIEjAEEIQoPCgcEBQQAAgEBEgSMAQQa
Cg8KBwQFBAACAQISBIwBHSAKDAoCBAYSBpABAJEBAQoLCgMEBgESBJABCCcK
CwoBBxIGkwEApQEBCgoKAgcIEgSUAQIvCgsKAwcIAhIEkwEHJQoLCgMHCAQS
BJQBAgoKCwoDBwgFEgSUARMXCgsKAwcIARIElAEcJAoLCgMHCAMSBJQBJy4K
CgoCBwkSBJUBAi8KCwoDBwkCEgSTAQclCgsKAwcJBBIElQECCgoLCgMHCQUS
BJUBEhcKCwoDBwkBEgSVARskCgsKAwcJAxIElQEnLgoKCgIHChIElgECLwoL
CgMHCgISBJMBByUKCwoDBwoEEgSWAQIKCgsKAwcKBRIElgESFwoLCgMHCgES
BJYBGyQKCwoDBwoDEgSWAScuCgoKAgcLEgSXAQIvCgsKAwcLAhIEkwEHJQoL
CgMHCwQSBJcBAgoKCwoDBwsFEgSXAREXCgsKAwcLARIElwEaJAoLCgMHCwMS
BJcBJy4KCgoCBwwSBJgBAi8KCwoDBwwCEgSTAQclCgsKAwcMBBIEmAECCgoL
CgMHDAUSBJgBERcKCwoDBwwBEgSYARokCgsKAwcMAxIEmAEnLgoKCgIHDRIE
mQECLwoLCgMHDQISBJMBByUKCwoDBw0EEgSZAQIKCgsKAwcNBRIEmQERFwoL
CgMHDQESBJkBGiQKCwoDBw0DEgSZAScuCgoKAgcOEgSaAQIvCgsKAwcOAhIE
kwEHJQoLCgMHDgQSBJoBAgoKCwoDBw4FEgSaAREXCgsKAwcOARIEmgEaJAoL
CgMHDgMSBJoBJy4KCgoCBw8SBJsBAi8KCwoDBw8CEgSTAQclCgsKAwcPBBIE
mwECCgoLCgMHDwUSBJsBEBcKCwoDBw8BEgSbARkkCgsKAwcPAxIEmwEnLgoK
CgIHEBIEnAECLwoLCgMHEAISBJMBByUKCwoDBxAEEgScAQIKCgsKAwcQBRIE
nAEQFwoLCgMHEAESBJwBGSQKCwoDBxADEgScAScuCgoKAgcREgSdAQIvCgsK
AwcRAhIEkwEHJQoLCgMHEQQSBJ0BAgoKCwoDBxEFEgSdAQ8XCgsKAwcRARIE
nQEYJAoLCgMHEQMSBJ0BJy4KCgoCBxISBJ4BAi8KCwoDBxICEgSTAQclCgsK
AwcSBBIEngECCgoLCgMHEgUSBJ4BDxcKCwoDBxIBEgSeARgkCgsKAwcSAxIE
ngEnLgoKCgIHExIEnwECLwoLCgMHEwISBJMBByUKCwoDBxMEEgSfAQIKCgsK
AwcTBRIEnwESFwoLCgMHEwESBJ8BGyQKCwoDBxMDEgSfAScuCgoKAgcUEgSg
AQIvCgsKAwcUAhIEkwEHJQoLCgMHFAQSBKABAgoKCwoDBxQFEgSgAREXCgsK
AwcUARIEoAEaJAoLCgMHFAMSBKABJy4KCgoCBxUSBKEBAi8KCwoDBxUCEgST
AQclCgsKAwcVBBIEoQECCgoLCgMHFQUSBKEBERcKCwoDBxUBEgShARokCgsK
AwcVAxIEoQEnLgoKCgIHFhIEogECLwoLCgMHFgISBJMBByUKCwoDBxYEEgSi
AQIKCgsKAwcWBRIEogESFwoLCgMHFgESBKIBGyQKCwoDBxYDEgSiAScuCgoK
AgcXEgSjAQJGCgsKAwcXAhIEkwEHJQoLCgMHFwQSBKMBAgoKCwoDBxcGEgSj
AQsyCgsKAwcXARIEowEzOwoLCgMHFwMSBKMBPkUKCgoCBxgSBKQBAkYKCwoD
BxgCEgSTAQclCgsKAwcYBBIEpAECCgoLCgMHGAYSBKQBCyoKCwoDBxgBEgSk
ASs7CgsKAwcYAxIEpAE+RQoMCgIEBxIGpwEAswEBCgsKAwQHARIEpwEIJAoL
CgMEBwcSBKgBAiAKDwoHBAcH6qvWAxIEqAECIAoLCgMEBwcSBKkBAiYKDwoH
BAcH7ajWAxIEqQECJgoLCgMEBwcSBKoBAi4KDwoHBAcHxqfWAxIEqgECLgoL
CgMEBwcSBKsBAhwKDwoHBAcHsKLWAxIEqwECHAoLCgMEBwcSBKwBAhwKDwoH
BAcH347WAxIErAECHAoLCgMEBwcSBK0BAiYKDwoHBAcHwIjWAxIErQECJgoL
CgMEBwcSBK4BAi4KDwoHBAcH/4LWAxIErgECLgoLCgMEBwcSBK8BAhwKDwoH
BAcH0/7VAxIErwECHAoLCgMEBwcSBLABAhwKDwoHBAcH4v3VAxIEsAECHAoL
CgMEBwcSBLEBAiYKDwoHBAcH1fHVAxIEsQECJgoLCgMEBwcSBLIBAi4KDwoH
BAcH44rVAxIEsgECLgoMCgIECBIGtQEAwQEBCgsKAwQIARIEtQEIJAoLCgME
CAcSBLYBAh8KDwoHBAgH6qvWAxIEtgECHwoLCgMECAcSBLcBAiUKDwoHBAgH
7ajWAxIEtwECJQoLCgMECAcSBLgBAi0KDwoHBAgHxqfWAxIEuAECLQoLCgME
CAcSBLkBAiUKDwoHBAgHsKLWAxIEuQECJQoLCgMECAcSBLoBAi0KDwoHBAgH
347WAxIEugECLQoLCgMECAcSBLsBAiUKDwoHBAgHwIjWAxIEuwECJQoLCgME
CAcSBLwBAi0KDwoHBAgH/4LWAxIEvAECLQoLCgMECAcSBL0BAiUKDwoHBAgH
0/7VAxIEvQECJQoLCgMECAcSBL4BAi0KDwoHBAgH4v3VAxIEvgECLQoLCgME
CAcSBL8BAiUKDwoHBAgH1fHVAxIEvwECJQoLCgMECAcSBMABAi0KDwoHBAgH
44rVAxIEwAECLQoMCgIECRIGwwEAygEBCgsKAwQJARIEwwEIHwoLCgMECQcS
BMQBAh0KKgoHBAkH7ajWAxIExAECHSIZIFRvIHRlc3Qgc2lnbi1leHRlbnNp
b24uCgoLCgMECQcSBMUBAiMKDwoHBAkH/rvUAxIExQECIwoLCgMECQcSBMYB
Ai0KDwoHBAkHzavUAxIExgECLQoLCgMECQcSBMcBAisKDwoHBAkHxavUAxIE
xwECKwoLCgMECQcSBMgBAicKDwoHBAkHlqvUAxIEyAECJwoLCgMECQcSBMkB
Ai8KDwoHBAkHkavUAxIEyQECLwoMCgIEChIGzAEAzwEBCgsKAwQKARIEzAEI
JAoLCgMECgcSBM0BAhsKDwoHBAoH/rvUAxIEzQECGwoLCgMECgcSBM4BAhwK
DwoHBAoHzavUAxIEzgECHAoMCgIECxIG0QEA1AEBCgsKAwQLARIE0QEIJAoL
CgMECwcSBNIBAhwKDwoHBAsH/rvUAxIE0gECHAoLCgMECwcSBNMBAh4KDwoH
BAsHzavUAxIE0wECHgrAAQoCBAwSBtsBAOIBARpaIFRPRE86IGRvIHdlIHdh
bnQgdG8gc3VwcG9ydCBwYWNrZWQgaW50cz8KIGUuZy46IHJlcGVhdGVkIGlu
dDMyIGZvbzQgPSA0IFtwYWNrZWQgPSB0cnVlXTsKMlYgT3B0aW9ucyBvZiBj
b21wbGV4IG1lc3NhZ2UgdHlwZXMsIHRoZW1zZWx2ZXMgY29tYmluZWQgYW5k
IGV4dGVuZGVkIGluCiB2YXJpb3VzIHdheXMuCgoLCgMEDAESBNsBCBoKDAoE
BAwCABIE3AECGQoNCgUEDAIABBIE3AECCgoNCgUEDAIABRIE3AELEAoNCgUE
DAIAARIE3AERFAoNCgUEDAIAAxIE3AEXGAoMCgQEDAIBEgTdAQIaCg0KBQQM
AgEEEgTdAQIKCg0KBQQMAgEFEgTdAQsQCg0KBQQMAgEBEgTdAREVCg0KBQQM
AgEDEgTdARgZCgwKBAQMAgISBN4BAhoKDQoFBAwCAgQSBN4BAgoKDQoFBAwC
AgUSBN4BCxAKDQoFBAwCAgESBN4BERUKDQoFBAwCAgMSBN4BGBkKDAoEBAwC
AxIE3wECGgoNCgUEDAIDBBIE3wECCgoNCgUEDAIDBRIE3wELEAoNCgUEDAID
ARIE3wERFQoNCgUEDAIDAxIE3wEYGQoLCgMEDAUSBOEBAhgKDAoEBAwFABIE
4QENFwoNCgUEDAUAARIE4QENEAoNCgUEDAUAAhIE4QEUFwoMCgIEDRIG5AEA
9AEBCgsKAwQNARIE5AEIGgoMCgQEDQIAEgTlAQImCg0KBQQNAgAEEgTlAQIK
Cg0KBQQNAgAGEgTlAQsdCg0KBQQNAgABEgTlAR4hCg0KBQQNAgADEgTlASQl
CgwKBAQNAgESBOYBAhkKDQoFBA0CAQQSBOYBAgoKDQoFBA0CAQUSBOYBCxAK
DQoFBA0CAQESBOYBERQKDQoFBA0CAQMSBOYBFxgKDgoEBA0DABIG6AEC7gED
Cg0KBQQNAwABEgToAQocCg4KBgQNAwACABIE6QEEHQoPCgcEDQMAAgAEEgTp
AQQMCg8KBwQNAwACAAUSBOkBDRIKDwoHBA0DAAIAARIE6QETGAoPCgcEDQMA
AgADEgTpARscCg8KBQQNAwAGEgbrAQTtAQUKDgoGBA0DAAYAEgTsAQY5Cg8K
BwQNAwAGAAISBOsBCykKDwoHBA0DAAYABBIE7AEGDgoPCgcEDQMABgAGEgTs
AQ8hCg8KBwQNAwAGAAESBOwBIi4KDwoHBA0DAAYAAxIE7AExOAoMCgQEDQIC
EgTwAQInCg0KBQQNAgIEEgTwAQIKCg0KBQQNAgIGEgTwAQsdCg0KBQQNAgIB
EgTwAR4iCg0KBQQNAgIDEgTwASUmCgwKBAQNAgMSBPEBAikKDQoFBA0CAwQS
BPEBAgoKDQoFBA0CAwYSBPEBCx0KDQoFBA0CAwESBPEBHiQKDQoFBA0CAwMS
BPEBJygKCwoDBA0FEgTzAQIYCgwKBAQNBQASBPMBDRcKDQoFBA0FAAESBPMB
DRAKDQoFBA0FAAISBPMBFBcKDAoCBA4SBvYBAPgBAQoLCgMEDgESBPYBCBoK
DAoEBA4CABIE9wECGQoNCgUEDgIABBIE9wECCgoNCgUEDgIABRIE9wELEAoN
CgUEDgIAARIE9wERFAoNCgUEDgIAAxIE9wEXGAoLCgEHEgb6AQD9AQEKCgoC
BxkSBPsBAiAKCwoDBxkCEgT6AQcZCgsKAwcZBBIE+wECCgoLCgMHGQUSBPsB
CxAKCwoDBxkBEgT7AREVCgsKAwcZAxIE+wEYHwoKCgIHGhIE/AECLgoLCgMH
GgISBPoBBxkKCwoDBxoEEgT8AQIKCgsKAwcaBhIE/AELHQoLCgMHGgESBPwB
HiMKCwoDBxoDEgT8ASYtCgsKAQcSBv8BAIICAQoKCgIHGxIEgAICIgoLCgMH
GwISBP8BBxkKCwoDBxsEEgSAAgIKCgsKAwcbBRIEgAILEAoLCgMHGwESBIAC
ERcKCwoDBxsDEgSAAhohCgoKAgccEgSBAgIvCgsKAwccAhIE/wEHGQoLCgMH
HAQSBIECAgoKCwoDBxwGEgSBAgsdCgsKAwccARIEgQIeJAoLCgMHHAMSBIEC
Jy4KCwoBBxIGhAIAigIBCgoKAgcdEgSFAgJHCgsKAwcdAhIEhAIHJQoLCgMH
HQQSBIUCAgoKCwoDBx0GEgSFAgsvCgsKAwcdARIEhQIwPAoLCgMHHQMSBIUC
P0YKCgoCBx4SBIYCAjUKCwoDBx4CEgSEAgclCgsKAwceBBIEhgICCgoLCgMH
HgYSBIYCCx0KCwoDBx4BEgSGAh4qCgsKAwceAxIEhgItNAoKCgIHHxIEhwIC
NQoLCgMHHwISBIQCByUKCwoDBx8EEgSHAgIKCgsKAwcfBhIEhwILHQoLCgMH
HwESBIcCHioKCwoDBx8DEgSHAi00CgoKAgcgEgSIAgIpCgsKAwcgAhIEhAIH
JQoLCgMHIAQSBIgCAgoKCwoDByAFEgSIAgsQCgsKAwcgARIEiAIRHgoLCgMH
IAMSBIgCISgKCgoCByESBIkCAkgKCwoDByECEgSEAgclCgsKAwchBBIEiQIC
CgoLCgMHIQYSBIkCCy8KCwoDByEBEgSJAjA9CgsKAwchAxIEiQJARwpVCgIE
DxIGjQIApgIBGkcgTm90ZSB0aGF0IHdlIHRyeSB2YXJpb3VzIGRpZmZlcmVu
dCB3YXlzIG9mIG5hbWluZyB0aGUgc2FtZSBleHRlbnNpb24uCgoLCgMEDwES
BI0CCB0KCwoDBA8HEgSOAgI0ChAKCAQPB6Tc0gMBEgSOAgI0CgsKAwQPBxIE
jwICSgoTCgsEDwek3NID2+DTAxIEjwICSgoLCgMEDwcSBJACAk8KFAoMBA8H
pNzSA9Le0wMBEgSQAgJPCgsKAwQPBxIEkQICNAoRCgkEDwek3NIDBAASBJEC
AjQKCwoDBA8HEgSSAgI0ChEKCQQPB6Tc0gMEARIEkgICNAoLCgMEDwcSBJMC
AiIKEAoIBA8H1Y/SAwISBJMCAiIKCwoDBA8HEgSUAgInChMKCwQPB9WP0gPv
/NIDEgSUAgInCgsKAwQPBxIElQICJgoRCgkEDwfVj9IDAQESBJUCAiYKCwoD
BA8HEgSWAgIqChQKDAQPB9WP0gMB2+DTAxIElgICKgoLCgMEDwcSBJcCAkEK
FQoNBA8H1Y/SAwHS3tMDARIElwICQQoLCgMEDwcSBJgCAisKFAoMBA8H1Y/S
A8j10gMBEgSYAgIrCgsKAwQPBxIEmQICQgoXCg8EDwfVj9IDyPXSA9vg0wMS
BJkCAkIKCwoDBA8HEgSaAgJGChgKEAQPB9WP0gPI9dID0t7TAwESBJoCAkYK
CwoDBA8HEgSbAgJLChAKCAQPB4r10QMBEgSbAgJLCgsKAwQPBxIEnAICKQoR
CgkEDwfVj9IDAwESBJwCAikKCwoDBA8HEgSdAgIwChEKCQQPB9WP0gMEABIE
nQICMAoLCgMEDwcSBJ4CAjAKEQoJBA8H1Y/SAwQBEgSeAgIwCgsKAwQPBxIE
nwICMgoQCggEDwfvi9IDARIEnwICMgoLCgMEDwcSBKACAh0KEAoIBA8H8IvS
AwASBKACAh0KCwoDBA8HEgShAgIdChAKCAQPB/CL0gMBEgShAgIdCgsKAwQP
BxIEogICJgoQCggEDwfxi9IDABIEogICJgoLCgMEDwcSBKMCAiYKRgoIBA8H
8YvSAwESBKMCAiYiNG9wdGlvbiAoY29tcGxleF9vcHQzKS5jb21wbGV4b3B0
aW9udHlwZTUucGx1Z2ggPSAyMjsKlwEKAgQQEgasAgCvAgEyiAEgLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tCiBEZWZpbml0aW9ucyBmb3IgdGVzdGluZyBhZ2dyZWdhdGUgb3B0aW9u
IHBhcnNpbmcuCiBTZWUgZGVzY3JpcHRvcl91bml0dGVzdC5jYy4KCgsKAwQQ
ARIErAIIGwoLCgMEEAcSBK0CAikKDAoEBBAHARIErQICKQoLCgMEEAUSBK4C
AhYKDAoEBBAFABIErgINFQoNCgUEEAUAARIErgINDgoNCgUEEAUAAhIErgIS
FQoMCgIEERIGsQIAtgIBCgsKAwQRARIEsQIIIgoNCgMEEQYSBrICArQCAwoM
CgQEEQYAEgSzAgRJCg0KBQQRBgACEgSyAgkcCg0KBQQRBgAEEgSzAgQMCg0K
BQQRBgAGEgSzAg0nCg0KBQQRBgABEgSzAig9Cg0KBQQRBgADEgSzAkBICgwK
BAQRAgASBLUCAhgKDQoFBBECAAQSBLUCAgoKDQoFBBECAAUSBLUCCxEKDQoF
BBECAAESBLUCEhMKDQoFBBECAAMSBLUCFhcKQwoCBBISBrkCAMgCARo1IEEg
aGVscGVyIHR5cGUgdXNlZCB0byB0ZXN0IGFnZ3JlZ2F0ZSBvcHRpb24gcGFy
c2luZwoKCwoDBBIBEgS5AggRCgwKBAQSAgASBLoCAhcKDQoFBBICAAQSBLoC
AgoKDQoFBBICAAUSBLoCCxAKDQoFBBICAAESBLoCERIKDQoFBBICAAMSBLoC
FRYKDAoEBBICARIEuwICGAoNCgUEEgIBBBIEuwICCgoNCgUEEgIBBRIEuwIL
EQoNCgUEEgIBARIEuwISEwoNCgUEEgIBAxIEuwIWFwofCgQEEgICEgS+AgId
GhEgQSBuZXN0ZWQgb2JqZWN0CgoNCgUEEgICBBIEvgICCgoNCgUEEgICBhIE
vgILFAoNCgUEEgICARIEvgIVGAoNCgUEEgICAxIEvgIbHApJCgQEEgIDEgTB
AgIwGjsgVG8gdGVzdCB0aGUgcGFyc2luZyBvZiBleHRlbnNpb25zIGluc2lk
ZSBhZ2dyZWdhdGUgdmFsdWVzCgoNCgUEEgIDBBIEwQICCgoNCgUEEgIDBhIE
wQILJgoNCgUEEgIDARIEwQInKwoNCgUEEgIDAxIEwQIuLwoNCgMEEgYSBsIC
AsQCAwoMCgQEEgYAEgTDAgQpCg0KBQQSBgACEgTCAgkkCg0KBQQSBgAEEgTD
AgQMCg0KBQQSBgAGEgTDAg0WCg0KBQQSBgABEgTDAhcdCg0KBQQSBgADEgTD
AiAoCicKBAQSAgQSBMcCAigaGSBBbiBlbWJlZGRlZCBtZXNzYWdlIHNldAoK
DQoFBBICBAQSBMcCAgoKDQoFBBICBAYSBMcCCx4KDQoFBBICBAESBMcCHyMK
DQoFBBICBAMSBMcCJicKZgoBBxIEzAIAVRpbIEFsbG93IEFnZ3JlZ2F0ZSB0
byBiZSB1c2VkIGFzIGFuIG9wdGlvbiBhdCBhbGwgcG9zc2libGUgbG9jYXRp
b25zCiBpbiB0aGUgLnByb3RvIGdyYW1tZXIuCgoKCgIHIhIEzAIqUwoLCgMH
IgISBMwCByIKCwoDByIEEgTMAioyCgsKAwciBhIEzAIzPAoLCgMHIgESBMwC
PUQKCwoDByIDEgTMAkpSCgkKAQcSBM0CAFUKCgoCByMSBM0CKlMKCwoDByMC
EgTNAgclCgsKAwcjBBIEzQIqMgoLCgMHIwYSBM0CMzwKCwoDByMBEgTNAj1D
CgsKAwcjAxIEzQJKUgoJCgEHEgTOAgBVCgoKAgckEgTOAipTCgsKAwckAhIE
zgIHIwoLCgMHJAQSBM4CKjIKCwoDByQGEgTOAjM8CgsKAwckARIEzgI9RQoL
CgMHJAMSBM4CSlIKCQoBBxIEzwIAVQoKCgIHJRIEzwIqUwoLCgMHJQISBM8C
ByIKCwoDByUEEgTPAioyCgsKAwclBhIEzwIzPAoLCgMHJQESBM8CPUQKCwoD
ByUDEgTPAkpSCgkKAQcSBNACAFUKCgoCByYSBNACKlMKCwoDByYCEgTQAgcn
CgsKAwcmBBIE0AIqMgoLCgMHJgYSBNACMzwKCwoDByYBEgTQAj1HCgsKAwcm
AxIE0AJKUgoJCgEHEgTRAgBVCgoKAgcnEgTRAipTCgsKAwcnAhIE0QIHJQoL
CgMHJwQSBNECKjIKCwoDBycGEgTRAjM8CgsKAwcnARIE0QI9RwoLCgMHJwMS
BNECSlIKCQoBBxIE0gIAVQoKCgIHKBIE0gIqUwoLCgMHKAISBNICByQKCwoD
BygEEgTSAioyCgsKAwcoBhIE0gIzPAoLCgMHKAESBNICPUYKCwoDBygDEgTS
AkpSCgsKAQgSBtUCAOoCAgpVCgUIz92wBxIG1QIA6gICGkQgVHJ5IHVzaW5n
IEFnZ3JlZ2F0ZU9wdGlvbiBhdCBkaWZmZXJlbnQgcG9pbnRzIGluIHRoZSBw
cm90byBncmFtbWFyCgoMCgIEExIG7AIA7wIBCgsKAwQTARIE7AIIGAoLCgME
EwcSBO0CAjQKDwoHBBMHmOqwBxIE7QICNAoMCgQEEwIAEgTuAgJGCg0KBQQT
AgAEEgTuAgIKCg0KBQQTAgAFEgTuAgsQCg0KBQQTAgABEgTuAhEaCg0KBQQT
AgADEgTuAh0eCg0KBQQTAgAIEgTuAh9FChEKCQQTAgAInvSwBxIE7gIgRAoM
CgIGARIG8QIA9gIBCgsKAwYBARIE8QIIGAoLCgMGAQMSBPICAjIKDwoHBgED
ue+xBxIE8gICMgoOCgQGAQIAEgbzAgL1AgMKDQoFBgECAAESBPMCBgwKDQoF
BgECAAISBPMCDh4KDQoFBgECAAMSBPMCKTkKDQoFBgECAAQSBPQCBDIKEQoJ
BgECAASJ6bIHEgT0AgQyCgwKAgUBEgb4AgD8AgEKCwoDBQEBEgT4AgUSCgsK
AwUBAxIE+QICLAoPCgcFAQPSgrEHEgT5AgIsCjAKBAUBAgASBPsCAjkaIiBU
T0RPOiBzdXBwb3J0IGVudW0gdmFsdWUgb3B0aW9ucwoKDQoFBQECAAESBPsC
AgcKDQoFBQECAAISBPsCCgsKDQoFBQECAAMSBPsCDDgKEQoJBQECAAPJn7EH
EgT7Ag03CjQKAgQUEgb/AgCMAwEaJiBUZXN0IGN1c3RvbSBvcHRpb25zIGZv
ciBuZXN0ZWQgdHlwZS4KCgsKAwQUARIE/wIIGAoOCgQEFAMAEgaAAwKDAwMK
DQoFBBQDAAESBIADChcKDQoFBBQDAAcSBIEDBCEKEQoJBBQDAAecrdgDEgSB
AwQhCg4KBgQUAwACABIEggMEOgoPCgcEFAMAAgAEEgSCAwQMCg8KBwQUAwAC
AAUSBIIDDRIKDwoHBBQDAAIAARIEggMTHwoPCgcEFAMAAgADEgSCAyIjCg8K
BwQUAwACAAgSBIIDJDkKEwoLBBQDAAIACIi82AMSBIIDJTgKDgoEBBQEABIG
hAMCiAMDCg0KBQQUBAABEgSEAwcRCg0KBQQUBAADEgSFAwQeChEKCQQUBAAD
6J7ZAxIEhQMEHgoyCgYEFAQAAgASBIcDBDUaIiBUT0RPOiBzdXBwb3J0IGVu
dW0gdmFsdWUgb3B0aW9ucwoKDwoHBBQEAAIAARIEhwMEFQoPCgcEFAQAAgAC
EgSHAxgZCg8KBwQUBAACAAMSBIcDGjQKEgoKBBQEAAIAA+agXxIEhwMbMwoN
CgMEFAYSBokDAosDAwoMCgQEFAYAEgSKAwRECg0KBQQUBgACEgSJAwkkCg0K
BQQUBgAEEgSKAwQMCg0KBQQUBgAFEgSKAw0SCg0KBQQUBgABEgSKAxMjCg0K
BQQUBgADEgSKAyYtCg0KBQQUBgAIEgSKAy5DChEKCQQUBgAIuaHZAxIEigMv
QgptCgIEFRIGkAMAlQMBGl8gQ3VzdG9tIG1lc3NhZ2Ugb3B0aW9uIHRoYXQg
aGFzIGEgcmVxdWlyZWQgZW51bSBmaWVsZC4KIFdBUk5JTkc6IHRoaXMgaXMg
c3Ryb25nbHkgZGlzY291cmFnZWQhCgoLCgMEFQESBJADCBUKDgoEBBUEABIG
kQMCkwMDCg0KBQQVBAABEgSRAwcPCg4KBgQVBAACABIEkgMEEgoPCgcEFQQA
AgABEgSSAwQNCg8KBwQVBAACAAISBJIDEBEKDAoEBBUCABIElAMCHgoNCgUE
FQIABBIElAMCCgoNCgUEFQIABhIElAMLEwoNCgUEFQIAARIElAMUGQoNCgUE
FQIAAxIElAMcHQo7CgIEFhIGmAMAngMBGi0gVXBkYXRlZCB2ZXJzaW9uIG9m
IHRoZSBjdXN0b20gb3B0aW9uIGFib3ZlLgoKCwoDBBYBEgSYAwgVCg4KBAQW
BAASBpkDApwDAwoNCgUEFgQAARIEmQMHDwoOCgYEFgQAAgASBJoDBBIKDwoH
BBYEAAIAARIEmgMEDQoPCgcEFgQAAgACEgSaAxARCg4KBgQWBAACARIEmwME
EgoPCgcEFgQAAgEBEgSbAwQNCg8KBwQWBAACAQISBJsDEBEKDAoEBBYCABIE
nQMCHgoNCgUEFgIABBIEnQMCCgoNCgUEFgIABhIEnQMLEwoNCgUEFgIAARIE
nQMUGQoNCgUEFgIAAxIEnQMcHQoLCgEHEgagAwCiAwEKCgoCBykSBKEDAjcK
CwoDBykCEgSgAwclCgsKAwcpBBIEoQMCCgoLCgMHKQYSBKEDCxgKCwoDBykB
EgShAxkqCgsKAwcpAxIEoQMtNgpQCgIEFxIGpQMApwMBGkIgVGVzdCBtZXNz
YWdlIHVzaW5nIHRoZSAicmVxdWlyZWRfZW51bV9vcHQiIG9wdGlvbiBkZWZp
bmVkIGFib3ZlLgoKCwoDBBcBEgSlAwgpCgsKAwQXBxIEpgMCNAoPCgcEFweP
zc8yEgSmAwI0
