require 'protobuf/field/varint_field'

module Protobuf
  module Field
    class Uint64Field < VarintField

      ##
      # Class Methods
      #

      def self.max
        UINT64_MAX
      end

      def self.min
        0
      end

      if defined?(Uint64ProtobufField) && $run_java
        include Uint64ProtobufField
      end

    end
  end
end
