require 'protobuf/field/base_field'

module Protobuf
  module Field
    class FloatField < BaseField

      ##
      # Class Methods
      #

      def self.coerce!(val)
        Float(val)
      rescue ArgumentError
        fail TypeError, "Expected value of for FloatField got '#{val.class}'"
      end

      def self.decode(bytes)
        bytes.unpack('e').first
      end

      def self.default
        0.0
      end

      def self.encode(value)
        [value].pack('e')
      end

      ##
      # Public Instance Methods
      #

      def acceptable?(val)
        val.respond_to?(:to_f)
      end

      def coerce!(val)
        Float(val)
      rescue ArgumentError
        fail TypeError, "Expected value of type '#{type_class}' for field #{name}, but got '#{val.class}'"
      end

      def decode(bytes)
        bytes.unpack('e').first
      end

      def encode(value)
        [value].pack('e')
      end

      def wire_type
        ::Protobuf::WireType::FIXED32
      end

    end
  end
end

PROTOBUF_FIELD_FLOAT_FIELD = ::Protobuf::Field::FloatField
