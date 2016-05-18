require 'spec_helper'

require 'protobuf/generators/file_generator'

RSpec.describe ::Protobuf::Generators::FileGenerator do

  let(:base_descriptor_fields) { { :name => 'test/foo.proto' } }
  let(:descriptor_fields) { base_descriptor_fields }
  let(:file_descriptor) { ::Google::Protobuf::FileDescriptorProto.new(descriptor_fields) }

  subject { described_class.new(file_descriptor) }
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
      expect(subject).to receive(:print_require).with('test/bar.pb')
      expect(subject).to receive(:print_require).with('test/baz.pb')
      subject.print_import_requires
    end

  end

  describe '#compile' do
    it 'generates the file contents' do
      subject.compile
      expect(subject.to_s).to eq <<EOF
# encoding: utf-8

##
# This file is auto-generated. DO NOT EDIT!
#
require 'protobuf'

EOF
    end

    it 'generates the file contents using default package name' do
      allow(ENV).to receive(:key?).with('PB_ALLOW_DEFAULT_PACKAGE_NAME')
        .and_return(true)
      subject.compile
      expect(subject.to_s).to eq <<EOF
# encoding: utf-8

##
# This file is auto-generated. DO NOT EDIT!
#
require 'protobuf'

module Foo
  ::Protobuf::Optionable.inject(self) { ::Google::Protobuf::FileOptions }
end

EOF
    end
  end
end
