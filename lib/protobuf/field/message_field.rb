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

      private

      ##
      # Private Instance Methods
      #

      def define_setter
        field = self
        message_class.class_eval do
          define_method("#{field.name}=") do |val|
            case
            when val.nil?
              @values.delete(field.name)
            when val.is_a?(field.type_class)
              @values[field.name] = val
            when val.respond_to?(:to_proto)
              @values[field.name] = val.to_proto
            when val.respond_to?(:to_hash)
              @values[field.name] = field.type_class.new(val.to_hash)
            else
              fail TypeError, "Expected value of type '#{field.type_class}' for field #{field.name}, but got '#{val.class}'"
            end
          end
        end
      end

    end
  end
end
