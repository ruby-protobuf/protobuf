require 'protobuf/field/signed_integer_field'

module Protobuf
  module Field
    class Sint32Field < SignedIntegerField

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

      # Keep the low 32 bits before the zigzag decode, as the reference
      # parsers do. A peer that sends a sint64 value then decodes.
      def decode(value)
        super(value & 0xffff_ffff)
      end

    end
  end
end
