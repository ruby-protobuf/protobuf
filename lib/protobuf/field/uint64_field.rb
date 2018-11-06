require 'protobuf/field/varint_field'

module Protobuf
  module Field
    class Uint64Field < VarintField
      if defined?(::ProtobufJavaHelpers::Uint64ProtobufField)
        include ::ProtobufJavaHelpers::Uint64ProtobufField
        extend ::ProtobufJavaHelpers::Uint64ProtobufField
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
        UINT64_MAX
      end

      def self.min
        0
      end

    end
  end
end

PROTOBUF_FIELD_UINT64_FIELD = ::Protobuf::Field::Uint64Field
