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
              stream << "#{field.tag_encoded}#{field.encode(val)}"
            end
          end
        else
          stream << "#{field.tag_encoded}#{field.encode(value)}"
        end
      end

      stream
    end
  end
end
