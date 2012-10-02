module Protobuf
  module Field
    class ExtensionFields < Hash
      ##
      # Constructor
      #
      def initialize
        @ranges = []
      end

      ##
      # Public Instance Methods
      #

      # Append a range to the list of ranges.
      def add_range(range = (0..-1))
        @ranges << range
      end

      # Set value at tag location, if tag is in a valid range.
      def []=(key, value)
        raise RangeError, "#{key} is not in #{@ranges.join(', ')}" unless include_tag?(key)
        super
      end

      # Check if the given tag exists in any of the defined ranges.
      def include_tag?(tag)
        @ranges.any? { |range| range.include?(tag) }
      end
    end
  end
end
