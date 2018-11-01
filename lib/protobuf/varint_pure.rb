module Protobuf
  module VarintPure
    MSB = 0x80
    LSBS = 0x7f

#    def decode(stream)
#      value = index = 0
#      begin
#        byte = stream.readbyte
#        value |= (byte & 0x7f) << (7 * index)
#        index += 1
#      end while (byte & 0x80).nonzero?
#      value
#    end

    def decode(stream)
      stream.read_varint
    end

    def decode_array(bytes)
      value = 0

      bytes.each_with_index do |byte, index|
        value |= (byte & 0x7f) << (7 * index)
      end

      value
    end

    def decode_new(stream)
      value = byte = stream.readbyte

      unless value < 128
        bits = index = 0
        while (byte & MSB).nonzero?
          value += ((byte & LSBS) << bits)
          bits += 7
          byte = stream.readbyte
        end

        value += ((byte & LSBS) << bits)
      end

      value
    end
    
    def decode_new_cached2(stream)
      bytes = ""
      value = byte = stream.readbyte
      bytes << byte.to_s(2)

      if byte >= 128
        byte = stream.readbyte
        bytes << byte.to_s(2)

        if byte >= 128
          byte = stream.readbyte
          bytes << byte.to_s(2)

          if byte >= 128
            byte = stream.readbyte
            bytes << byte.to_s(2)

            if byte >= 128
              byte = stream.readbyte
              bytes << byte.to_s(2)
            else
              #value += (bytes[0] & LSBS)
              #value += ((bytes[1] & LSBS) << 7)
              #value += ((bytes[2] & LSBS) << 14)
              #value += ((bytes[3] & LSBS) << 21)
            end
          else
            #value += (bytes[0] & LSBS)
            #value += ((bytes[1] & LSBS) << 7)
            #value += ((bytes[2] & LSBS) << 14)
          end
        else
          #value += bytes[0] & LSBS
          #value += ((bytes[1] & LSBS) << 7)
        end
      end

      value
    end

    def decode_new_cached(stream)
      bytes = []
      value = 0
      bytes << stream.readbyte

      if bytes[0] >= 128
        bytes << stream.readbyte

        if bytes[1] >= 128
          bytes << stream.readbyte

          if bytes[2] >= 128
            bytes << stream.readbyte

            if bytes[3] >= 128
              bytes << stream.readbyte
            else
              value += (bytes[0] & LSBS)
              value += ((bytes[1] & LSBS) << 7)
              value += ((bytes[2] & LSBS) << 14)
              value += ((bytes[3] & LSBS) << 21)
            end
          else
            value += (bytes[0] & LSBS)
            value += ((bytes[1] & LSBS) << 7)
            value += ((bytes[2] & LSBS) << 14)
          end
        else
          value += bytes[0] & LSBS
          value += ((bytes[1] & LSBS) << 7)
        end
      end

      value
    end

#    def self._decode_encode(value)
#        bytes = []
#        until value < 128
#          bytes << (0x80 | (value & 0x7f))
#          value >>= 7
#        end
#        (bytes << value).pack('C*')
#      end
#
#      def self.two_byte_cache
#      @two_byte_cache ||= begin
#                            array = []
#                            (128..16_383).each do |number|
#                              bytes = _decode_encode(number)
#                              sio = ::StringIO.new(bytes)
#                              first_byte = sio.readbyte
#                              last_byte = sio.readbyte
#                              array[first_byte] ||= []
#                              array[first_byte][last_byte] = number
#                            end
#
#                            array
#                          end
#    end
#
#    two_byte_cache
  end
end
