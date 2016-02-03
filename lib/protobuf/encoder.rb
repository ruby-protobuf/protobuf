module Protobuf
  class Encoder
    def self.encode(message, stream)
      message.each_field_for_serialization do |field, value|
        if field.repeated?
          if field.packed?
            key = (field.tag << 3) | ::Protobuf::WireType::LENGTH_DELIMITED
            packed_value = value.map { |val| field.encode(val) }.join
            stream << ::Protobuf::Field::VarintField.encode(key)
            stream << ::Protobuf::Field::VarintField.encode(packed_value.size)
            stream << packed_value
          else
            value.each do |val|
              key = (field.tag << 3) | field.wire_type
              stream << "#{::Protobuf::Field::VarintField.encode(key)}#{field.encode(value)}"
            end
          end
        else
          key = (field.tag << 3) | field.wire_type
          stream << "#{::Protobuf::Field::VarintField.encode(key)}#{field.encode(value)}"
        end
      end

      stream
    end
  end
end
