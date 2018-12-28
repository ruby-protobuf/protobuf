require 'protobuf/field/integer_field'

module Protobuf
  module Field
    class EnumField < IntegerField

      ##
      # Class Methods
      #

      def self.default
        fail NoMethodError, "#{self}.#{__method__} must be called on an instance"
      end

      ##
      # Public Instance Methods
      #
      if defined?(::ProtobufJavaHelpers)
        include ::ProtobufJavaHelpers::Varinter
        include ::ProtobufJavaHelpers::IntegerProtobufField

        def encode(value)
          to_varint_64(value.to_i) # Calling `to_i` because it is a delegator and the java side doesn't follow
        end

        def decode(value)
          decode_varint_64(value)
        end
      else
        def encode(value)
          # original Google's library uses 64bits integer for negative value
          ::Protobuf::Field::VarintField.encode(value & 0xffff_ffff_ffff_ffff)
        end

        def decode(value)
          value -= 0x1_0000_0000_0000_0000 if (value & 0x8000_0000_0000_0000).nonzero?
          value if acceptable?(value)
        end
      end

      def acceptable?(val)
        !type_class.fetch(val).nil?
      end

      def enum?
        true
      end

      def coerce!(value)
        enum_value = type_class.fetch(value)
        enum_value || fail(TypeError, "Invalid Enum value: #{value.inspect} for #{name}")
      end

      private

      ##
      # Private Instance Methods
      #

      def typed_default_value
        if default.is_a?(Symbol)
          type_class.const_get(default)
        else
          type_class.fetch(default) || type_class.enums.first
        end
      end

    end
  end
end
