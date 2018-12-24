module Protobuf
  module Field
    module VarintFieldEncoderPure
      module ClassMethods
        # Because all tags and enums are calculated as VarInt it is "most common" to have
        # values < CACHE_LIMIT (low numbers) which is defaulting to 1024
        def cached_varint(value)
          @_varint_cache ||= {}
          (@_varint_cache[value] ||= encode(value, false)).dup
        end

        def encode(value, use_cache = true)
          return cached_varint(value) if use_cache && value >= 0 && value <= CACHE_LIMIT

          bytes = []
          until value < 128
            bytes << (0x80 | (value & 0x7f))
            value >>= 7
          end
          (bytes << value).pack('C*')
        end
      end

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
        fail TypeError, "Expected value of type '#{type_class}' for field #{name}, but got '#{val.class}'" unless acceptable?(val)
        return val.to_i if val.is_a?(Numeric)
        Integer(val, 10)
      rescue ArgumentError
        fail TypeError, "Expected value of type '#{type_class}' for field #{name}, but got '#{val.class}'"
      end
    end
  end
end
