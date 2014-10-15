require 'protobuf/generators/printable'

module Protobuf
  module Generators
    class Base
      include ::Protobuf::Generators::Printable

      def self.validate_tags(type_name, tags)
        return if tags.empty?

        unique_tags = tags.uniq

        if unique_tags.size < tags.size
          ::Protobuf::CodeGenerator.fatal("#{type_name} object has duplicate tags. Expected #{unique_tags.size} tags, but got #{tags.size}. Suppress with PB_NO_TAG_WARNINGS=1.")
        end

        unless ENV.key?('PB_NO_TAG_WARNINGS')
          range = (tags.min)..(tags.max)
          if range.respond_to?(:size)
            expected_size = range.size
          else
            expected_size = range.to_a.size
          end

          if tags.size < expected_size
            ::Protobuf::CodeGenerator.print_tag_warning_suppress
            ::Protobuf::CodeGenerator.warn("#{type_name} object should have #{expected_size} tags (#{range.begin}..#{range.end}), but found #{tags.size} tags.")
          end
        end
      end

      attr_reader :descriptor, :namespace, :options

      def initialize(descriptor, indent_level = 0, options = {})
        @descriptor = descriptor
        @options = options
        @namespace = @options.fetch(:namespace) { [] }
        init_printer(indent_level)
      end

      def fully_qualified_type_namespace
        ".#{type_namespace.join('.')}"
      end

      def run_once(label, &block)
        tracker_ivar = "@_#{label}_compiled"
        value_ivar = "@_#{label}_compiled_value"

        if instance_variable_get(tracker_ivar)
          return instance_variable_get(value_ivar)
        else
          return_value = block.call
          instance_variable_set(tracker_ivar, true)
          instance_variable_set(value_ivar, return_value)
          return return_value
        end
      end

      def to_s
        compile
        print_contents # see Printable
      end

      def type_namespace
        @type_namespace ||= @namespace + [descriptor.name]
      end

    end
  end
end
