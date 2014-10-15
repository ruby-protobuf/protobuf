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

    end
  end
end
