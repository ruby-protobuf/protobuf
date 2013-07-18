require 'protobuf/generators/base'

module Protobuf
  module Generators
    class FieldGenerator < Base

      attr_reader :field_options

      def applicable_options
        @applicable_options ||= field_options.map { |k, v| ":#{k} => #{v}" }
      end

      def default_value
        @default_value ||= begin
                             if defaulted?
                               raw_default_value = descriptor.default_value

                               case descriptor.type.name
                               when :TYPE_ENUM then
                                 "#{type_name}::#{raw_default_value}"
                               when :TYPE_STRING then
                                 "'#{raw_default_value.gsub(/'/, '\\\\\'')}'"
                               else
                                 raw_default_value
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
          field_definition = [ "#{label} #{type_name}", name, number, applicable_options ]
          puts field_definition.flatten.compact.join(', ')
        end
      end

      def label
        @label ||= descriptor.label.name.to_s.downcase.sub(/label_/, '') # required, optional, repeated
      end

      def name
        @name ||= ":#{descriptor.name}"
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
                           type_name = modulize(descriptor.type_name)
                         else
                           type_name = descriptor.type.name.to_s.downcase.sub(/type_/, '')
                           type_name = "::Protobuf::Field::#{modulize(type_name)}Field"
                         end
                       end
      end

    end
  end
end

