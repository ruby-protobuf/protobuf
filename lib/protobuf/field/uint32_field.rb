require 'protobuf/field/varint_field'

module Protobuf
  module Field
    class Uint32Field < VarintField
      if defined?(::ProtobufJavaHelpers::Uint32ProtobufField)
        include ::ProtobufJavaHelpers::Uint32ProtobufField
        extend ::ProtobufJavaHelpers::Uint32ProtobufField
      end

      ##
      # Class Methods
      #
      def self.decode(value)
        value
      end

      def self.encode(value)
        ::PROTOBUF_FIELD_VARINT_FIELD.encode(value)
      end

      def self.max
        UINT32_MAX
      end

      def self.min
        0
      end

    end
  end
end

PROTOBUF_FIELD_UINT32_FIELD = ::Protobuf::Field::Uint32Field
