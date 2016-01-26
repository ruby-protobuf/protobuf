require 'protobuf/generators/file_generator'

module Protobuf
  # Patch Message::Serialization#decode
  # When loading Google::Protobuf::Compile::CodeGeneratorRequest, we may come
  # across Google::Protobuf::Descriptor extensions. Dynamically load the
  # generated code for such extensions so consumers of the extensions (or
  # custom options) work.
  #
  # E.g.
  #
  #   # custom_service_options.proto
  #   syntax = "proto2";
  #
  #   package my_package;
  #
  #   import "google/protobuf/descriptor.proto";
  #
  #   extend google.protobuf.MethodOptions {
  #     optional bool bam = 1001;
  #   }
  #
  #   # custom_field_options.proto
  #   syntax = "proto2";
  #
  #   package my_package;
  #
  #   import "google/protobuf/descriptor.proto";
  #
  #   extend google.protobuf.FieldOptions {
  #     optional bool boom = 1001;
  #   }
  #
  class Message
    module Serialization
      def decode(bytes)
        decoded_proto = decode_from(::StringIO.new(bytes))
        return decoded_proto if self.class != Google::Protobuf::FileDescriptorProto ||
          loaded_dependencies.include?(name)

        loaded_dependencies << name

        file_generator = ::Protobuf::Generators::FileGenerator.new(self)
        code = file_generator.generate_output_file.content
        Object.module_eval code.gsub(/^require '(.*)'$/) { |string| %r{^protobuf/} =~ $1 ? string : '' }
        decoded_proto
      rescue => e
        if self.class == Google::Protobuf::FileDescriptorProto
          warn "Error while decoding #{name.inspect}:\n#{code}"
        end
        raise e
      end

      def loaded_dependencies
        @@loaded_dependencies ||= Set.new(["google/protobuf/descriptor.proto"])
      end
    end
  end

  class CodeGenerator

    CodeGeneratorFatalError = Class.new(RuntimeError)

    def self.fatal(message)
      fail CodeGeneratorFatalError, message
    end

    def self.print_tag_warning_suppress
      STDERR.puts "Suppress tag warning output with PB_NO_TAG_WARNINGS=1."
      def self.print_tag_warning_suppress; end
    end

    def self.warn(message)
      STDERR.puts("[WARN] #{message}")
    end

    private

    attr_accessor :request

    public

    def initialize(request_bytes)
      self.request = ::Google::Protobuf::Compiler::CodeGeneratorRequest.decode(request_bytes)
    end

    def generate_file(file_descriptor)
      ::Protobuf::Generators::FileGenerator.new(file_descriptor).generate_output_file
    end

    def response_bytes
      generated_files = request.proto_file.map do |file_descriptor|
        generate_file(file_descriptor)
      end

      ::Google::Protobuf::Compiler::CodeGeneratorResponse.encode(:file => generated_files)
    end

  end
end
