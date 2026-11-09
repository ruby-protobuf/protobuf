module Protobuf
  module VarintPure
    CACHE_LIMIT = 2048

    def cached_varint(value)
      @_varint_cache ||= {}
      (@_varint_cache[value] ||= encode(value, false)).dup
    end

    # A byte above 127 has more bytes after it. The last byte needs no mask.
    # Adapted from #297 (abrandoned).
    def decode(stream)
      value = shift = 0
      while (byte = stream.readbyte) > 127
        value |= (byte & 0x7f) << shift
        shift += 7
      end
      value | (byte << shift)
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
end
