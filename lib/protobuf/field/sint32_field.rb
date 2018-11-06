require 'protobuf/field/signed_integer_field'

module Protobuf
  module Field
    class Sint32Field < SignedIntegerField
      if defined?(::ProtobufJavaHelpers::Sint32ProtobufField)
        include ::ProtobufJavaHelpers::Sint32ProtobufField
        extend ::ProtobufJavaHelpers::Sint32ProtobufField
      end

      ##
      # Class Methods
      #

      def self.decode(value)
        ::PROTOBUF_FIELD_SIGNED_INTEGER_FIELD.decode(value)
      end

      def self.encode(value)
        ::PROTOBUF_FIELD_SIGNED_INTEGER_FIELD.encode(value)
      end

      def self.max
        INT32_MAX
      end

      def self.min
        INT32_MIN
      end

    end
  end
end

PROTOBUF_FIELD_SINT32_FIELD = ::Protobuf::Field::Sint32Field
