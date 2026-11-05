require 'protobuf/field/integer_field'

module Protobuf
  module Field
    class Int32Field < IntegerField

      ##
      # Class Methods
      #

      def self.max
        INT32_MAX
      end

      def self.min
        INT32_MIN
      end

      ##
      # Public Instance Methods
      #

      # Keep the low 32 bits, as the reference parsers do. A peer that sends
      # an int64 or uint64 value for this field (a compatible schema change)
      # then decodes instead of raising.
      def decode(value)
        value &= 0xffff_ffff
        value >= 0x8000_0000 ? value - 0x1_0000_0000 : value
      end

    end
  end
end
