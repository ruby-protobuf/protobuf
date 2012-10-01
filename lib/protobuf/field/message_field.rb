require 'protobuf/field/base_field'

module Protobuf
  module Field
    class MessageField < BaseField
      ##
      # Public Instance Methods
      #
      def acceptable?(val)
        raise TypeError unless val.instance_of?(type) || val.instance_of?(Hash)
        true
      end

      def decode(bytes)
        message = type.new
        message.parse_from_string(bytes)
        message
      end
      
      def encode(value)
        bytes = value.serialize_to_string
        result = VarintField.encode(bytes.size)
        result << bytes
      end

      def wire_type
        ::Protobuf::WireType::LENGTH_DELIMITED
      end

      private

      def define_setter
        field = self
        @message_class.class_eval do
          define_method("#{field.name}=") do |val|
            case val
            when nil then
              @values.delete(field.name)
            when Hash then
              @values[field.name] = field.type.new(val)
            when field.type then
              @values[field.name] = val
            else
              raise TypeError, "Expected value of type '#{field.type}', but got '#{val.class}'"
            end
          end
        end
      end
    end
  end
end
