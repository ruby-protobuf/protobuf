require 'protobuf/field/bytes_field'

module Protobuf
  module Field
    class StringField < BytesField
      ENCODING = 'UTF-8'.freeze

      def decode(bytes)
        bytes_to_decode = bytes.dup
        bytes_to_decode.force_encoding(::Protobuf::Field::StringField::ENCODING)
        bytes_to_decode
      end

      # TODO: make replace character configurable?
      def encode(value)
        value_to_encode = value.dup
        value_to_encode.encode!(::Protobuf::Field::StringField::ENCODING, :invalid => :replace, :undef => :replace, :replace => "")
        value_to_encode.force_encoding(::Protobuf::Field::BytesField::BYTES_ENCODING)

        string_size = ::Protobuf::Field::VarintField.encode(value_to_encode.size)
        string_size << value_to_encode
      end
    end
  end
end
