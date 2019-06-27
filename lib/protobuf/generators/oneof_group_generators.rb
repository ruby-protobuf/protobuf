require 'protobuf/generators/base'

module Protobuf
  module Generators
    class OneofGroupGenerator < Base
      def initialize(oneof_decl, field_descriptors, indent_level, options = {})
        super(oneof_decl, indent_level, options)
        @field_descriptors = field_descriptors
      end

      def compile
        run_once(:compile) do
          descriptor.each_with_index do |oneof_descriptor, idx|
            puts build_value(oneof_descriptor.name, idx)
          end
          puts
        end
      end

      def build_value(name, oneof_index)
        oneof_fields = @field_descriptors.select { |field_descriptor| field_descriptor.oneof_index == oneof_index }

        "oneof_group :#{name.strip}, [:#{oneof_fields.map(&:name).join(', :')}]"
      end
    end
  end
end


