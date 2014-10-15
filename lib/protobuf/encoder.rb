module Protobuf
  class Encoder

    def self.encode(stream, message)
      new(stream, message).encode
    end

    attr_reader :message, :stream

    def initialize(message, stream)
      unless message.respond_to?(:each_field_for_serialization)
        raise ArgumentError, "Message instance must respond to :each_field_for_serialization"
      end

      @message = message
      @stream = stream
    end

    def encode
      message.each_field_for_serialization do |field, value|
        encode_field(field, value)
      end

      stream
    end

    private

    def encode_field(field, value)
      if field.repeated?
        encode_repeated_field(field, value)
      else
        write_pair(field, value)
      end
    end

    def encode_packed_field(field, value)
      key = (field.tag << 3) | ::Protobuf::WireType::LENGTH_DELIMITED
      packed_value = value.map { |val| field.encode(val) }.join
      stream << ::Protobuf::Field::VarintField.encode(key)
      stream << ::Protobuf::Field::VarintField.encode(packed_value.size)
      stream << packed_value
    end

    def encode_repeated_field(field, value)
      if field.packed?
        encode_packed_field(field, value)
      else
        value.each { |val| write_pair(field, val) }
      end
    end

    # Encode key and value, and write to +stream+.
    def write_pair(field, value)
      key = (field.tag << 3) | field.wire_type
      stream << ::Protobuf::Field::VarintField.encode(key)
      stream << field.encode(value)
    end

  end
end
