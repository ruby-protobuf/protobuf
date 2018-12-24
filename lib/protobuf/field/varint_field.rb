require 'protobuf/field/base_field'
require 'protobuf/field/varint_field_encoder_pure'

module Protobuf
  module Field
    class VarintField < BaseField

      ##
      # Constants
      #

      CACHE_LIMIT = 2048
      INT32_MAX  =  2**31 - 1
      INT32_MIN  = -2**31
      INT64_MAX  =  2**63 - 1
      INT64_MIN  = -2**63
      UINT32_MAX =  2**32 - 1
      UINT64_MAX =  2**64 - 1

      ##
      # Class Methods
      #

      def self.default
        0
      end

      if defined?(::ProtobufJavaHelpers)
        include ::ProtobufJavaHelpers::VarintProtobufField
        extend ::ProtobufJavaHelpers::VarintProtobufField
        extend ::ProtobufJavaHelpers::Varinter

        def self.encode(value)
          to_varint(value)
        end
      else
        include ::Protobuf::Field::VarintFieldEncoderPure
        extend ::Protobuf::Field::VarintFieldEncoderPure::ClassMethods

        # Load the cache of VarInts on load of file
        (0..CACHE_LIMIT).each do |cached_value|
          cached_varint(cached_value)
        end
      end

      ##
      # Public Instance Methods
      #
      def decode(value)
        value
      end

      def encode(value)
        ::Protobuf::Field::VarintField.encode(value)
      end

      def wire_type
        ::Protobuf::WireType::VARINT
      end

    end
  end
end
