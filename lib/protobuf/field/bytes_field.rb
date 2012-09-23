module Protobuf
  module Field
    class BytesField < BaseField
      def self.default
        ''
      end

      def wire_type
        WireType::LENGTH_DELIMITED
      end

      def acceptable?(val)
        if val.is_a?(::Protobuf::Message) || val.instance_of?(String)
          return true
        end

        raise TypeError
      end

      def decode(bytes)
        bytes.force_encoding('ASCII-8BIT') if bytes.respond_to?(:force_encoding)
        bytes
      end

      def encode(value)
        if value.is_a?(::Protobuf::Message)
          value = value.serialize_to_string
        else
          value = value.dup
          value.force_encoding('ASCII-8BIT') if value.respond_to?(:force_encoding)
        end

        string_size = VarintField.encode(value.size)
        string_size << value
      end
    end
  end
end
