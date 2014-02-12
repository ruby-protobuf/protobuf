require 'protobuf/field/varint_field'

module Protobuf
  module Field
    class EnumField < VarintField
      def acceptable?(val)
        ! @type.fetch(val).nil?
      end

      def encode(value)
        super(value.to_i)
      end

      def enum?
        true
      end

      private

      def typed_default_value
        if @default.is_a?(Symbol)
          @type.const_get(@default)
        else
          self.class.default
        end
      end

      def define_setter
        field = self
        @message_class.class_eval do
          define_method("#{field.name}=") do |value|
            orig_value = value
            if value.nil?
              @values.delete(field.name)
            else
              value = field.type.fetch(value)
              raise TypeError, "Invalid Enum value: #{orig_value.inspect} for #{field.name}" unless value

              @values[field.name] = value
            end
          end
        end
      end
    end
  end
end
