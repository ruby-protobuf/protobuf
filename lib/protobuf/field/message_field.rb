require 'protobuf/field/base_field'

module Protobuf
  module Field
    class MessageField < BaseField

      ##
      # Public Instance Methods
      #

      def acceptable?(val)
        val.is_a?(type_class) || val.respond_to?(:to_hash) || val.respond_to?(:to_proto)
      end

      def decode(bytes)
        type_class.decode(bytes)
      end

      # Whether Decoder can decode this field's messages without recursion and
      # store them with #store_decoded. Not when this field, its message class,
      # or its set method changes how a message decodes, and not for a map with
      # enum values (MapSetMethod reads the entry bytes for those).
      def iterative_decode?
        return @iterative_decode unless @iterative_decode.nil?

        @iterative_decode = method(:decode).owner == ::Protobuf::Field::MessageField &&
                            method(:set).owner == ::Protobuf::Field::BaseField &&
                            type_class._protobuf_standard_decode? &&
                            !(map? && type_class.get_field(:value).enum?)
      end

      def encode(value)
        bytes = value.encode
        # VarintField.encode can return a frozen cached string, so do not append to it.
        "#{::Protobuf::Field::VarintField.encode(bytes.bytesize)}#{bytes}"
      end

      def message?
        true
      end

      def wire_type
        ::Protobuf::WireType::LENGTH_DELIMITED
      end

      def coerce!(value)
        return nil if value.nil?

        coerced_value = if value.respond_to?(:to_proto)
                          value.to_proto
                        elsif value.respond_to?(:to_hash)
                          type_class.new(value.to_hash)
                        else
                          value
                        end

        return coerced_value if coerced_value.is_a?(type_class)

        fail TypeError, "Expected value of type '#{type_class}' for field #{name}, but got '#{value.class}'"
      end

    end
  end
end
