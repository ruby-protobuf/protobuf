require 'protobuf/field/varint_field'

module Protobuf
  module Field
    class BoolField < VarintField
      def self.default
        false
      end

      def acceptable?(val)
        raise TypeError unless [true, false].include?(val)
        true
      end

      def decode(value)
        value == 1
      end

      def encode(value)
        [value ? 1 : 0].pack('C')
      end
    end
  end
end
