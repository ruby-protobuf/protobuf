require 'protobuf/field/float_field'

module Protobuf
  module Field
    class DoubleField < FloatField

      ##
      # Class Methods
      #
      def self.decode(bytes)
        bytes.unpack('E').first
      end

      def self.encode(value)
        [value].pack('E')
      end

      ##
      # Public Instance Methods
      #
      def decode(bytes)
        bytes.unpack('E').first
      end

      def encode(value)
        [value].pack('E')
      end

      def wire_type
        ::Protobuf::WireType::FIXED64
      end

    end
  end
end

PROTOBUF_FIELD_DOUBLE_FIELD = ::Protobuf::Field::DoubleField
