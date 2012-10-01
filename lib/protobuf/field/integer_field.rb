require 'protobuf/field/varint_field'

module Protobuf
  module Field
    class IntegerField < VarintField

      def encode(value)
        # original Google's library uses 64bits integer for negative value
        VarintField.encode(value & 0xffff_ffff_ffff_ffff)
      end

      def decode(value)
        value -= 0x1_0000_0000_0000_0000 if (value & 0x8000_0000_0000_0000).nonzero?
        value
      end

    end
  end
end
