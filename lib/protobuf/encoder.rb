module Protobuf
  class Encoder
    def self.encode(message, stream)
      message.each_field_for_serialization do |field, value|
        if field.repeated?
          if field.packed?
            packed_value = value.map { |val| field.encode(val) }.join
            stream << "#{field.tag_encoded}#{::Protobuf::Field::VarintField.encode(packed_value.size)}#{packed_value}"
          else
            value.each do |val|
              field.encode_to_stream(val, stream)
            end
          end
        else
          field.encode_to_stream(value, stream)
        end
      end

      stream
    end
  end
end
