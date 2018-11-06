require 'protobuf/field/signed_integer_field'

module Protobuf
  module Field
    class Sint64Field < SignedIntegerField
      if defined?(::ProtobufJavaHelpers::Sint64ProtobufField)
        include ::ProtobufJavaHelpers::Sint64ProtobufField
        extend ::ProtobufJavaHelpers::Sint64ProtobufField
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
        INT64_MAX
      end

      def self.min
        INT64_MIN
      end

    end
  end
end

PROTOBUF_FIELD_SINT64_FIELD = ::Protobuf::Field::Sint64Field
