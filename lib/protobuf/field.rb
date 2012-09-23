require 'protobuf/field/base_field'
require 'protobuf/field/bytes_field'
require 'protobuf/field/float_field'
require 'protobuf/field/message_field'
require 'protobuf/field/varint_field'
require 'protobuf/field/string_field'
require 'protobuf/field/double_field'
require 'protobuf/field/enum_field'
require 'protobuf/field/integer_field'
require 'protobuf/field/signed_integer_field'
require 'protobuf/field/uint32_field'
require 'protobuf/field/uint64_field'
require 'protobuf/field/int32_field'
require 'protobuf/field/int64_field'
require 'protobuf/field/sint32_field'
require 'protobuf/field/sint64_field'
require 'protobuf/field/bool_field'
require 'protobuf/field/sfixed32_field'
require 'protobuf/field/sfixed64_field'
require 'protobuf/field/fixed32_field'
require 'protobuf/field/fixed64_field'
require 'protobuf/field/field_proxy'

module Protobuf
  module Field
    PREDEFINED_TYPES = {
      :double => ::Protobuf::Field::DoubleField,   
      :float => ::Protobuf::Field::FloatField,
      :int32 => ::Protobuf::Field::Int32Field,    
      :int64 => ::Protobuf::Field::Int64Field,
      :uint32 => ::Protobuf::Field::Uint32Field,   
      :uint64 => ::Protobuf::Field::Uint64Field,
      :sint32 => ::Protobuf::Field::Sint32Field,   
      :sint64 => ::Protobuf::Field::Sint64Field,
      :fixed32 => ::Protobuf::Field::Fixed32Field,
      :fixed64 => ::Protobuf::Field::Fixed64Field,
      :sfixed32 => ::Protobuf::Field::Sfixed32Field, 
      :sfixed64 => ::Protobuf::Field::Sfixed64Field,
      :string => ::Protobuf::Field::StringField,   
      :bytes => ::Protobuf::Field::BytesField,
      :bool => ::Protobuf::Field::BoolField
    }.freeze

    def self.build(message_class, rule, type, name, tag, options={})
      field_class = ::Protobuf::Field::PREDEFINED_TYPES.fetch(type, ::Protobuf::Field::FieldProxy)
      field_class.new(message_class, rule, type, name, tag, options)
    end
  end
end
