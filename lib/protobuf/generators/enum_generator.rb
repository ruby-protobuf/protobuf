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
        name = enum_value_descriptor.name
        number = enum_value_descriptor.number
        "define :#{name}, #{number}"
      end

    end
  end
end
