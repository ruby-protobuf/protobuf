require 'protobuf/wire_type'

module Protobuf
  module Field
    class BytesField < BaseField

      ##
      # Constants
      #

      BYTES_ENCODING = Encoding::BINARY

      ##
      # Class Methods
      #

      def self.default
        ''
      end

      ##
      # Public Instance Methods
      #

      def acceptable?(val)
        val.is_a?(String) || val.nil? || val.is_a?(Symbol) || val.is_a?(::Protobuf::Message)
      end

      def decode(bytes)
        bytes_to_decode = bytes.dup
        bytes_to_decode.force_encoding(::Protobuf::Field::BytesField::BYTES_ENCODING)
        bytes_to_decode
      end

      def encode(value)
        value_to_encode = ""
        if value.is_a?(::Protobuf::Message)
          value_to_encode = value.encode
        else
          value_to_encode = value.dup
        end

        value_to_encode.force_encoding(::Protobuf::Field::BytesField::BYTES_ENCODING)
        string_size = ::Protobuf::Field::VarintField.encode(value_to_encode.size)

        "#{string_size}#{value_to_encode}"
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
        method_name = field.setter

        message_class.class_eval do
          define_method(method_name) do |val|
            case val
            when String, Symbol
              @values[field.name] = "#{val}"
            when NilClass
              @values.delete(field.name)
            when ::Protobuf::Message
              @values[field.name] = val.dup
            else
              fail TypeError, "Unacceptable value #{val} for field #{field.name} of type #{field.type_class}"
            end
          end
        end

        ::Protobuf.field_deprecator.deprecate_method(message_class, method_name) if field.deprecated?
      end
    end
  end
end
