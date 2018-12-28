require 'protobuf/field/varint_field'

module Protobuf
  module Field
    class Uint64Field < VarintField

      ##
      # Class Methods
      #
      if defined?(::ProtobufJavaHelpers)
        include ::ProtobufJavaHelpers::Uint64ProtobufField
        extend ::ProtobufJavaHelpers::Uint64ProtobufField
      else
        def self.max
          UINT64_MAX
        end

        def self.min
          0
        end
      end
    end
  end
end
