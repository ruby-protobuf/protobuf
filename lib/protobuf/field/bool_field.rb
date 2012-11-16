require 'protobuf/field/varint_field'

module Protobuf
  module Field
    class BoolField < VarintField
      def self.default
        false
      end

      def acceptable?(val)
        [true, false].include?(val)
      end

      def decode(value)
        value == 1
      end

      def define_getter
        super

        field = self
        @message_class.class_eval do
          define_method("#{field.getter_method_name}?") do
            field.warn_if_deprecated
            @values.fetch(field.name, field.default_value)
          end
        end
      end

      def encode(value)
        [value ? 1 : 0].pack('C')
      end
    end
  end
end
