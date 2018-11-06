require 'protobuf/field/uint32_field'

module Protobuf
  module Field
    class Fixed32Field < Uint32Field

      ##
      # Class Methods
      #

      def self.decode(bytes)
        bytes.unpack('V').first
      end

      def self.encode(value)
        [value].pack('V')
      end

      ##
      # Public Instance Methods
      #

      def decode(bytes)
        bytes.unpack('V').first
      end

      def encode(value)
        [value].pack('V')
      end

      def wire_type
        ::Protobuf::WireType::FIXED32
      end

    end
  end
end

# jruby-9.1.17.0 :010 > Benchmark.ips do |x|
# jruby-9.1.17.0 :011 >     x.config(:warmup => 10, :time => 15)
# jruby-9.1.17.0 :012?>   x.report("tree") { ::Derp::Stuff::Arf::SAY }
# jruby-9.1.17.0 :013?>   x.report("constant") { DERP_STUFF_ARF }
# jruby-9.1.17.0 :014?>   end
# Warming up --------------------------------------
#                 tree   149.149k i/100ms
#             constant   181.620k i/100ms
# Calculating -------------------------------------
#                 tree      3.024M (± 4.2%) i/s -     45.341M in  15.026418s
#             constant      4.612M (± 4.9%) i/s -     69.016M in  15.007039s
# 
PROTOBUF_FIELD_FIXED32_FIELD = ::Protobuf::Field::Fixed32Field
