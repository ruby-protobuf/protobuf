require 'protobuf/field/integer_field'

module Protobuf
  module Field
    class EnumField < IntegerField

      ##
      # Class Methods
      #

      def self.default
        fail NoMethodError, "#{self}.#{__method__} must be called on an instance"
      end

      ##
      # Public Instance Methods
      #
      def encode(value)
        # original Google's library uses 64bits integer for negative value
        ::Protobuf::Field::VarintField.encode(value.to_i & 0xffff_ffff_ffff_ffff)
      end

      # Enum values are int32 on the wire. Keep the low 32 bits of a wider
      # varint, as Int32Field does. Return nil for a value that the enum does
      # not define.
      def decode(value)
        value &= 0xffff_ffff
        value -= 0x1_0000_0000 if value >= 0x8000_0000
        value if acceptable?(value)
      end

      def acceptable?(val)
        !type_class.fetch(val).nil?
      end

      def enum?
        true
      end

      def coerce!(value)
        type_class.fetch(value) || fail(TypeError, "Invalid Enum value: #{value.inspect} for #{name}")
      end

      private

      ##
      # Private Instance Methods
      #

      def typed_default_value
        if default.is_a?(Symbol)
          type_class.const_get(default)
        else
          type_class.fetch(default) || type_class.enums.first
        end
      end

    end
  end
end
