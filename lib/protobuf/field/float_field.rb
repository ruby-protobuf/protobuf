require 'protobuf/field/base_field'

module Protobuf
  module Field
    class FloatField < BaseField

      ##
      # Class Methods
      #

      def self.default
        0.0
      end

      ##
      # Public Instance Methods
      #

      def acceptable?(val)
        val.respond_to?(:to_f)
      end

      def decode(bytes)
        bytes.unpack('e').first
      end

      def encode(value)
        [value].pack('e')
      end

      def wire_type
        WireType::FIXED32
      end

      ##
      # Private Instance Methods
      #

      def define_setter
        field = self
        message_class.class_eval do
          define_method(field.setter_method_name) do |val|
            field.warn_if_deprecated

            if val.nil? || (val.respond_to?(:empty?) && val.empty?)
              @values.delete(field.name)
            elsif field.acceptable?(val)
              @values[field.name] = Float(val)
            else
              raise TypeError, "Unacceptable value #{val} for field #{field.name} of type #{field.type_class}"
            end
          end
        end
      end

    end
  end
end

