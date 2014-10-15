require 'protobuf/field/integer_field'

module Protobuf
  module Field
    class Int64Field < IntegerField

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
