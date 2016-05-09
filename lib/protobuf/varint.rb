module Protobuf
  class Varint
    if defined?(::Varint)
      extend ::Varint
    else
      extend VarintPure
    end
  end
end
