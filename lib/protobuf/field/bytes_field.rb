require 'protobuf/wire_type'

module Protobuf
  module Field
    class BytesField < BaseField
      BYTES_ENCODING = "ASCII-8BIT".freeze

      def self.default
        ''
      end

      def acceptable?(val)
        if val.nil? || val.is_a?(::Protobuf::Message) || val.instance_of?(String)
          return true
        else
          raise TypeError, "Cannot set field : #{name} to value : #{val}"
        end
      end

      def decode(bytes)
        bytes.force_encoding(::Protobuf::Field::BytesField::BYTES_ENCODING) 
        bytes
      end

      def encode(value)
        value = value.serialize_to_string if value.is_a?(::Protobuf::Message)
        value.force_encoding(::Protobuf::Field::BytesField::BYTES_ENCODING) 

        string_size = ::Protobuf::Field::VarintField.encode(value.size)
        string_size << value
      end

      def wire_type
        ::Protobuf::WireType::LENGTH_DELIMITED
      end
    end
  end
end
