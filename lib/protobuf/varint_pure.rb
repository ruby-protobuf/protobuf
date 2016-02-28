module Protobuf
  module VarintPure
    def decode(stream)
      value = shift = 0
      begin
        byte = stream.readbyte
        value |= (byte & 127) << shift
        shift += 7
      end while byte > 127
      value
    end
  end
end
