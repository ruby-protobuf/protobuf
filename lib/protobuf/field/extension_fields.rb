module Protobuf
  module Field
    class ExtensionFields < Array
      ##
      # Constructor
      #
      def initialize(key_range = 0..-1)
        @key_range = key_range
      end

      ##
      # Public Instance Methods
      #
      def []=(key, value)
        raise RangeError, "#{key} is not in #{@key_range}" unless @key_range.include?(key)
        super
      end

      def include_tag?(tag)
        @key_range.include?(tag)
      end
    end
  end
end
