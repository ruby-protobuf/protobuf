require 'protobuf/field/varint_field'

module Protobuf
  module Field
    class BoolField < VarintField
      FALSE_ENCODE = [0].pack('C')
      FALSE_STRING = "false".freeze
      TRUE_ENCODE = [1].pack('C')
      TRUE_STRING = "true".freeze

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
        val == true || val == false || val == TRUE_STRING || val == FALSE_STRING
      end

      def coerce!(val)
        return true if val == true
        return false if val == false
        return true if val == TRUE_STRING
        return false if val == FALSE_STRING

        val
      end

      def decode(value)
        value == 1
      end

      def encode(value)
        value ? TRUE_ENCODE : FALSE_ENCODE
      end

      private

      ##
      # Private Instance Methods
      #

      def define_accessor(simple_field_name, _fully_qualified_field_name)
        super
        message_class.class_eval do
          alias_method "#{simple_field_name}?", simple_field_name
        end
      end

    end
  end
end
