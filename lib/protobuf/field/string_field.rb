require 'protobuf/field/bytes_field'

module Protobuf
  module Field
    class StringField < BytesField
      ENCODING = 'UTF-8'.freeze

      def decode(bytes)
        bytes.force_encoding(::Protobuf::Field::StringField::ENCODING)
        bytes
      end

      # TODO: make replace character configurable?
      def encode(value)
        value = value.dup if value.frozen?
        value.encode!(::Protobuf::Field::StringField::ENCODING, :invalid => :replace, :undef => :replace, :replace => "")
        value.force_encoding(::Protobuf::Field::BytesField::BYTES_ENCODING)

        string_size = ::Protobuf::Field::VarintField.encode(value.size)
        string_size << value
      end
    end
  end
end
