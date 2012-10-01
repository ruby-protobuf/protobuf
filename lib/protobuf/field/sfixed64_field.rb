require 'protobuf/field/int64_field'

module Protobuf
  module Field
    class Sfixed64Field < Int64Field
      def wire_type
        ::Protobuf::WireType::FIXED64
      end

      def decode(bytes)
        # we don't use 'Q' for pack/unpack. 'Q' is machine-dependent.
        values = bytes.unpack('VV')
        value  = values[0] + (values[1] << 32)
        value -= 0x1_0000_0000_0000_0000 if (value & 0x8000_0000_0000_0000).nonzero?
        value
      end

      def encode(value)
        # we don't use 'Q' for pack/unpack. 'Q' is machine-dependent.
        [value & 0xffff_ffff, value >> 32].pack('VV')
      end
    end
  end
end
