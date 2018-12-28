require 'protobuf/field/varint_field'

module Protobuf
  module Field
    class Uint32Field < VarintField

      ##
      # Class Methods
      #
      if defined?(::ProtobufJavaHelpers)
        include ::ProtobufJavaHelpers::Uint32ProtobufField
        extend ::ProtobufJavaHelpers::Uint32ProtobufField
      else
        def self.max
          UINT32_MAX
        end

        def self.min
          0
        end
      end
    end
  end
end
