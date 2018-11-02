require 'base64'
require "./lib/protobuf/varint_pure"
require "./lib/jars/varinter.jar"
require "varinter"
require 'benchmark/ips'
class Fixnum
  include Varinter
end

class StringIO
  include Varinter
end

require 'pry'
require "./spec/support/protos/resource.pb"

VALUES = {
  0 => "AA==",
  5 => "BQ==",
  51 => "Mw==",
  9_192 => "6Ec=",
  80_389 => "hfQE",
  913_389 => "7d83",
  516_192_829_912_693 => "9eyMkpivdQ==",
  9_999_999_999_999_999_999 => "//+fz8jgyOOKAQ==",
}.freeze

DECODED = VALUES.map do |_, value|
  Base64.decode64(value)
end

class Derp
  CACHE_LIMIT = 2048
  extend ::Protobuf::VarintPure
      # Because all tags and enums are calculated as VarInt it is "most common" to have
      # values < CACHE_LIMIT (low numbers) which is defaulting to 1024
      def self.cached_varint(value)
        @_varint_cache ||= []
        @_varint_cache[value] ||= _encode(value)
      end

      def self.encode_cache_hash(value)
        return cached_varint(value) if value >= 0 && value <= CACHE_LIMIT

        _encode(value)
      end

      def self._encode(value)
        bytes = []
        until value < 128
          bytes << (0x80 | (value & 0x7f))
          value >>= 7
        end
        (bytes << value).pack('C*')
      end

      # Load the cache of VarInts on load of file
      (0..CACHE_LIMIT).each do |cached_value|
        cached_varint(cached_value)
      end
end

#DECODEME = ::Derp.encode_cache_hash(2576)
#DECODEME2 = ::Derp.encode_cache_hash(25763111)

Benchmark.ips do |x|
  x.config(:time => 10, :warmup => 10)

  x.report("to_proto") do
    t = ::Test::Resource.new(:name => "derp", :date_created => 123456789)
    ss = StringIO.new
    ::Protobuf::Encoder.encode(t.to_proto, ss)
    t = ::Test::Resource.decode_from(ss)
  end

#  x.report("encode ruby cached") do
#    Derp.encode_cache_hash(123)
#    Derp.encode_cache_hash(876)
#  end
#
#  x.report("encode ruby uncached") do
#    Derp.encode_cache_hash(321321)
#    Derp.encode_cache_hash(123123)
#  end
#
#  x.report("encode java cached") do
#    123.to_varint
#    876.to_varint
#  end
#
#  x.report("encode java uncached") do
#    321321.to_varint
#    123123.to_varint
#  end
##
#  x.report("encode java cached ruby") do
#    Derp.cached_varint(123)
#    Derp.cached_varint(876)
#  end
#
##  x.report("encode java 2") do
##    123.to_varint2
##    123123.to_varint2
##  end
#
###  x.report("decode cached") do
###    ::Derp.decode_new_cached(StringIO.new(DECODEME))
###  end
##
###  x.report("decode cached2") do
###    ::Derp.decode_new_cached2(StringIO.new(DECODEME))
###  end
##
###  x.report("decode actual") do
###    ::Derp.decode(StringIO.new(DECODEME))
###  end
###
#  x.report("decode ruby") do
#    ::Derp.decode_new(StringIO.new(DECODEME))
#    ::Derp.decode_new(StringIO.new(DECODEME2))
#  end
#
#  x.report("decode java") do
#    StringIO.new(DECODEME).read_varint
#    StringIO.new(DECODEME2).read_varint
#  end
##
###  x.report("varint_pure") do
###    DECODED.each do |number|
###      io = StringIO.new(number)
###      Derp.decode(io)
###    end
###  end
###
###  x.report("varint_pure_new") do
###    DECODED.each do |number|
###      io = StringIO.new(number)
###      Derp.decode_new(io)
###    end
###  end
end
