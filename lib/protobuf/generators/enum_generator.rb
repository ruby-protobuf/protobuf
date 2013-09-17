require 'protobuf/generators/base'

module Protobuf
  module Generators
    class EnumGenerator < Base

      def compile
        run_once(:compile) do
          tags = []

          print_class(descriptor.name, :enum) do
            descriptor.value.each do |enum_value_descriptor|
              tags << enum_value_descriptor.number
              puts build_value(enum_value_descriptor)
            end
          end

          self.class.validate_tags(fully_qualified_type_namespace, tags)
        end
      end

      def build_value(enum_value_descriptor)
        name = enum_value_descriptor.name
        number = enum_value_descriptor.number
        return "define :#{name}, #{number}"
      end

    end
  end
end

