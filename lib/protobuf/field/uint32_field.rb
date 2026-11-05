require 'protobuf/field/varint_field'

module Protobuf
  module Field
    class Uint32Field < VarintField

      ##
      # Class Methods
      #

      def self.max
        UINT32_MAX
      end

      def self.min
        0
      end

      ##
      # Public Instance Methods
      #

      # Keep the low 32 bits, as the reference parsers do.
      def decode(value)
        value & 0xffff_ffff
      end

    end
  end
end
