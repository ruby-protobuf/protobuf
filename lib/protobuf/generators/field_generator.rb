require 'protobuf/generators/base'

module Protobuf
  module Generators
    class FieldGenerator < Base

      ##
      # Constants
      #
      PROTO_INFINITY_DEFAULT          = /^inf$/i
      PROTO_NEGATIVE_INFINITY_DEFAULT = /^-inf$/i
      PROTO_NAN_DEFAULT               = /^nan$/i
      RUBY_INFINITY_DEFAULT           = '::Float::INFINITY'.freeze
      RUBY_NEGATIVE_INFINITY_DEFAULT  = '-::Float::INFINITY'.freeze
      RUBY_NAN_DEFAULT                = '::Float::NAN'.freeze

      ##
      # Attributes
      #
      attr_reader :field_options

      def applicable_options
        # Note on the strange use of `#inspect`:
        #   :boom.inspect #=> ":boom"
        #   :".boom.foo".inspect #=> ":\".boom.foo\""
        # An alternative to `#inspect` would be always adding double quotes,
        # but the generatated code looks un-idiomatic:
        #   ":\"#{:boom}\"" #=> ":\"boom\"" <-- Note the unnecessary double quotes
        @applicable_options ||= field_options.map { |k, v| "#{k.inspect} => #{v}" }
      end

      def default_value
        @default_value ||= begin
                             if defaulted?
                               case descriptor.type.name
                               when :TYPE_ENUM
                                 enum_default_value
                               when :TYPE_STRING, :TYPE_BYTES
                                 string_default_value
                               when :TYPE_FLOAT, :TYPE_DOUBLE
                                 float_double_default_value
                               else
                                 verbatim_default_value
                               end
                             end
                           end
      end

      def defaulted?
        descriptor.respond_to_has_and_present?(:default_value)
      end

      def deprecated?
        descriptor.options.try(:deprecated?) { false }
      end

      def extension?
        descriptor.respond_to_has_and_present?(:extendee)
      end

      def compile
        run_once(:compile) do
          field_definition = ["#{label} #{type_name}", name, number, applicable_options]
          puts field_definition.flatten.compact.join(', ')
        end
      end

      def label
        @label ||= descriptor.label.name.to_s.downcase.sub(/label_/, '') # required, optional, repeated
      end

      def name
        @name ||= descriptor.name.to_sym.inspect
      end

      def number
        @number ||= descriptor.number
      end

      def field_options
        @field_options ||= begin
                             opts = {}
                             opts[:default] = default_value if defaulted?
                             opts[:packed] = 'true' if packed?
                             opts[:deprecated] = 'true' if deprecated?
                             opts[:extension] = 'true' if extension?
                             if descriptor.options
                               descriptor.options.each_field do |field_option|
                                 next unless descriptor.options.field?(field_option.name)
                                 option_value = descriptor.options[field_option.name]
                                 opts[field_option.fully_qualified_name] = serialize_value(option_value)
                               end
                             end
                             opts
                           end
      end

      def packed?
        descriptor.options.try(:packed?) { false }
      end

      # Determine the field type
      def type_name
        @type_name ||= begin
                         case descriptor.type.name
                         when :TYPE_MESSAGE, :TYPE_ENUM, :TYPE_GROUP then
                           modulize(descriptor.type_name)
                         else
                           type_name = descriptor.type.name.to_s.downcase.sub(/type_/, '')
                           ":#{type_name}"
                         end
                       end
      end

      private

      def enum_default_value
        "#{type_name}::#{verbatim_default_value}"
      end

      def float_double_default_value
        case verbatim_default_value
        when PROTO_INFINITY_DEFAULT then
          RUBY_INFINITY_DEFAULT
        when PROTO_NEGATIVE_INFINITY_DEFAULT then
          RUBY_NEGATIVE_INFINITY_DEFAULT
        when PROTO_NAN_DEFAULT then
          RUBY_NAN_DEFAULT
        else
          verbatim_default_value
        end
      end

      def string_default_value
        %("#{verbatim_default_value.gsub(/'/, '\\\\\'')}")
      end

      def verbatim_default_value
        descriptor.default_value
      end

    end
  end
end
