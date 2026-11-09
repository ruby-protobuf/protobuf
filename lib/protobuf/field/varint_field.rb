require 'protobuf/field/base_field'

module Protobuf
  module Field
    class VarintField < BaseField

      ##
      # Constants
      #
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

      # Varints below this value (one or two bytes) come from a cache. Tags,
      # lengths, and most integer values are in this range.
      ENCODE_CACHE_LIMIT = 16_384
      ENCODE_CACHE = ::Array.new(ENCODE_CACHE_LIMIT)

      # Returns a frozen string for a value below ENCODE_CACHE_LIMIT. Callers
      # must not change the returned string.
      def self.encode(value)
        if value >= 0 && value < ENCODE_CACHE_LIMIT
          ENCODE_CACHE[value] ||= ::Protobuf::Varint.encode(value).freeze
        else
          ::Protobuf::Varint.encode(value)
        end
      end

      ##
      # Public Instance Methods
      #
      def acceptable?(val)
        int_val = if val.is_a?(Integer)
                    return true if val >= 0 && val < INT32_MAX # return quickly for smallest integer size, hot code path
                    val
                  elsif val.is_a?(Numeric)
                    val.to_i
                  else
                    Integer(val, 10)
                  end

        int_val >= self.class.min && int_val <= self.class.max
      rescue
        false
      end

      def coerce!(val)
        if val.is_a?(Integer) && val >= 0 && val <= INT32_MAX
          val
        else
          fail TypeError, "Expected value of type '#{type_class}' for field #{name}, but got '#{val.class}'" unless acceptable?(val)

          if val.is_a?(Integer) || val.is_a?(Numeric)
            val.to_i
          else
            Integer(val, 10)
          end
        end
      rescue ArgumentError
        fail TypeError, "Expected value of type '#{type_class}' for field #{name}, but got '#{val.class}'"
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
