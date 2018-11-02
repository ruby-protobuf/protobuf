require 'protobuf/field/signed_integer_field'

module Protobuf
  module Field
    class Sint64Field < SignedIntegerField

      ##
      # Class Methods
      #

      def self.max
        INT64_MAX
      end

      def self.min
        INT64_MIN
      end

      if defined?(Sint64ProtobufField) && $run_java
        include Sint64ProtobufField
      end

    end
  end
end
