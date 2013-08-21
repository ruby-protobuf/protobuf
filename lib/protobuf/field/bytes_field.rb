require 'protobuf/wire_type'

module Protobuf
  module Field
    class BytesField < BaseField
      BYTES_ENCODING = "ASCII-8BIT".freeze

      def self.default
        ''
      end

      def acceptable?(val)
        if val.nil? || val.is_a?(::Protobuf::Message) || val.instance_of?(String)
          return true
        else
          raise TypeError, "Cannot set field : #{name} to value : #{val}"
        end
      end

      def decode(bytes)
        bytes.force_encoding(::Protobuf::Field::BytesField::BYTES_ENCODING)
        bytes
      end

      def define_setter
        field = self
        @message_class.class_eval do
          define_method(field.setter_method_name) do |val|
            begin
              field.warn_if_deprecated

              if val.nil?
                @values.delete(field.name)
              elsif field.acceptable?(val)
                @values[field.name] = val.dup
              else
                raise TypeError, "Unacceptable value #{val} for field #{field.name} of type #{field.type}"
              end
            rescue NoMethodError => ex
              ::Protobuf::Logger.error { ex.message }
              ::Protobuf::Logger.error { ex.backtrace.join("\n") }
              raise TypeError, "Got NoMethodError attempting to set #{val} for field #{field.name} of type #{field.type}: #{ex.message}"
            end
          end
        end
      end

      def encode(value)
        value = value.encode if value.is_a?(::Protobuf::Message)
        value.force_encoding(::Protobuf::Field::BytesField::BYTES_ENCODING)

        string_size = ::Protobuf::Field::VarintField.encode(value.size)
        string_size << value
      end

      def wire_type
        ::Protobuf::WireType::LENGTH_DELIMITED
      end
    end
  end
end
