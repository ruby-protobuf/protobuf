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

module Protobuf
  module Field
    PREDEFINED_TYPES = [
      ::Protobuf::Field::DoubleField,
      ::Protobuf::Field::FloatField,
      ::Protobuf::Field::Int32Field,
      ::Protobuf::Field::Int64Field,
      ::Protobuf::Field::Uint32Field,
      ::Protobuf::Field::Uint64Field,
      ::Protobuf::Field::Sint32Field,
      ::Protobuf::Field::Sint64Field,
      ::Protobuf::Field::Fixed32Field,
      ::Protobuf::Field::Fixed64Field,
      ::Protobuf::Field::Sfixed32Field,
      ::Protobuf::Field::Sfixed64Field,
      ::Protobuf::Field::StringField,
      ::Protobuf::Field::BytesField,
      ::Protobuf::Field::BoolField
    ].freeze

    def self.build(message_class, rule, type, name, tag, options = {})
      field_class = type_message_or_enum(type)
      field_class.new(message_class, rule, type, name, tag, options)
    end

    def self.type_message_or_enum(defined_type)
      return defined_type if ::Protobuf::Field::PREDEFINED_TYPES.include?(defined_type)
      return EnumField if defined_type < Enum
      return MessageField if defined_type < Message
      raise "lost in the wilderness #{defined_type}"
    end

  end
end
