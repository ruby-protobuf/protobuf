require 'protobuf/field/base_field'

module Protobuf
  module Field
    class MessageField < BaseField

      ##
      # Public Instance Methods
      #

      def acceptable?(val)
        unless val.instance_of?(type) || val.respond_to?(:to_hash)
          raise TypeError, "Expected value of type '#{self.type}' for field #{self.name}, but got '#{val.class}'"
        end
        true
      end

      def decode(bytes)
        type.decode(bytes)
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

      def define_setter
        field = self
        @message_class.class_eval do
          define_method("#{field.name}=") do |val|
            case
            when val.nil? then
              @values.delete(field.name)
            when val.is_a?(field.type) then
              @values[field.name] = val
            when val.respond_to?(:to_proto) then
              @values[field.name] = val.to_proto
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
