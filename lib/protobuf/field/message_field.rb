require 'protobuf/field/base_field'

module Protobuf
  module Field
    class MessageField < BaseField

      ##
      # Public Instance Methods
      #

      def acceptable?(val)
        val.is_a?(type_class) || val.respond_to?(:to_hash)
      end

      def decode(bytes)
        type_class.decode(bytes)
      end

      def encode(value)
        bytes = value.encode
        result = ::Protobuf::Field::VarintField.encode(bytes.size)
        result << bytes
      end

      def message?
        true
      end

      def wire_type
        ::Protobuf::WireType::LENGTH_DELIMITED
      end

      def coerce!(value)
        if value.nil?
          nil
        elsif value.is_a?(type_class)
          value
        elsif value.respond_to?(:to_proto)
          value.to_proto
        elsif value.respond_to?(:to_hash)
          type_class.new(value.to_hash)
        else
          fail TypeError, "Expected value of type '#{type_class}' for field #{name}, but got '#{value.class}'"
        end
      end

    end
  end
end
