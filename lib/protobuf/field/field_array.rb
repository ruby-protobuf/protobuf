module Protobuf
  module Field
    class FieldArray < Array

      def initialize(field)
        @field = field
      end

      def []=(nth, val)
        super(nth, normalize(val))
      end

      def <<(val)
        super(normalize(val))
      end

      def push(val)
        super(normalize(val))
      end

      def unshift(val)
        super(normalize(val))
      end

      def replace(val)
        raise TypeError unless val.is_a?(Array)
        val = val.map {|v| normalize(v)}
        super(val)
      end

      def to_s
        "[#{@field.name}]"
      end

      private

      def normalize(val)
        raise TypeError unless @field.acceptable?(val)
        if @field.is_a?(MessageField) && val.is_a?(Hash)
          @field.type.new(val)
        else
          val
        end
      end
    end
  end
end
