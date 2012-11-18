require 'protobuf/field/bytes_field'

module Protobuf
  module Field
    class StringField < BytesField
      ENCODING = 'UTF-8'.freeze

      def define_setter
        field = self
        @message_class.class_eval do
          define_method(field.setter_method_name) do |val|
            begin
              field.warn_if_deprecated

              if val.nil? || val.empty?
                @values.delete(field.name)
              elsif field.acceptable?(val)
                @values[field.name] = val.dup
              else
                raise TypeError, "unacceptable value #{val} for type #{field.type}"
              end
            rescue NoMethodError => ex
              raise TypeError, "unacceptable value #{val} for type #{field.type} field #{field.name}"
            end
          end
        end
      end

      def encode(value)
        value.force_encoding(::Protobuf::Field::StringField::ENCODING) 
        string_size = ::Protobuf::Field::VarintField.encode(value.size)
        string_size << value
      end
    end
  end
end
