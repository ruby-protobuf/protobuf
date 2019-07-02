require 'spec_helper'

require 'protobuf/generators/file_generator'

RSpec.describe ::Protobuf::Generators::FileGenerator do

  let(:base_descriptor_fields) { { :name => 'test/foo.proto' } }
  let(:descriptor_fields) { base_descriptor_fields }
  let(:file_descriptor) { ::Google::Protobuf::FileDescriptorProto.new(descriptor_fields) }

  subject { described_class.new(file_descriptor, {}) }
  specify { expect(subject.file_name).to eq('test/foo.pb.rb') }

  describe '#print_import_requires' do
    let(:descriptor_fields) do
      base_descriptor_fields.merge(
        :dependency => [
          'test/bar.proto',
          'test/baz.proto',
        ],
      )
    end

    it 'prints a ruby require for each dependency' do
      expect(subject).to receive(:print_require).with('test/bar.pb', false)
      expect(subject).to receive(:print_require).with('test/baz.pb', false)
      subject.print_import_requires
    end

    it 'prints a ruby require_relative for each dependency if environment variable was set' do
      expect(subject).to receive(:print_require).with('test/bar.pb', true)
      expect(subject).to receive(:print_require).with('test/baz.pb', true)
      ENV['PB_REQUIRE_RELATIVE'] = 'true'
      subject.print_import_requires
      ENV.delete('PB_REQUIRE_RELATIVE')
    end
  end

  describe '#compile' do
    it 'generates the file contents' do
      subject.compile
      expect(subject.to_s).to eq <<EOF.chomp
# encoding: utf-8
# frozen_string_literal: true

##
# This file is auto-generated. DO NOT EDIT!
#
require 'base64'
require 'set'
require 'protobuf'

FULLY_QUALIFIED_NAME = '' unless defined?(self::FULLY_QUALIFIED_NAME)

@descriptors = [] unless instance_variable_defined?(:@descriptors)
@descriptors << lambda do
  bytes = File.read(__FILE__, mode: 'rb').split(/^__END__$/, 2).last
  ::Google::Protobuf::FileDescriptorProto.decode(Base64.decode64(bytes))
end

@descriptor_dependencies = Set.new unless instance_variable_defined?(:@descriptor_dependencies)
@descriptor_dependencies |= []

unless respond_to?(:descriptor_set)
  def self.descriptor_set
    ::Google::Protobuf::FileDescriptorSet.new(:file => @descriptors.map(&:call))
  end
end

unless respond_to?(:descriptor_dependencies)
  def self.descriptor_dependencies
    @descriptor_dependencies
  end
end

# Raw descriptor bytes below
__END__
#{Base64.encode64(file_descriptor.encode)}
EOF
    end

    it 'generates the file contents using default package name' do
      allow(ENV).to receive(:key?).with('PB_ALLOW_DEFAULT_PACKAGE_NAME')
        .and_return(true)
      subject.compile
      expect(subject.to_s).to eq <<EOF.chomp
# encoding: utf-8
# frozen_string_literal: true

##
# This file is auto-generated. DO NOT EDIT!
#
require 'base64'
require 'set'
require 'protobuf'

module Foo
  FULLY_QUALIFIED_NAME = '' unless defined?(self::FULLY_QUALIFIED_NAME)

  @descriptors = [] unless instance_variable_defined?(:@descriptors)
  @descriptors << lambda do
    bytes = File.read(__FILE__, mode: 'rb').split(/^__END__$/, 2).last
    ::Google::Protobuf::FileDescriptorProto.decode(Base64.decode64(bytes))
  end

  @descriptor_dependencies = Set.new unless instance_variable_defined?(:@descriptor_dependencies)
  @descriptor_dependencies |= []

  unless respond_to?(:descriptor_set)
    def self.descriptor_set
      ::Google::Protobuf::FileDescriptorSet.new(:file => @descriptors.map(&:call))
    end
  end

  unless respond_to?(:descriptor_dependencies)
    def self.descriptor_dependencies
      @descriptor_dependencies
    end
  end
  ::Protobuf::Optionable.inject(self) { ::Google::Protobuf::FileOptions }
end


# Raw descriptor bytes below
__END__
#{Base64.encode64(file_descriptor.encode)}
EOF
    end

    context 'with extended messages' do
      let(:descriptor_fields) do
        base_descriptor_fields.merge(
          :package => 'test.pkg.file_generator_spec',
          :extension => [{
            :name => 'boom',
            :number => 20_000,
            :label => Google::Protobuf::FieldDescriptorProto::Label::LABEL_OPTIONAL,
            :type => Google::Protobuf::FieldDescriptorProto::Type::TYPE_STRING,
            :extendee => '.google.protobuf.FieldOptions',
          }],
        )
      end

      it 'generates the file contents that include the namespaced extension name' do
        subject.compile
        expect(subject.to_s).to eq <<EOF.chomp
# encoding: utf-8
# frozen_string_literal: true

##
# This file is auto-generated. DO NOT EDIT!
#
require 'base64'
require 'set'
require 'protobuf'

module Test
  module Pkg
    module File_generator_spec
      FULLY_QUALIFIED_NAME = 'test.pkg.file_generator_spec' unless defined?(self::FULLY_QUALIFIED_NAME)

      @descriptors = [] unless instance_variable_defined?(:@descriptors)
      @descriptors << lambda do
        bytes = File.read(__FILE__, mode: 'rb').split(/^__END__$/, 2).last
        ::Google::Protobuf::FileDescriptorProto.decode(Base64.decode64(bytes))
      end

      @descriptor_dependencies = Set.new unless instance_variable_defined?(:@descriptor_dependencies)
      @descriptor_dependencies |= []

      unless respond_to?(:descriptor_set)
        def self.descriptor_set
          ::Google::Protobuf::FileDescriptorSet.new(:file => @descriptors.map(&:call))
        end
      end

      unless respond_to?(:descriptor_dependencies)
        def self.descriptor_dependencies
          @descriptor_dependencies
        end
      end
      ::Protobuf::Optionable.inject(self) { ::Google::Protobuf::FileOptions }

      ##
      # Extended Message Fields
      #
      class ::Google::Protobuf::FieldOptions < ::Protobuf::Message
        optional :string, :".test.pkg.file_generator_spec.boom", 20000, :extension => true
      end

    end

  end

end


# Raw descriptor bytes below
__END__
#{Base64.encode64(file_descriptor.encode)}
EOF
      end
    end

  end
end
