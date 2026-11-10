module Protobuf
  module VarintPure
    CACHE_LIMIT = 2048

    def cached_varint(value)
      @_varint_cache ||= {}
      (@_varint_cache[value] ||= encode(value, false)).dup
    end

    # A varint has at most 10 bytes (64 bits). Each byte costs more than the
    # one before it as the Integer grows, so without a limit a long run of
    # bytes above 127 could use seconds of CPU.
    MAX_SHIFT = 63
    UINT64_MASK = 0xffff_ffff_ffff_ffff

    # A byte above 127 has more bytes after it. The last byte needs no mask.
    # As in the reference parsers and the C varint gem, read at most 10 bytes
    # and keep the low 64 bits. Most varints (tags, lengths, small values)
    # have one byte, so that case returns before the loop: with the limit,
    # this is as fast as the loop without it. Adapted from #297 (abrandoned).
    def decode(stream)
      byte = stream.readbyte
      return byte if byte < 128

      value = byte & 0x7f
      shift = 7
      while (byte = stream.readbyte) > 127
        value |= (byte & 0x7f) << shift
        shift += 7
        fail ::Protobuf::DecodeError, "varint is longer than 10 bytes" if shift > MAX_SHIFT
      end
      value |= byte << shift
      shift == MAX_SHIFT ? value & UINT64_MASK : value
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
