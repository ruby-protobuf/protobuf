require 'protobuf/varint_pure'

module Protobuf
  class Varint
    if defined?(::Varint)
      extend ::Varint
    else
      extend VarintPure
    end
  end
end
