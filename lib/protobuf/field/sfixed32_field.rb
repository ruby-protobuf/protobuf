require 'protobuf/field/int32_field'

module Protobuf
  module Field
    class Sfixed32Field < Int32Field
      if defined?(::ProtobufJavaHelpers::Int32ProtobufField)
        include ::ProtobufJavaHelpers::Int32ProtobufField
        extend ::ProtobufJavaHelpers::Int32ProtobufField
      end

      ##
      # Class Methods
      #

      def self.decode(bytes)
        value  = bytes.unpack('V').first
        value -= 0x1_0000_0000 if (value & 0x8000_0000).nonzero?
        value
      end

      def self.encode(value)
        [value].pack('V')
      end

      ##
      # Public Instance Methods
      #

      def decode(bytes)
        value  = bytes.unpack('V').first
        value -= 0x1_0000_0000 if (value & 0x8000_0000).nonzero?
        value
      end

      def encode(value)
        [value].pack('V')
      end

      def wire_type
        ::Protobuf::WireType::FIXED32
      end

    end
  end
end

PROTOBUF_FIELD_SFIXED32_FIELD = ::Protobuf::Field::Sfixed32Field
