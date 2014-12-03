require 'protobuf/field/varint_field'

module Protobuf
  module Field
    class BoolField < VarintField

      ##
      # Class Methods
      #

      def self.default
        false
      end

      ##
      # Public Instance Methods
      # #

      def acceptable?(val)
        [true, false].include?(val)
      end

      def decode(value)
        value == 1
      end

      def encode(value)
        [value ? 1 : 0].pack('C')
      end

      private

      ##
      # Private Instance Methods
      #

      def define_getter
        super

        field = self
        method_name = "#{field.getter}?"

        message_class.class_eval do
          define_method(method_name) do
            @values.fetch(field.name, field.default_value)
          end
          ::Protobuf.deprecator.deprecate_methods(method_name)
        end
      end

    end
  end
end
