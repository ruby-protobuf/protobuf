require 'protobuf/field/int32_field'

module Protobuf
  module Field
    class Sfixed32Field < Int32Field
      def wire_type
        ::Protobuf::WireType::FIXED32
      end

      def decode(bytes)
        value  = bytes.unpack('V').first
        value -= 0x1_0000_0000 if (value & 0x8000_0000).nonzero?
        value
      end

      def encode(value)
        [value].pack('V')
      end
    end
  end
end
