require 'protobuf/field/signed_integer_field'

module Protobuf
  module Field
    class Sint64Field < SignedIntegerField
      def max; INT64_MAX; end
      def min; INT64_MIN; end

      ##
      # Class Methods
      #

      def self.max
        INT64_MAX
      end

      def self.min
        INT64_MIN
      end

    end
  end
end

