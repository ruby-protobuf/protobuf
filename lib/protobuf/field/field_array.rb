module Protobuf
  module Field
    class FieldArray < Array
      ##
      # Constructor
      #
      def initialize(field)
        @field = field
      end

      ##
      # Public Instance Methods
      #
      def []=(nth, val)
        super(nth, normalize(val)) unless val.nil?
      end

      def <<(val)
        super(normalize(val)) unless val.nil?
      end

      def push(val)
        super(normalize(val)) unless val.nil?
      end

      def unshift(val)
        super(normalize(val)) unless val.nil?
      end

      def replace(val)
        raise_type_error(val) unless val.is_a?(Array)
        val = val.map! { |v| normalize(v) }
        super(val)
      end

      # Return a hash-representation of the given values for this field type.
      # The value in this case would be an array.
      def to_hash_value
        self.map do |value|
          value.respond_to?(:to_hash_value) ? value.to_hash_value : value
        end
      end

      def to_s
        "[#{@field.name}]"
      end

      private

      ##
      # Private Instance Methods
      #
      def normalize(value)
        value = value.to_proto if value.respond_to?(:to_proto)
        raise TypeError unless @field.acceptable?(value)

        if @field.is_a?(::Protobuf::Field::EnumField)
          @field.type.fetch(value)
        elsif @field.is_a?(::Protobuf::Field::MessageField) && value.respond_to?(:to_hash)
          @field.type.new(value.to_hash)
        else
          value
        end
      end

      def raise_type_error(val)
        error_text = <<-TYPE_ERROR
          Expected value of type '#{@field.type}'
          Got '#{val.class}' for protobuf field #{@field.name}
        TYPE_ERROR

        raise TypeError, error_text
      end
    end
  end
end
