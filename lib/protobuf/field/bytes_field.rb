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
        val.nil? || val.is_a?(String) || val.is_a?(Symbol) || val.is_a?(::Protobuf::Message)
      end

      def decode(bytes)
        bytes_to_decode = bytes.dup
        bytes_to_decode.force_encoding(::Protobuf::Field::BytesField::BYTES_ENCODING)
        bytes_to_decode
      end

      def encode(value)
        value_to_encode = value.dup
        value_to_encode = value.encode if value.is_a?(::Protobuf::Message)
        value_to_encode.force_encoding(::Protobuf::Field::BytesField::BYTES_ENCODING)

        string_size = ::Protobuf::Field::VarintField.encode(value_to_encode.size)
        string_size << value_to_encode
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
            begin
              val = "#{val}" if val.is_a?(Symbol)

              if val.nil?
                @values.delete(field.name)
              elsif field.acceptable?(val)
                clear_oneof_group(field.oneof_name) if field.oneof?
                @values[field.name] = val.dup
              else
                fail TypeError, "Unacceptable value #{val} for field #{field.name} of type #{field.type_class}"
              end
            rescue NoMethodError => ex
              logger.error { ex.message }
              logger.error { ex.backtrace.join("\n") }
              raise TypeError, "Got NoMethodError attempting to set #{val} for field #{field.name} of type #{field.type_class}: #{ex.message}"
            end
          end
        end

        ::Protobuf.field_deprecator.deprecate_method(message_class, method_name) if field.deprecated?
      end
    end
  end
end
