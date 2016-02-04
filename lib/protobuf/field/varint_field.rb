require 'protobuf/field/base_field'

module Protobuf
  module Field
    class VarintField < BaseField

      ##
      # Constants
      #

      CACHE_LIMIT = 2048
      INT32_MAX  =  2**31 - 1
      INT32_MIN  = -2**31
      INT64_MAX  =  2**63 - 1
      INT64_MIN  = -2**63
      UINT32_MAX =  2**32 - 1
      UINT64_MAX =  2**64 - 1

      ##
      # Class Methods
      #

      def self.default
        0
      end

      # Because all tags and enums are calculated as VarInt it is "most common" to have
      # values < CACHE_LIMIT (low numbers) which is defaulting to 1024
      def self.cached_varint(value)
        @_varint_cache ||= {}
        (@_varint_cache[value] ||= encode(value, false)).dup
      end

      def self.encode(value, use_cache = true)
        return cached_varint(value) if use_cache && value >= 0 && value <= CACHE_LIMIT

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

      ##
      # Public Instance Methods
      #

      def acceptable?(val)
        int_val = coerce!(val)
        int_val >= self.class.min && int_val <= self.class.max
      rescue
        false
      end

      def coerce!(val)
        return val.to_i if val.is_a?(Numeric)
        Integer(val, 10)
      end

      def decode(value)
        value
      end

      def encode(value)
        ::Protobuf::Field::VarintField.encode(value)
      end

      def wire_type
        ::Protobuf::WireType::VARINT
      end

    end
  end
end
