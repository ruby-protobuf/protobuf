require 'protobuf/field/integer_field'

module Protobuf
  module Field
    class Int64Field < IntegerField

      ##
      # Class Methods
      #
      if defined?(::ProtobufJavaHelpers)
        include ::ProtobufJavaHelpers::Varinter
        include ::ProtobufJavaHelpers::IntegerProtobufField
        include ::ProtobufJavaHelpers::Int64ProtobufField

        def encode(value)
          to_varint_64(value)
        end

        def decode(value)
          decode_varint_64(value)
        end
      else
        def self.max
          INT64_MAX
        end

        def self.min
          INT64_MIN
        end
      end

    end
  end
end
