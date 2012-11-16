require 'protobuf/field/base_field'

module Protobuf
  module Field
    class FloatField < BaseField
      def self.default; 0.0; end
      def self.max;  1.0/0; end
      def self.min; -1.0/0; end
      def max;  1.0/0; end
      def min; -1.0/0; end

      def wire_type
        WireType::FIXED32
      end

      def decode(bytes)
        bytes.unpack('e').first
      end

      def encode(value)
        [value].pack('e')
      end

      def acceptable?(val)
        (val > min || val < max) rescue false
      end
    end
  end
end
