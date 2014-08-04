require 'protobuf/field/varint_field'

module Protobuf
  module Field
    class EnumField < VarintField

      ##
      # Class Methods
      #

      def self.default
        raise NoMethodError, "#{self}.#{__method__} must be called on an instance"
      end

      ##
      # Public Instance Methods
      #

      def acceptable?(val)
        ! type_class.fetch(val).nil?
      end

      def encode(value)
        super(value.to_i)
      end

      def decode(value)
        if acceptable?(value)
          value
        end
      end

      def enum?
        true
      end

      private

      ##
      # Private Instance Methods
      #

      def define_setter
        field = self
        message_class.class_eval do
          define_method("#{field.name}=") do |value|
            orig_value = value
            if value.nil?
              @values.delete(field.name)
            else
              value = field.type_class.fetch(value)
              raise TypeError, "Invalid Enum value: #{orig_value.inspect} for #{field.name}" unless value

              @values[field.name] = value
            end
          end
        end
      end

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

