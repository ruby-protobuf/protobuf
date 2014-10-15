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
        message_class.class_eval do
          define_method("#{field.getter}?") do
            field.warn_if_deprecated
            @values.fetch(field.name, field.default_value)
          end
        end
      end

    end
  end
end
