require 'protobuf/field/varint_field'

module Protobuf
  module Field
    class IntegerField < VarintField
      if defined?(::ProtobufJavaHelpers::VarintProtobufField)
        include ::ProtobufJavaHelpers::VarintProtobufField
        extend ::ProtobufJavaHelpers::VarintProtobufField
        include ::ProtobufJavaHelpers::Varinter
        extend ::ProtobufJavaHelpers::Varinter

        def self.encode(value)
          to_varint_64(value)
        end

        def encode(value)
          to_varint_64(value)
        end
      else
        def self.encode(value)
          ::Protobuf::Field::VarintField.encode(value & 0xffff_ffff_ffff_ffff)
        end

        def encode(value)
          # original Google's library uses 64bits integer for negative value
          ::Protobuf::Field::VarintField.encode(value & 0xffff_ffff_ffff_ffff)
        end
      end

      ##
      # Class Methods
      #
      def self.decode(value)
        value -= 0x1_0000_0000_0000_0000 if (value & 0x8000_0000_0000_0000).nonzero?
        value
      end

      ##
      # Public Instance Methods
      #

      def decode(value)
        value -= 0x1_0000_0000_0000_0000 if (value & 0x8000_0000_0000_0000).nonzero?
        value
      end

    end
  end
end

PROTOBUF_FIELD_INTEGER_FIELD = ::Protobuf::Field::IntegerField
