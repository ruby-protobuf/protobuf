require 'protobuf/field/varint_field'

module Protobuf
  module Field
    class BoolField < VarintField
      FALSE_STRING = "false".freeze
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
        [true, false].include?(val) || %w(true false).include?(val)
      end

      def coerce!(val)
        case val
        when String
          val == TRUE_STRING
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

      def define_accessor(simple_field_name, _fully_qualified_field_name)
        super
        message_class.class_eval do
          alias_method "#{simple_field_name}?", simple_field_name
        end
      end

    end
  end
end
