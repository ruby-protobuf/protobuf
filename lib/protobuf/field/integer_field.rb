require 'protobuf/field/varint_field'

module Protobuf
  module Field
    class IntegerField < VarintField

      ##
      # Public Instance Methods
      #

      def decode(value)
        value -= 0x1_0000_0000_0000_0000 if (value & 0x8000_0000_0000_0000).nonzero?
        value
      end

      def define_decode_setter
        field = self
        name_method_name = "_protobuf_decode_setter_#{field.name}"
        tag_method_name = "_protobuf_decode_setter_#{field.tag}"

        message_class.class_eval do
          define_method(name_method_name) do |val|
            @values[field.name] = field.decode(val)
          end

          alias_method tag_method_name, name_method_name
        end
      end

      def encode(value)
        # original Google's library uses 64bits integer for negative value
        ::Protobuf::Field::VarintField.encode(value & 0xffff_ffff_ffff_ffff)
      end

    end
  end
end
