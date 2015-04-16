require 'protobuf/field/field_array'
require 'protobuf/logging'
require 'protobuf/wire_type'

module Protobuf
  module Field
    class BaseField
      include ::Protobuf::Logging

      ##
      # Constants
      #

      PACKED_TYPES = [
        ::Protobuf::WireType::VARINT,
        ::Protobuf::WireType::FIXED32,
        ::Protobuf::WireType::FIXED64,
      ].freeze

      ##
      # Attributes
      #

      attr_reader :message_class, :name, :options, :rule, :tag, :type_class

      ##
      # Class Methods
      #

      def self.default
        nil
      end

      ##
      # Constructor
      #

      def initialize(message_class, rule, type_class, name, tag, options)
        @message_class = message_class
        @name          = name
        @rule          = rule
        @tag           = tag
        @type_class    = type_class
        @options       = options

        validate_packed_field if packed?
        define_accessor
      end

      ##
      # Public Instance Methods
      #

      def acceptable?(_value)
        true
      end

      def coerce!(value)
        value
      end

      def decode(_bytes)
        fail NotImplementedError, "#{self.class.name}##{__method__}"
      end

      def default
        options[:default]
      end

      def default_value
        @default_value ||= case
                           when repeated? then ::Protobuf::Field::FieldArray.new(self).freeze
                           when required? then nil
                           when optional? then typed_default_value
                           end
      end

      def deprecated?
        options.key?(:deprecated)
      end

      def encode(_value)
        fail NotImplementedError, "#{self.class.name}##{__method__}"
      end

      def extension?
        options.key?(:extension)
      end

      def enum?
        false
      end

      def getter
        name
      end

      def message?
        false
      end

      def oneof?
        options.key?(:oneof)
      end

      def oneof_name
        options[:oneof]
      end

      def optional?
        rule == :optional
      end

      def packed?
        repeated? && options.key?(:packed)
      end

      def repeated?
        rule == :repeated
      end

      def repeated_message?
        repeated? && message?
      end

      def required?
        rule == :required
      end

      # FIXME: need to cleanup (rename) this warthog of a method.
      def set(message_instance, bytes)
        if packed?
          array = message_instance.__send__(getter)
          method = \
            case wire_type
            when ::Protobuf::WireType::FIXED32 then :read_fixed32
            when ::Protobuf::WireType::FIXED64 then :read_fixed64
            when ::Protobuf::WireType::VARINT  then :read_varint
            end
          stream = StringIO.new(bytes)

          until stream.eof?
            array << decode(::Protobuf::Decoder.__send__(method, stream))
          end
        else
          value = decode(bytes)
          if repeated?
            message_instance.__send__(getter) << value
          else
            message_instance.__send__(setter, value)
          end
        end
      end

      def setter
        @setter ||= "#{name}="
      end

      # FIXME: add packed, deprecated, extension options to to_s output
      def to_s
        "#{rule} #{type_class} #{name} = #{tag} #{default ? "[default=#{default.inspect}]" : ''}"
      end

      ::Protobuf.deprecator.define_deprecated_methods(self, :type => :type_class)

      def wire_type
        ::Protobuf::WireType::VARINT
      end

      private

      ##
      # Private Instance Methods
      #

      def define_accessor
        if repeated?
          define_array_getter
          define_array_setter
        else
          define_getter
          define_setter
        end
      end

      def define_array_getter
        field = self
        method_name = field.getter

        message_class.class_eval do
          define_method(method_name) do
            @values[field.name] ||= ::Protobuf::Field::FieldArray.new(field)
          end
        end

        ::Protobuf.field_deprecator.deprecate_method(message_class, method_name) if field.deprecated?
      end

      def define_array_setter
        field = self
        method_name = field.setter

        message_class.class_eval do
          define_method(method_name) do |val|
            if val.is_a?(Array)
              val = val.dup
              val.compact!
            else
              fail TypeError, <<-TYPE_ERROR
                Expected repeated value of type '#{field.type_class}'
                Got '#{val.class}' for repeated protobuf field #{field.name}
              TYPE_ERROR
            end

            if val.nil? || (val.respond_to?(:empty?) && val.empty?)
              @values.delete(field.name)
            else
              clear_oneof_group(field.oneof_name) if field.oneof?
              @values[field.name] ||= ::Protobuf::Field::FieldArray.new(field)
              @values[field.name].replace(val)
            end
          end
        end

        ::Protobuf.field_deprecator.deprecate_method(message_class, method_name) if field.deprecated?
      end

      def define_getter
        field = self
        method_name = field.getter

        message_class.class_eval do
          define_method(method_name) do
            @values.fetch(field.name, field.default_value)
          end
        end

        ::Protobuf.field_deprecator.deprecate_method(message_class, method_name) if field.deprecated?
      end

      def define_setter
        field = self
        method_name = field.setter

        message_class.class_eval do
          define_method(method_name) do |val|
            if val.nil? || (val.respond_to?(:empty?) && val.empty?)
              @values.delete(field.name)
            elsif field.acceptable?(val)
              coerced_value = field.coerce!(val)
              clear_oneof_group(field.oneof_name) if field.oneof?
              @values[field.name] = coerced_value
            else
              fail TypeError, "Unacceptable value #{val} for field #{field.name} of type #{field.type_class}"
            end
          end
        end

        ::Protobuf.field_deprecator.deprecate_method(message_class, method_name) if field.deprecated?
      end

      def typed_default_value
        if default.nil?
          self.class.default
        else
          default
        end
      end

      def validate_packed_field
        if packed? && ! ::Protobuf::Field::BaseField::PACKED_TYPES.include?(wire_type)
          fail "Can't use packed encoding for '#{type_class}' type"
        end
      end

    end
  end
end
