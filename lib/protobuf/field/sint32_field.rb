require 'protobuf/field/signed_integer_field'

module Protobuf
  module Field
    class Sint32Field < SignedIntegerField
      def self.max; INT32_MAX; end
      def self.min; INT32_MIN; end
      def max; INT32_MAX; end
      def min; INT32_MIN; end
    end
  end
end
