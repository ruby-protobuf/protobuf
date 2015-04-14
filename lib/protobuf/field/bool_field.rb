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
        [true, false].include?(val) || %w(true false).include?(val)
      end

      def coerce!(val)
        if val == 'true'
          true
        elsif val == 'false'
          false
        else
          val
        end
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
          alias_method "#{field.getter}?", field.getter
        end
      end

    end
  end
end
