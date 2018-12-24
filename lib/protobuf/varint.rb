module Protobuf
  class Varint
    if defined?(::Varint)
      extend ::Varint
    elsif defined?(::ProtobufJavaHelpers)
      extend ::ProtobufJavaHelpers::Varinter

      def self.decode(stream)
        read_varint(stream)
      end
    else
      extend VarintPure
    end
  end
end
