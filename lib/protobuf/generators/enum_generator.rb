require 'protobuf/generators/base'

module Protobuf
  module Generators
    class EnumGenerator < Base

      def allow_alias?
        descriptor.options.try(:allow_alias!) { false }
      end

      def compile
        run_once(:compile) do
          tags = []

          print_class(descriptor.name, :enum) do
            if deprecated?
              puts "def self.deprecated?"
              indent { puts "true" }
              puts "end"
              puts
            end

            if allow_alias?
              puts "set_option :allow_alias"
              puts
            end

            descriptor.value.each do |enum_value_descriptor|
              tags << enum_value_descriptor.number
              puts build_value(enum_value_descriptor)
            end
          end

          unless allow_alias?
            self.class.validate_tags(fully_qualified_type_namespace, tags)
          end
        end
      end

      def build_value(enum_value_descriptor)
        value_definition = [
          ":#{enum_value_descriptor.name}",
          enum_value_descriptor.number
        ]

        options = {}
        options[:deprecated] = true if deprecated_value?(enum_value_descriptor)
        options.each { |k, v| value_definition << ":#{k} => #{v}" }

        return "define " + value_definition.join(', ')
      end

      def deprecated?
        descriptor.options.try(:deprecated!) { false }
      end

      def deprecated_value?(enum_value_descriptor)
        enum_value_descriptor.options.try(:deprecated!) { false }
      end

    end
  end
end

