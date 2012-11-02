require 'protobuf/field/base_field'

module Protobuf
  module Field
    class MessageField < BaseField
      RAISE_TYPE = lambda { |field, val| raise TypeError, "Expected value of type '#{field.type}', but got '#{val.class}'" }

      ##
      # Public Instance Methods
      #
      def acceptable?(val)
        RAISE_TYPE.call(self, val) unless val.instance_of?(type) || val.respond_to?(:to_hash)
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
            case 
            when val.nil? then
              @values.delete(field.name)
            when val.is_a?(field.type) then
              @values[field.name] = val
            when val.respond_to?(:to_hash) then
              @values[field.name] = field.type.new(val.to_hash)
            else
              RAISE_TYPE.call(field, val)
            end
          end
        end
      end
    end
  end
end
