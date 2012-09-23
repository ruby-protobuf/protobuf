require 'protobuf/field/uint64_field'

module Protobuf
  module Field
    class Fixed64Field < Uint64Field
      def wire_type
        ::WireType::FIXED64
      end

      def decode(bytes)
        # we don't use 'Q' for pack/unpack. 'Q' is machine-dependent.
        values = bytes.unpack('VV')
        values[0] + (values[1] << 32)
      end

      def encode(value)
        # we don't use 'Q' for pack/unpack. 'Q' is machine-dependent.
        [value & 0xffff_ffff, value >> 32].pack('VV')
      end
    end
  end
end
