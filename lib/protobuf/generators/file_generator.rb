require 'set'
require 'protobuf/generators/base'
require 'protobuf/generators/group_generator'

module Protobuf
  module Generators
    class FileGenerator < Base

      attr_reader :output_file

      def initialize(*args)
        super
        @output_file = ::Google::Protobuf::Compiler::CodeGeneratorResponse::File.new(:name => file_name)
        @extension_fields = Hash.new { |h, k| h[k] = [] }
        @known_messages = []
        @dangling_messages = {}
      end

      def file_name
        convert_filename(descriptor.name, false)
      end

      def compile
        run_once(:compile) do
          map_extensions(descriptor, [ descriptor.package ])

          print_file_comment
          print_generic_requires
          print_import_requires

          print_package do
            group = GroupGenerator.new(current_indent)
            group.add_enums(descriptor.enum_type, :namespace => [ descriptor.package ])
            group.add_message_declarations(descriptor.message_type)
            group.add_messages(descriptor.message_type, :extension_fields => @extension_fields, :namespace => [ descriptor.package ])
            group.add_extended_messages(unknown_extensions)
            group.add_services(descriptor.service)

            group.add_header(:enum, 'Enum Classes')
            group.add_header(:message_declaration, 'Message Classes')
            group.add_header(:message, 'Message Fields')
            group.add_header(:extended_message, 'Extended Message Fields')
            group.add_header(:service, 'Service Classes')
            print group.to_s
          end

        end
      end

      def unknown_extensions
        @unknown_extensions ||= @extension_fields.reject do |k, _|
          @known_messages.include?(k)
        end
      end

      def generate_output_file
        compile
        output_file.content = to_s
        output_file
      end

      # Recursively map out all extensions known in this file.
      # The key is the type_name of the message being extended, and
      # the value is an array of field descriptors.
      #
      def map_extensions(descriptor, namespaces)
        # Record all the message descriptor name's we encounter (should be the whole tree).
        if descriptor.is_a?(::Google::Protobuf::DescriptorProto)
          if fully_qualified_token?(descriptor.name)
            @known_messages << descriptor.name
          else
            fully_qualified_namespace = ".#{namespaces.join('.')}"
            @known_messages << fully_qualified_namespace
          end
        end

        descriptor.extension.each do |field_descriptor|
          @extension_fields[field_descriptor.extendee] << field_descriptor
        end

        if descriptor.respond_to_has_and_present?(:message_type)
          descriptor.message_type.each do |message_descriptor|
            map_extensions(message_descriptor, (namespaces + [ message_descriptor.name ]))
          end
        end

        if descriptor.respond_to_has_and_present?(:nested_type)
          descriptor.nested_type.each do |nested_descriptor|
            map_extensions(nested_descriptor, (namespaces + [ nested_descriptor.name ]))
          end
        end
      end

      def print_file_comment
        puts "# encoding: utf-8"
        puts
        puts "##"
        puts "# This file is auto-generated. DO NOT EDIT!"
        puts "#"
      end

      def print_generic_requires
        print_require("protobuf/message")
        print_require("protobuf/rpc/service") if descriptor.service.count > 0
        puts
      end

      def print_import_requires
        if descriptor.dependency.count > 0
          header "Imports"

          descriptor.dependency.each do |dependency|
            print_require(convert_filename(dependency))
          end

          puts
        end
      end

      def print_package(&block)
        final = lambda { block.call }
        namespaces = descriptor.package.split('.')
        namespaces.reverse.inject(final) do |previous, namespace|
          lambda { print_module(namespace, &previous) }
        end.call
      end

      private

      def convert_filename(filename, for_require = true)
        filename.sub(/\.proto/, (for_require ? '.pb' : '.pb.rb'))
      end

      def fully_qualified_token?(token)
        token[0] == '.'
      end

    end
  end
end

