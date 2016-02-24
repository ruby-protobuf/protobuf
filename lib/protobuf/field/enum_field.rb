require 'protobuf/field/varint_field'

module Protobuf
  module Field
    class EnumField < VarintField

      ##
      # Class Methods
      #

      def self.default
        fail NoMethodError, "#{self}.#{__method__} must be called on an instance"
      end

      ##
      # Public Instance Methods
      #

      def acceptable?(val)
        !type_class.fetch(val).nil?
      end

      def encode(value)
        super(value.to_i)
      end

      def decode(value)
        value if acceptable?(value)
      end

      def enum?
        true
      end

      def coerce!(value)
        enum_value = type_class.fetch(value)
        fail TypeError, "Invalid Enum value: #{value.inspect} for #{name}" unless enum_value
        enum_value
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
