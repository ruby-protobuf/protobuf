##
# This file is auto-generated. DO NOT EDIT!
#
require 'protobuf/message'
require 'protobuf/rpc/service'

##
# Imports
#
require 'test/google_unittest_import.pb'

module GoogleUnittest

  ##
  # Enum Classes
  #
  class ForeignEnum < ::Protobuf::Enum
    define :FOREIGN_FOO, 4
    define :FOREIGN_BAR, 5
    define :FOREIGN_BAZ, 6
  end
  
  class TestSparseEnum < ::Protobuf::Enum
    define :SPARSE_A, 123
    define :SPARSE_B, 62374
    define :SPARSE_C, 12589234
    define :SPARSE_D, -15
    define :SPARSE_E, -53452
    define :SPARSE_F, 0
    define :SPARSE_G, 2
  end
  
  
  ##
  # Message Classes
  #
  class TestAllTypes < ::Protobuf::Message
    class NestedEnum < ::Protobuf::Enum
      define :FOO, 1
      define :BAR, 2
      define :BAZ, 3
    end
    
    class NestedMessage < ::Protobuf::Message; end
  end
  class TestDeprecatedFields < ::Protobuf::Message; end
  class ForeignMessage < ::Protobuf::Message; end
  class TestAllExtensions < ::Protobuf::Message; end
  class TestNestedExtension < ::Protobuf::Message; end
  class TestRequired < ::Protobuf::Message; end
  class TestRequiredForeign < ::Protobuf::Message; end
  class TestForeignNested < ::Protobuf::Message; end
  class TestEmptyMessage < ::Protobuf::Message; end
  class TestEmptyMessageWithExtensions < ::Protobuf::Message; end
  class TestMultipleExtensionRanges < ::Protobuf::Message; end
  class TestReallyLargeTagNumber < ::Protobuf::Message; end
  class TestRecursiveMessage < ::Protobuf::Message; end
  class TestMutualRecursionA < ::Protobuf::Message; end
  class TestMutualRecursionB < ::Protobuf::Message; end
  class TestDupFieldNumber < ::Protobuf::Message; end
  class TestEagerMessage < ::Protobuf::Message; end
  class TestLazyMessage < ::Protobuf::Message; end
  class TestNestedMessageHasBits < ::Protobuf::Message
    class NestedMessage < ::Protobuf::Message; end
  end
  class TestCamelCaseFieldNames < ::Protobuf::Message; end
  class TestFieldOrderings < ::Protobuf::Message; end
  class TestExtremeDefaultValues < ::Protobuf::Message; end
  class SparseEnumMessage < ::Protobuf::Message; end
  class OneString < ::Protobuf::Message; end
  class MoreString < ::Protobuf::Message; end
  class OneBytes < ::Protobuf::Message; end
  class MoreBytes < ::Protobuf::Message; end
  class TestPackedTypes < ::Protobuf::Message; end
  class TestUnpackedTypes < ::Protobuf::Message; end
  class TestPackedExtensions < ::Protobuf::Message; end
  class TestDynamicExtensions < ::Protobuf::Message
    class DynamicEnumType < ::Protobuf::Enum
      define :DYNAMIC_FOO, 2200
      define :DYNAMIC_BAR, 2201
      define :DYNAMIC_BAZ, 2202
    end
    
    class DynamicMessageType < ::Protobuf::Message; end
  end
  class TestRepeatedScalarDifferentTagSizes < ::Protobuf::Message; end
  class TestParsingMerge < ::Protobuf::Message
    class RepeatedFieldsGenerator < ::Protobuf::Message; end
  end
  class TestCommentInjectionMessage < ::Protobuf::Message; end
  class FooRequest < ::Protobuf::Message; end
  class FooResponse < ::Protobuf::Message; end
  class FooClientMessage < ::Protobuf::Message; end
  class FooServerMessage < ::Protobuf::Message; end
  class BarRequest < ::Protobuf::Message; end
  class BarResponse < ::Protobuf::Message; end
  
  ##
  # Message Fields
  #
  class TestAllTypes
    class NestedMessage
      optional ::Protobuf::Field::Int32Field, :bb, 1
    end
    
    optional ::Protobuf::Field::Int32Field, :optional_int32, 1
    optional ::Protobuf::Field::Int64Field, :optional_int64, 2
    optional ::Protobuf::Field::Uint32Field, :optional_uint32, 3
    optional ::Protobuf::Field::Uint64Field, :optional_uint64, 4
    optional ::Protobuf::Field::Sint32Field, :optional_sint32, 5
    optional ::Protobuf::Field::Sint64Field, :optional_sint64, 6
    optional ::Protobuf::Field::Fixed32Field, :optional_fixed32, 7
    optional ::Protobuf::Field::Fixed64Field, :optional_fixed64, 8
    optional ::Protobuf::Field::Sfixed32Field, :optional_sfixed32, 9
    optional ::Protobuf::Field::Sfixed64Field, :optional_sfixed64, 10
    optional ::Protobuf::Field::FloatField, :optional_float, 11
    optional ::Protobuf::Field::DoubleField, :optional_double, 12
    optional ::Protobuf::Field::BoolField, :optional_bool, 13
    optional ::Protobuf::Field::StringField, :optional_string, 14
    optional ::Protobuf::Field::BytesField, :optional_bytes, 15
    optional ::GoogleUnittest::TestAllTypes::NestedMessage, :optional_nested_message, 18
    optional ::GoogleUnittest::ForeignMessage, :optional_foreign_message, 19
    optional ::GoogleUnittestImport::ImportMessage, :optional_import_message, 20
    optional ::GoogleUnittest::TestAllTypes::NestedEnum, :optional_nested_enum, 21
    optional ::GoogleUnittest::ForeignEnum, :optional_foreign_enum, 22
    optional ::GoogleUnittestImport::ImportEnum, :optional_import_enum, 23
    optional ::Protobuf::Field::StringField, :optional_string_piece, 24
    optional ::Protobuf::Field::StringField, :optional_cord, 25
    optional ::GoogleUnittestImport::PublicImportMessage, :optional_public_import_message, 26
    optional ::GoogleUnittest::TestAllTypes::NestedMessage, :optional_lazy_message, 27
    repeated ::Protobuf::Field::Int32Field, :repeated_int32, 31
    repeated ::Protobuf::Field::Int64Field, :repeated_int64, 32
    repeated ::Protobuf::Field::Uint32Field, :repeated_uint32, 33
    repeated ::Protobuf::Field::Uint64Field, :repeated_uint64, 34
    repeated ::Protobuf::Field::Sint32Field, :repeated_sint32, 35
    repeated ::Protobuf::Field::Sint64Field, :repeated_sint64, 36
    repeated ::Protobuf::Field::Fixed32Field, :repeated_fixed32, 37
    repeated ::Protobuf::Field::Fixed64Field, :repeated_fixed64, 38
    repeated ::Protobuf::Field::Sfixed32Field, :repeated_sfixed32, 39
    repeated ::Protobuf::Field::Sfixed64Field, :repeated_sfixed64, 40
    repeated ::Protobuf::Field::FloatField, :repeated_float, 41
    repeated ::Protobuf::Field::DoubleField, :repeated_double, 42
    repeated ::Protobuf::Field::BoolField, :repeated_bool, 43
    repeated ::Protobuf::Field::StringField, :repeated_string, 44
    repeated ::Protobuf::Field::BytesField, :repeated_bytes, 45
    repeated ::GoogleUnittest::TestAllTypes::NestedMessage, :repeated_nested_message, 48
    repeated ::GoogleUnittest::ForeignMessage, :repeated_foreign_message, 49
    repeated ::GoogleUnittestImport::ImportMessage, :repeated_import_message, 50
    repeated ::GoogleUnittest::TestAllTypes::NestedEnum, :repeated_nested_enum, 51
    repeated ::GoogleUnittest::ForeignEnum, :repeated_foreign_enum, 52
    repeated ::GoogleUnittestImport::ImportEnum, :repeated_import_enum, 53
    repeated ::Protobuf::Field::StringField, :repeated_string_piece, 54
    repeated ::Protobuf::Field::StringField, :repeated_cord, 55
    repeated ::GoogleUnittest::TestAllTypes::NestedMessage, :repeated_lazy_message, 57
    optional ::Protobuf::Field::Int32Field, :default_int32, 61, :default => 41
    optional ::Protobuf::Field::Int64Field, :default_int64, 62, :default => 42
    optional ::Protobuf::Field::Uint32Field, :default_uint32, 63, :default => 43
    optional ::Protobuf::Field::Uint64Field, :default_uint64, 64, :default => 44
    optional ::Protobuf::Field::Sint32Field, :default_sint32, 65, :default => -45
    optional ::Protobuf::Field::Sint64Field, :default_sint64, 66, :default => 46
    optional ::Protobuf::Field::Fixed32Field, :default_fixed32, 67, :default => 47
    optional ::Protobuf::Field::Fixed64Field, :default_fixed64, 68, :default => 48
    optional ::Protobuf::Field::Sfixed32Field, :default_sfixed32, 69, :default => 49
    optional ::Protobuf::Field::Sfixed64Field, :default_sfixed64, 70, :default => -50
    optional ::Protobuf::Field::FloatField, :default_float, 71, :default => 51.5
    optional ::Protobuf::Field::DoubleField, :default_double, 72, :default => 52000
    optional ::Protobuf::Field::BoolField, :default_bool, 73, :default => true
    optional ::Protobuf::Field::StringField, :default_string, 74, :default => "hello"
    optional ::Protobuf::Field::BytesField, :default_bytes, 75, :default => "world"
    optional ::GoogleUnittest::TestAllTypes::NestedEnum, :default_nested_enum, 81, :default => ::GoogleUnittest::TestAllTypes::NestedEnum::BAR
    optional ::GoogleUnittest::ForeignEnum, :default_foreign_enum, 82, :default => ::GoogleUnittest::ForeignEnum::FOREIGN_BAR
    optional ::GoogleUnittestImport::ImportEnum, :default_import_enum, 83, :default => ::GoogleUnittestImport::ImportEnum::IMPORT_BAR
    optional ::Protobuf::Field::StringField, :default_string_piece, 84, :default => "abc"
    optional ::Protobuf::Field::StringField, :default_cord, 85, :default => "123"
  end
  
  class TestDeprecatedFields
    optional ::Protobuf::Field::Int32Field, :deprecated_int32, 1, :deprecated => true
  end
  
  class ForeignMessage
    optional ::Protobuf::Field::Int32Field, :c, 1
  end
  
  class TestAllExtensions
    
    # Extension Fields
    extensions 1...536870912
    optional ::Protobuf::Field::Int32Field, :optional_int32_extension, 1, :extension => true
    optional ::Protobuf::Field::Int64Field, :optional_int64_extension, 2, :extension => true
    optional ::Protobuf::Field::Uint32Field, :optional_uint32_extension, 3, :extension => true
    optional ::Protobuf::Field::Uint64Field, :optional_uint64_extension, 4, :extension => true
    optional ::Protobuf::Field::Sint32Field, :optional_sint32_extension, 5, :extension => true
    optional ::Protobuf::Field::Sint64Field, :optional_sint64_extension, 6, :extension => true
    optional ::Protobuf::Field::Fixed32Field, :optional_fixed32_extension, 7, :extension => true
    optional ::Protobuf::Field::Fixed64Field, :optional_fixed64_extension, 8, :extension => true
    optional ::Protobuf::Field::Sfixed32Field, :optional_sfixed32_extension, 9, :extension => true
    optional ::Protobuf::Field::Sfixed64Field, :optional_sfixed64_extension, 10, :extension => true
    optional ::Protobuf::Field::FloatField, :optional_float_extension, 11, :extension => true
    optional ::Protobuf::Field::DoubleField, :optional_double_extension, 12, :extension => true
    optional ::Protobuf::Field::BoolField, :optional_bool_extension, 13, :extension => true
    optional ::Protobuf::Field::StringField, :optional_string_extension, 14, :extension => true
    optional ::Protobuf::Field::BytesField, :optional_bytes_extension, 15, :extension => true
    optional ::GoogleUnittest::TestAllTypes::NestedMessage, :optional_nested_message_extension, 18, :extension => true
    optional ::GoogleUnittest::ForeignMessage, :optional_foreign_message_extension, 19, :extension => true
    optional ::GoogleUnittestImport::ImportMessage, :optional_import_message_extension, 20, :extension => true
    optional ::GoogleUnittest::TestAllTypes::NestedEnum, :optional_nested_enum_extension, 21, :extension => true
    optional ::GoogleUnittest::ForeignEnum, :optional_foreign_enum_extension, 22, :extension => true
    optional ::GoogleUnittestImport::ImportEnum, :optional_import_enum_extension, 23, :extension => true
    optional ::Protobuf::Field::StringField, :optional_string_piece_extension, 24, :extension => true
    optional ::Protobuf::Field::StringField, :optional_cord_extension, 25, :extension => true
    optional ::GoogleUnittestImport::PublicImportMessage, :optional_public_import_message_extension, 26, :extension => true
    optional ::GoogleUnittest::TestAllTypes::NestedMessage, :optional_lazy_message_extension, 27, :extension => true
    repeated ::Protobuf::Field::Int32Field, :repeated_int32_extension, 31, :extension => true
    repeated ::Protobuf::Field::Int64Field, :repeated_int64_extension, 32, :extension => true
    repeated ::Protobuf::Field::Uint32Field, :repeated_uint32_extension, 33, :extension => true
    repeated ::Protobuf::Field::Uint64Field, :repeated_uint64_extension, 34, :extension => true
    repeated ::Protobuf::Field::Sint32Field, :repeated_sint32_extension, 35, :extension => true
    repeated ::Protobuf::Field::Sint64Field, :repeated_sint64_extension, 36, :extension => true
    repeated ::Protobuf::Field::Fixed32Field, :repeated_fixed32_extension, 37, :extension => true
    repeated ::Protobuf::Field::Fixed64Field, :repeated_fixed64_extension, 38, :extension => true
    repeated ::Protobuf::Field::Sfixed32Field, :repeated_sfixed32_extension, 39, :extension => true
    repeated ::Protobuf::Field::Sfixed64Field, :repeated_sfixed64_extension, 40, :extension => true
    repeated ::Protobuf::Field::FloatField, :repeated_float_extension, 41, :extension => true
    repeated ::Protobuf::Field::DoubleField, :repeated_double_extension, 42, :extension => true
    repeated ::Protobuf::Field::BoolField, :repeated_bool_extension, 43, :extension => true
    repeated ::Protobuf::Field::StringField, :repeated_string_extension, 44, :extension => true
    repeated ::Protobuf::Field::BytesField, :repeated_bytes_extension, 45, :extension => true
    repeated ::GoogleUnittest::TestAllTypes::NestedMessage, :repeated_nested_message_extension, 48, :extension => true
    repeated ::GoogleUnittest::ForeignMessage, :repeated_foreign_message_extension, 49, :extension => true
    repeated ::GoogleUnittestImport::ImportMessage, :repeated_import_message_extension, 50, :extension => true
    repeated ::GoogleUnittest::TestAllTypes::NestedEnum, :repeated_nested_enum_extension, 51, :extension => true
    repeated ::GoogleUnittest::ForeignEnum, :repeated_foreign_enum_extension, 52, :extension => true
    repeated ::GoogleUnittestImport::ImportEnum, :repeated_import_enum_extension, 53, :extension => true
    repeated ::Protobuf::Field::StringField, :repeated_string_piece_extension, 54, :extension => true
    repeated ::Protobuf::Field::StringField, :repeated_cord_extension, 55, :extension => true
    repeated ::GoogleUnittest::TestAllTypes::NestedMessage, :repeated_lazy_message_extension, 57, :extension => true
    optional ::Protobuf::Field::Int32Field, :default_int32_extension, 61, :default => 41, :extension => true
    optional ::Protobuf::Field::Int64Field, :default_int64_extension, 62, :default => 42, :extension => true
    optional ::Protobuf::Field::Uint32Field, :default_uint32_extension, 63, :default => 43, :extension => true
    optional ::Protobuf::Field::Uint64Field, :default_uint64_extension, 64, :default => 44, :extension => true
    optional ::Protobuf::Field::Sint32Field, :default_sint32_extension, 65, :default => -45, :extension => true
    optional ::Protobuf::Field::Sint64Field, :default_sint64_extension, 66, :default => 46, :extension => true
    optional ::Protobuf::Field::Fixed32Field, :default_fixed32_extension, 67, :default => 47, :extension => true
    optional ::Protobuf::Field::Fixed64Field, :default_fixed64_extension, 68, :default => 48, :extension => true
    optional ::Protobuf::Field::Sfixed32Field, :default_sfixed32_extension, 69, :default => 49, :extension => true
    optional ::Protobuf::Field::Sfixed64Field, :default_sfixed64_extension, 70, :default => -50, :extension => true
    optional ::Protobuf::Field::FloatField, :default_float_extension, 71, :default => 51.5, :extension => true
    optional ::Protobuf::Field::DoubleField, :default_double_extension, 72, :default => 52000, :extension => true
    optional ::Protobuf::Field::BoolField, :default_bool_extension, 73, :default => true, :extension => true
    optional ::Protobuf::Field::StringField, :default_string_extension, 74, :default => "hello", :extension => true
    optional ::Protobuf::Field::BytesField, :default_bytes_extension, 75, :default => "world", :extension => true
    optional ::GoogleUnittest::TestAllTypes::NestedEnum, :default_nested_enum_extension, 81, :default => ::GoogleUnittest::TestAllTypes::NestedEnum::BAR, :extension => true
    optional ::GoogleUnittest::ForeignEnum, :default_foreign_enum_extension, 82, :default => ::GoogleUnittest::ForeignEnum::FOREIGN_BAR, :extension => true
    optional ::GoogleUnittestImport::ImportEnum, :default_import_enum_extension, 83, :default => ::GoogleUnittestImport::ImportEnum::IMPORT_BAR, :extension => true
    optional ::Protobuf::Field::StringField, :default_string_piece_extension, 84, :default => "abc", :extension => true
    optional ::Protobuf::Field::StringField, :default_cord_extension, 85, :default => "123", :extension => true
    optional ::Protobuf::Field::StringField, :test, 1002, :default => "test", :extension => true
    optional ::GoogleUnittest::TestRequired, :single, 1000, :extension => true
    repeated ::GoogleUnittest::TestRequired, :multi, 1001, :extension => true
  end
  
  class TestRequired
    required ::Protobuf::Field::Int32Field, :a, 1
    optional ::Protobuf::Field::Int32Field, :dummy2, 2
    required ::Protobuf::Field::Int32Field, :b, 3
    optional ::Protobuf::Field::Int32Field, :dummy4, 4
    optional ::Protobuf::Field::Int32Field, :dummy5, 5
    optional ::Protobuf::Field::Int32Field, :dummy6, 6
    optional ::Protobuf::Field::Int32Field, :dummy7, 7
    optional ::Protobuf::Field::Int32Field, :dummy8, 8
    optional ::Protobuf::Field::Int32Field, :dummy9, 9
    optional ::Protobuf::Field::Int32Field, :dummy10, 10
    optional ::Protobuf::Field::Int32Field, :dummy11, 11
    optional ::Protobuf::Field::Int32Field, :dummy12, 12
    optional ::Protobuf::Field::Int32Field, :dummy13, 13
    optional ::Protobuf::Field::Int32Field, :dummy14, 14
    optional ::Protobuf::Field::Int32Field, :dummy15, 15
    optional ::Protobuf::Field::Int32Field, :dummy16, 16
    optional ::Protobuf::Field::Int32Field, :dummy17, 17
    optional ::Protobuf::Field::Int32Field, :dummy18, 18
    optional ::Protobuf::Field::Int32Field, :dummy19, 19
    optional ::Protobuf::Field::Int32Field, :dummy20, 20
    optional ::Protobuf::Field::Int32Field, :dummy21, 21
    optional ::Protobuf::Field::Int32Field, :dummy22, 22
    optional ::Protobuf::Field::Int32Field, :dummy23, 23
    optional ::Protobuf::Field::Int32Field, :dummy24, 24
    optional ::Protobuf::Field::Int32Field, :dummy25, 25
    optional ::Protobuf::Field::Int32Field, :dummy26, 26
    optional ::Protobuf::Field::Int32Field, :dummy27, 27
    optional ::Protobuf::Field::Int32Field, :dummy28, 28
    optional ::Protobuf::Field::Int32Field, :dummy29, 29
    optional ::Protobuf::Field::Int32Field, :dummy30, 30
    optional ::Protobuf::Field::Int32Field, :dummy31, 31
    optional ::Protobuf::Field::Int32Field, :dummy32, 32
    required ::Protobuf::Field::Int32Field, :c, 33
  end
  
  class TestRequiredForeign
    optional ::GoogleUnittest::TestRequired, :optional_message, 1
    repeated ::GoogleUnittest::TestRequired, :repeated_message, 2
    optional ::Protobuf::Field::Int32Field, :dummy, 3
  end
  
  class TestForeignNested
    optional ::GoogleUnittest::TestAllTypes::NestedMessage, :foreign_nested, 1
  end
  
  class TestReallyLargeTagNumber
    optional ::Protobuf::Field::Int32Field, :a, 1
    optional ::Protobuf::Field::Int32Field, :bb, 268435455
  end
  
  class TestRecursiveMessage
    optional ::GoogleUnittest::TestRecursiveMessage, :a, 1
    optional ::Protobuf::Field::Int32Field, :i, 2
  end
  
  class TestMutualRecursionA
    optional ::GoogleUnittest::TestMutualRecursionB, :bb, 1
  end
  
  class TestMutualRecursionB
    optional ::GoogleUnittest::TestMutualRecursionA, :a, 1
    optional ::Protobuf::Field::Int32Field, :optional_int32, 2
  end
  
  class TestDupFieldNumber
    optional ::Protobuf::Field::Int32Field, :a, 1
  end
  
  class TestEagerMessage
    optional ::GoogleUnittest::TestAllTypes, :sub_message, 1
  end
  
  class TestLazyMessage
    optional ::GoogleUnittest::TestAllTypes, :sub_message, 1
  end
  
  class TestNestedMessageHasBits
    class NestedMessage
      repeated ::Protobuf::Field::Int32Field, :nestedmessage_repeated_int32, 1
      repeated ::GoogleUnittest::ForeignMessage, :nestedmessage_repeated_foreignmessage, 2
    end
    
    optional ::GoogleUnittest::TestNestedMessageHasBits::NestedMessage, :optional_nested_message, 1
  end
  
  class TestCamelCaseFieldNames
    optional ::Protobuf::Field::Int32Field, :primitivefield, 1
    optional ::Protobuf::Field::StringField, :stringfield, 2
    optional ::GoogleUnittest::ForeignEnum, :enumfield, 3
    optional ::GoogleUnittest::ForeignMessage, :messagefield, 4
    optional ::Protobuf::Field::StringField, :stringpiecefield, 5
    optional ::Protobuf::Field::StringField, :cordfield, 6
    repeated ::Protobuf::Field::Int32Field, :repeatedprimitivefield, 7
    repeated ::Protobuf::Field::StringField, :repeatedstringfield, 8
    repeated ::GoogleUnittest::ForeignEnum, :repeatedenumfield, 9
    repeated ::GoogleUnittest::ForeignMessage, :repeatedmessagefield, 10
    repeated ::Protobuf::Field::StringField, :repeatedstringpiecefield, 11
    repeated ::Protobuf::Field::StringField, :repeatedcordfield, 12
  end
  
  class TestFieldOrderings
    optional ::Protobuf::Field::StringField, :my_string, 11
    optional ::Protobuf::Field::Int64Field, :my_int, 1
    optional ::Protobuf::Field::FloatField, :my_float, 101
    
    # Extension Fields
    extensions 2...11
    extensions 12...101
    optional ::Protobuf::Field::StringField, :my_extension_string, 50, :extension => true
    optional ::Protobuf::Field::Int32Field, :my_extension_int, 5, :extension => true
  end
  
  class TestExtremeDefaultValues
    optional ::Protobuf::Field::BytesField, :escaped_bytes, 1, :default => "\0\001\a\b\f\n\r\t\v\\\'\"\xfe"
    optional ::Protobuf::Field::Uint32Field, :large_uint32, 2, :default => 4294967295
    optional ::Protobuf::Field::Uint64Field, :large_uint64, 3, :default => 18446744073709551615
    optional ::Protobuf::Field::Int32Field, :small_int32, 4, :default => -2147483647
    optional ::Protobuf::Field::Int64Field, :small_int64, 5, :default => -9223372036854775807
    optional ::Protobuf::Field::Int32Field, :really_small_int32, 21, :default => -2147483648
    optional ::Protobuf::Field::Int64Field, :really_small_int64, 22, :default => -9223372036854775808
    optional ::Protobuf::Field::StringField, :utf8_string, 6, :default => "ሴ"
    optional ::Protobuf::Field::FloatField, :zero_float, 7, :default => 0
    optional ::Protobuf::Field::FloatField, :one_float, 8, :default => 1
    optional ::Protobuf::Field::FloatField, :small_float, 9, :default => 1.5
    optional ::Protobuf::Field::FloatField, :negative_one_float, 10, :default => -1
    optional ::Protobuf::Field::FloatField, :negative_float, 11, :default => -1.5
    optional ::Protobuf::Field::FloatField, :large_float, 12, :default => 2e+08
    optional ::Protobuf::Field::FloatField, :small_negative_float, 13, :default => -8e-28
    optional ::Protobuf::Field::DoubleField, :inf_double, 14, :default => Float::INFINITY
    optional ::Protobuf::Field::DoubleField, :neg_inf_double, 15, :default => -Float::INFINITY
    optional ::Protobuf::Field::DoubleField, :nan_double, 16, :default => Float::NAN
    optional ::Protobuf::Field::FloatField, :inf_float, 17, :default => Float::INFINITY
    optional ::Protobuf::Field::FloatField, :neg_inf_float, 18, :default => -Float::INFINITY
    optional ::Protobuf::Field::FloatField, :nan_float, 19, :default => Float::NAN
    optional ::Protobuf::Field::StringField, :cpp_trigraph, 20, :default => "? ? ?? ?? ??? ??/ ??-"
    optional ::Protobuf::Field::StringField, :string_with_zero, 23, :default => "hel lo"
    optional ::Protobuf::Field::BytesField, :bytes_with_zero, 24, :default => "wor ld"
    optional ::Protobuf::Field::StringField, :string_piece_with_zero, 25, :default => "ab c"
    optional ::Protobuf::Field::StringField, :cord_with_zero, 26, :default => "12 3"
  end
  
  class SparseEnumMessage
    optional ::GoogleUnittest::TestSparseEnum, :sparse_enum, 1
  end
  
  class OneString
    optional ::Protobuf::Field::StringField, :data, 1
  end
  
  class MoreString
    repeated ::Protobuf::Field::StringField, :data, 1
  end
  
  class OneBytes
    optional ::Protobuf::Field::BytesField, :data, 1
  end
  
  class MoreBytes
    repeated ::Protobuf::Field::BytesField, :data, 1
  end
  
  class TestPackedTypes
    repeated ::Protobuf::Field::Int32Field, :packed_int32, 90, :packed => true
    repeated ::Protobuf::Field::Int64Field, :packed_int64, 91, :packed => true
    repeated ::Protobuf::Field::Uint32Field, :packed_uint32, 92, :packed => true
    repeated ::Protobuf::Field::Uint64Field, :packed_uint64, 93, :packed => true
    repeated ::Protobuf::Field::Sint32Field, :packed_sint32, 94, :packed => true
    repeated ::Protobuf::Field::Sint64Field, :packed_sint64, 95, :packed => true
    repeated ::Protobuf::Field::Fixed32Field, :packed_fixed32, 96, :packed => true
    repeated ::Protobuf::Field::Fixed64Field, :packed_fixed64, 97, :packed => true
    repeated ::Protobuf::Field::Sfixed32Field, :packed_sfixed32, 98, :packed => true
    repeated ::Protobuf::Field::Sfixed64Field, :packed_sfixed64, 99, :packed => true
    repeated ::Protobuf::Field::FloatField, :packed_float, 100, :packed => true
    repeated ::Protobuf::Field::DoubleField, :packed_double, 101, :packed => true
    repeated ::Protobuf::Field::BoolField, :packed_bool, 102, :packed => true
    repeated ::GoogleUnittest::ForeignEnum, :packed_enum, 103, :packed => true
  end
  
  class TestUnpackedTypes
    repeated ::Protobuf::Field::Int32Field, :unpacked_int32, 90, :packed => false
    repeated ::Protobuf::Field::Int64Field, :unpacked_int64, 91, :packed => false
    repeated ::Protobuf::Field::Uint32Field, :unpacked_uint32, 92, :packed => false
    repeated ::Protobuf::Field::Uint64Field, :unpacked_uint64, 93, :packed => false
    repeated ::Protobuf::Field::Sint32Field, :unpacked_sint32, 94, :packed => false
    repeated ::Protobuf::Field::Sint64Field, :unpacked_sint64, 95, :packed => false
    repeated ::Protobuf::Field::Fixed32Field, :unpacked_fixed32, 96, :packed => false
    repeated ::Protobuf::Field::Fixed64Field, :unpacked_fixed64, 97, :packed => false
    repeated ::Protobuf::Field::Sfixed32Field, :unpacked_sfixed32, 98, :packed => false
    repeated ::Protobuf::Field::Sfixed64Field, :unpacked_sfixed64, 99, :packed => false
    repeated ::Protobuf::Field::FloatField, :unpacked_float, 100, :packed => false
    repeated ::Protobuf::Field::DoubleField, :unpacked_double, 101, :packed => false
    repeated ::Protobuf::Field::BoolField, :unpacked_bool, 102, :packed => false
    repeated ::GoogleUnittest::ForeignEnum, :unpacked_enum, 103, :packed => false
  end
  
  class TestPackedExtensions
    
    # Extension Fields
    extensions 1...536870912
    repeated ::Protobuf::Field::Int32Field, :packed_int32_extension, 90, :packed => true, :extension => true
    repeated ::Protobuf::Field::Int64Field, :packed_int64_extension, 91, :packed => true, :extension => true
    repeated ::Protobuf::Field::Uint32Field, :packed_uint32_extension, 92, :packed => true, :extension => true
    repeated ::Protobuf::Field::Uint64Field, :packed_uint64_extension, 93, :packed => true, :extension => true
    repeated ::Protobuf::Field::Sint32Field, :packed_sint32_extension, 94, :packed => true, :extension => true
    repeated ::Protobuf::Field::Sint64Field, :packed_sint64_extension, 95, :packed => true, :extension => true
    repeated ::Protobuf::Field::Fixed32Field, :packed_fixed32_extension, 96, :packed => true, :extension => true
    repeated ::Protobuf::Field::Fixed64Field, :packed_fixed64_extension, 97, :packed => true, :extension => true
    repeated ::Protobuf::Field::Sfixed32Field, :packed_sfixed32_extension, 98, :packed => true, :extension => true
    repeated ::Protobuf::Field::Sfixed64Field, :packed_sfixed64_extension, 99, :packed => true, :extension => true
    repeated ::Protobuf::Field::FloatField, :packed_float_extension, 100, :packed => true, :extension => true
    repeated ::Protobuf::Field::DoubleField, :packed_double_extension, 101, :packed => true, :extension => true
    repeated ::Protobuf::Field::BoolField, :packed_bool_extension, 102, :packed => true, :extension => true
    repeated ::GoogleUnittest::ForeignEnum, :packed_enum_extension, 103, :packed => true, :extension => true
  end
  
  class TestDynamicExtensions
    class DynamicMessageType
      optional ::Protobuf::Field::Int32Field, :dynamic_field, 2100
    end
    
    optional ::Protobuf::Field::Fixed32Field, :scalar_extension, 2000
    optional ::GoogleUnittest::ForeignEnum, :enum_extension, 2001
    optional ::GoogleUnittest::TestDynamicExtensions::DynamicEnumType, :dynamic_enum_extension, 2002
    optional ::GoogleUnittest::ForeignMessage, :message_extension, 2003
    optional ::GoogleUnittest::TestDynamicExtensions::DynamicMessageType, :dynamic_message_extension, 2004
    repeated ::Protobuf::Field::StringField, :repeated_extension, 2005
    repeated ::Protobuf::Field::Sint32Field, :packed_extension, 2006, :packed => true
  end
  
  class TestRepeatedScalarDifferentTagSizes
    repeated ::Protobuf::Field::Fixed32Field, :repeated_fixed32, 12
    repeated ::Protobuf::Field::Int32Field, :repeated_int32, 13
    repeated ::Protobuf::Field::Fixed64Field, :repeated_fixed64, 2046
    repeated ::Protobuf::Field::Int64Field, :repeated_int64, 2047
    repeated ::Protobuf::Field::FloatField, :repeated_float, 262142
    repeated ::Protobuf::Field::Uint64Field, :repeated_uint64, 262143
  end
  
  class TestParsingMerge
    class RepeatedFieldsGenerator
      repeated ::GoogleUnittest::TestAllTypes, :field1, 1
      repeated ::GoogleUnittest::TestAllTypes, :field2, 2
      repeated ::GoogleUnittest::TestAllTypes, :field3, 3
      repeated ::GoogleUnittest::TestAllTypes, :ext1, 1000
      repeated ::GoogleUnittest::TestAllTypes, :ext2, 1001
    end
    
    required ::GoogleUnittest::TestAllTypes, :required_all_types, 1
    optional ::GoogleUnittest::TestAllTypes, :optional_all_types, 2
    repeated ::GoogleUnittest::TestAllTypes, :repeated_all_types, 3
    
    # Extension Fields
    extensions 1000...536870912
    optional ::GoogleUnittest::TestAllTypes, :optional_ext, 1000, :extension => true
    repeated ::GoogleUnittest::TestAllTypes, :repeated_ext, 1001, :extension => true
  end
  
  class TestCommentInjectionMessage
    optional ::Protobuf::Field::StringField, :a, 1, :default => "*/ <- Neither should this."
  end
  
  
  ##
  # Services
  #
  class TestService < ::Protobuf::Rpc::Service
    rpc :foo, ::GoogleUnittest::FooRequest, ::GoogleUnittest::FooResponse
    rpc :bar, ::GoogleUnittest::BarRequest, ::GoogleUnittest::BarResponse
  end
end

