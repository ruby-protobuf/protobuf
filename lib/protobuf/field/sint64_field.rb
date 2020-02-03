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

      def json_encode(value)
        value == 0 ? nil : value.to_s
      end
    end
  end
end
