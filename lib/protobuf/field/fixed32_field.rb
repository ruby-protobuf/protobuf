require 'protobuf/field/uint32_field.rb'

module Protobuf
  module Field
    class Fixed32Field < Uint32Field
      def wire_type
       ::WireType::FIXED32
      end

      def decode(bytes)
        bytes.unpack('V').first
      end

      def encode(value)
        [value].pack('V')
      end
    end
  end
end
