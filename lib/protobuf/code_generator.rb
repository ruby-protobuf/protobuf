require 'active_support'
require 'active_support/core_ext/module/aliasing'
require 'protobuf/generators/file_generator'

module Protobuf
  class CodeGenerator

    CodeGeneratorFatalError = Class.new(RuntimeError)

    def self.fatal(message)
      fail CodeGeneratorFatalError, message
    end

    def self.print_tag_warning_suppress
      STDERR.puts "Suppress tag warning output with PB_NO_TAG_WARNINGS=1."
      def self.print_tag_warning_suppress; end # rubocop:disable Lint/DuplicateMethods, Lint/NestedMethodDefinition
    end

    def self.warn(message)
      STDERR.puts("[WARN] #{message}")
    end

    private

    attr_accessor :request

    public

    def initialize(request_bytes)
      @request_bytes = request_bytes
      self.request = ::Google::Protobuf::Compiler::CodeGeneratorRequest.decode(request_bytes)
    end

    def eval_unknown_extensions!
      request.proto_file.each do |file_descriptor|
        ::Protobuf::Generators::FileGenerator.new(file_descriptor).eval_unknown_extensions!
      end
      self.request = ::Google::Protobuf::Compiler::CodeGeneratorRequest.decode(@request_bytes)
    end

    def generate_file(file_descriptor)
      ::Protobuf::Generators::FileGenerator.new(file_descriptor).generate_output_file
    end

    def response_bytes
      generated_files = request.proto_file.map do |file_descriptor|
        generate_file(file_descriptor)
      end

      ::Google::Protobuf::Compiler::CodeGeneratorResponse.encode(
        :file => generated_files,
        :supported_features => supported_features,
      )
    end

    def supported_features
      # The only available feature is proto3 with optional fields.
      # This is backwards compatible with proto2 optional fields.
      ::Google::Protobuf::Compiler::CodeGeneratorResponse::Feature::FEATURE_PROTO3_OPTIONAL.to_i
    end

    # Option syntax sets each field of an options message on its own line, so
    # the message fields of these classes merge (see set_with_options).
    OPTIONS_CLASSES = [
      ::Google::Protobuf::EnumOptions, ::Google::Protobuf::EnumValueOptions, ::Google::Protobuf::FieldOptions,
      ::Google::Protobuf::FileOptions, ::Google::Protobuf::MethodOptions, ::Google::Protobuf::ServiceOptions,
      ::Google::Protobuf::MessageOptions
    ].freeze

    # The message fields of an options message merge in
    # BaseField#set_with_options, so Decoder must call set for them.
    module OptionsMessageFieldDecode
      def iterative_decode?
        return @options_iterative_decode unless @options_iterative_decode.nil?

        @options_iterative_decode = OPTIONS_CLASSES.none? { |klass| message_class <= klass } && super
      end
    end
    Protobuf::Field::MessageField.prepend(OptionsMessageFieldDecode)

    Protobuf::Field::BaseField.module_eval do
      # Sets a MessageField that is known to be an option.
      # We must allow fields to be set one at a time, as option syntax allows us to
      # set each field within the option using a separate "option" line.
      # Every other field uses the normal set method.
      def set_with_options(message_instance, bytes, record_wire_type = nil)
        if message_instance[name].is_a?(::Protobuf::Message)
          if OPTIONS_CLASSES.any? { |klass| message_instance.is_a?(klass) }
            original_field = message_instance[name]
            decoded_field = decode(bytes)
            decoded_field.each_field do |subfield, subvalue|
              option_set(original_field, subfield, subvalue) { decoded_field.field?(subfield.tag) }
            end
            return
          end
        end

        @set_method.call(message_instance, bytes, record_wire_type)
      end
      alias_method :set, :set_with_options

      def option_set(message_field, subfield, subvalue)
        return unless yield
        if subfield.repeated?
          message_field[subfield.tag].concat(subvalue)
        elsif message_field[subfield.tag] && subvalue.is_a?(::Protobuf::Message)
          subvalue.each_field do |f, v|
            option_set(message_field[subfield.tag], f, v) { subvalue.field?(f.tag) }
          end
        else
          message_field[subfield.tag] = subvalue
        end
      end
    end
  end
end
