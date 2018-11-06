require 'protobuf/field/varint_field'

module Protobuf
  module Field
    class SignedIntegerField < VarintField

      ##
      # Class Methods
      #

      def self.decode(value)
        if (value & 1).zero?
          value >> 1   # positive value
        else
          ~value >> 1  # negative value
        end
      end

      def self.encode(value)
        if value >= 0
          ::PROTOBUF_FIELD_VARINT_FIELD.encode(value << 1)
        else
          ::PROTOBUF_FIELD_VARINT_FIELD.encode(~(value << 1))
        end
      end

      ##
      # Public Instance Methods
      #

      def decode(value)
        if (value & 1).zero?
          value >> 1   # positive value
        else
          ~value >> 1  # negative value
        end
      end

      def encode(value)
        if value >= 0
          ::PROTOBUF_FIELD_VARINT_FIELD.encode(value << 1)
        else
          ::PROTOBUF_FIELD_VARINT_FIELD.encode(~(value << 1))
        end
      end

    end
  end
end

PROTOBUF_FIELD_SIGNED_INTEGER_FIELD = ::Protobuf::Field::SignedIntegerField
