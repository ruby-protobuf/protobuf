require 'protobuf/field/base_field'

module Protobuf
  module Field
    class MessageField < BaseField

      ##
      # Public Instance Methods
      #

      def acceptable?(value)
        unless value.instance_of?(type_class) || value.respond_to?(:to_hash)
          raise TypeError, "Expected value of type '#{type_class}' for field #{name}, but got '#{value.class}'"
        end

        true
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
          define_method("#{field.name}=") do |value|
            case
            when value.nil? then
              @values.delete(field.name)
            when value.is_a?(field.type_class) then
              clear_oneof_group(field.oneof_name) if field.oneof?
              @values[field.name] = value
            when value.respond_to?(:to_proto) then
              clear_oneof_group(field.oneof_name) if field.oneof?
              @values[field.name] = value.to_proto
            when value.respond_to?(:to_hash) then
              clear_oneof_group(field.oneof_name) if field.oneof?
              @values[field.name] = field.type_class.new(value.to_hash)
            else
              raise TypeError, "Expected value of type '#{field.type_class}' for field #{field.name}, but got '#{value.class}'"
            end
          end
        end
      end

    end
  end
end

