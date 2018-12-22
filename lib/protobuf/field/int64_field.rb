require 'protobuf/field/integer_field'

module Protobuf
  module Field
    class Int64Field < IntegerField
      if defined?(::ProtobufJavaHelpers::Int64ProtobufField)
        include ::ProtobufJavaHelpers::Int64ProtobufField
        extend ::ProtobufJavaHelpers::Int64ProtobufField
        include ::ProtobufJavaHelpers::Varinter
        extend ::ProtobufJavaHelpers::Varinter
      end

      ##
      # Class Methods
      #
      def self.decode(value)
        ::PROTOBUF_FIELD_INTEGER_FIELD.decode(value)
      end

      def self.encode(value)
        ::PROTOBUF_FIELD_INTEGER_FIELD.encode(value)
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

PROTOBUF_FIELD_INT64_FIELD = ::Protobuf::Field::Int64Field
