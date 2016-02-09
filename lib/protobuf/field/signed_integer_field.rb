require 'protobuf/field/varint_field'

module Protobuf
  module Field
    class SignedIntegerField < VarintField

      ##
      # Public Instance Methods
      #

      def decode(value)
        if (value & 1).zero?
          value >> 1   # positive value
        else
          ~value >> 1  # negative value
        end
      end

      def define_decode_setter
        field = self
        field_name = field.name
        tag_method_name = "_protobuf_decode_setter_#{field.tag}"

        message_class.class_eval do
          define_method(tag_method_name) do |val|
            @encode = nil
            @values[field_name] = field.decode(val)
          end
        end
      end

      def encode(value)
        if value >= 0
          VarintField.encode(value << 1)
        else
          VarintField.encode(~(value << 1))
        end
      end

    end
  end
end
