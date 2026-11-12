module Protobuf
  class Varint
    if defined?(::Varint)
      extend ::Varint

      def self.encode(value)
        bytes = []
        until value < 128
          bytes << (0x80 | (value & 0x7f))
          value >>= 7
        end
        (bytes << value).pack('C*')
      end
    elsif defined?(::ProtobufJavaHelpers)
      extend ::ProtobufJavaHelpers::EncodeDecode

      # The helper's decode is plain Ruby with no length limit. VarintPure's
      # decode is as fast and stops after 10 bytes. Encode stays in Java.
      define_singleton_method(:decode, ::Protobuf::VarintPure.instance_method(:decode))
    else
      extend VarintPure
    end
  end
end
