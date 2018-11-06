module Protobuf
  module VarintPure
    def decode(stream)
      value = index = 0
      begin
        byte = stream.readbyte
        value |= (byte & 0x7f) << (7 * index)
        index += 1
      end while (byte & 0x80).nonzero?
      value
    end
  end
end
