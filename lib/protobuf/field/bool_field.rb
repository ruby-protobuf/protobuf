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
