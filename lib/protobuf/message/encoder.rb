module Protobuf
  class Message
    module Encoder

      def self.encode(stream, message)
        message.each_field_for_serialization do |field, value|
          encode_field(field, value, stream)
        end

        stream
      end

      private

      def self.encode_field(field, value, stream)
        if field.repeated?
          encode_repeated_field(field, value, stream)
        else
          write_pair(stream, field, value)
        end
      end

      def self.encode_packed_field(field, value, stream)
        key = (field.tag << 3) | ::Protobuf::WireType::LENGTH_DELIMITED
        packed_value = value.map { |val| field.encode(val) }.join
        stream << ::Protobuf::Field::VarintField.encode(key)
        stream << ::Protobuf::Field::VarintField.encode(packed_value.size)
        stream << packed_value
      end

      def self.encode_repeated_field(field, value, stream)
        if field.packed?
          encode_packed_field(field, value, stream)
        else
          value.each { |val| write_pair(stream, field, val) }
        end
      end

      # Encode key and value, and write to +stream+.
      def self.write_pair(stream, field, value)
        key = (field.tag << 3) | field.wire_type
        stream << ::Protobuf::Field::VarintField.encode(key)
        stream << field.encode(value)
      end

    end
  end
end

