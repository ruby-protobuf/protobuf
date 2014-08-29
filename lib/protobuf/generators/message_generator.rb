require 'protobuf/generators/base'
require 'protobuf/generators/group_generator'

module Protobuf
  module Generators
    class MessageGenerator < Base

      def initialize(descriptor, indent_level, options = {})
        super
        @only_declarations = options.fetch(:declaration) { false }
        @extension_fields = options.fetch(:extension_fields) { {} }
      end

      def compile
        run_once(:compile) do
          if @only_declarations
            compile_declaration
          else
            compile_message
          end
        end
      end

      def compile_declaration
        run_once(:compile_declaration) do
          if is_printable?
            print_class(descriptor.name, :message) do
              group = GroupGenerator.new(current_indent)
              group.add_enums(descriptor.enum_type, :namespace => type_namespace)
              group.add_message_declarations(descriptor.nested_type)
              print group.to_s
            end
          else
            print_class(descriptor.name, :message)
          end
        end
      end

      def compile_message
        run_once(:compile_message) do
          if is_printable?
            print_class(descriptor.name, nil) do
              group = GroupGenerator.new(current_indent)
              group.add_messages(descriptor.nested_type, :extension_fields => @extension_fields, :namespace => type_namespace)
              group.add_message_fields(descriptor.field, descriptor.oneof_decl)
              self.class.validate_tags(fully_qualified_type_namespace, descriptor.field.map(&:number))

              group.add_comment(:extension_range, 'Extension Fields')
              group.add_extension_ranges(descriptor.extension_range) do |extension_range|
                "extensions #{extension_range.start}...#{extension_range.end}"
              end

              group.add_extension_fields(message_extension_fields, descriptor.oneof_decl)

              group.order = [ :message, :field, :extension_range, :extension_field ]
              print group.to_s
            end
          end
        end
      end

      private

      def has_extensions?
        ! message_extension_fields.empty?
      end

      def has_fields?
        descriptor.field.count > 0
      end

      def has_nested_enums?
        descriptor.enum_type.count > 0
      end

      def has_nested_messages?
        descriptor.nested_type.count > 0
      end

      def has_nested_types?
        has_nested_enums? || has_nested_messages?
      end

      def is_printable?
        if @only_declarations
          has_nested_types?
        else
          has_fields? || has_nested_messages? || has_extensions?
        end
      end

      def message_extension_fields
        @extension_fields.fetch(fully_qualified_type_namespace) { [] }
      end

    end
  end
end

