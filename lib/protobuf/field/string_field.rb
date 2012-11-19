require 'protobuf/field/bytes_field'

module Protobuf
  module Field
    class StringField < BytesField
      ENCODING = 'UTF-8'.freeze

      def encode(value)
        value.force_encoding(::Protobuf::Field::StringField::ENCODING) 
        string_size = ::Protobuf::Field::VarintField.encode(value.size)
        string_size << value
      end
    end
  end
end
