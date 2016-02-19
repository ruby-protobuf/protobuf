require 'protobuf/deprecation'
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
        tag_encoded
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
                           when optional? then typed_default_value
                           when repeated? then ::Protobuf::Field::FieldArray.new(self).freeze
                           when required? then nil
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
        return message_instance.__send__(setter, decode(bytes)) unless repeated?
        return message_instance.__send__(getter) << decode(bytes) unless packed?

        array = message_instance.__send__(getter)
        stream = StringIO.new(bytes)

        if wire_type == ::Protobuf::WireType::VARINT
          array << Varint.decode(stream) until stream.eof?
        elsif wire_type == ::Protobuf::WireType::FIXED64
          array << stream.read(8) until stream.eof?
        elsif wire_type == ::Protobuf::WireType::FIXED32
          array << stream.read(4) until stream.eof?
        end
      end

      def setter
        @setter ||= "#{name}="
      end

      def tag_encoded
        @tag_encoded ||= begin
                           case
                           when repeated? && packed?
                             ::Protobuf::Field::VarintField.encode((tag << 3) | ::Protobuf::WireType::LENGTH_DELIMITED)
                           else
                             ::Protobuf::Field::VarintField.encode((tag << 3) | wire_type)
                           end
                         end
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
            @values[field.name] || field.default_value
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
              @values[field.name] = field.coerce!(val)
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
