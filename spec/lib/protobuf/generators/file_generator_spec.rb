require 'spec_helper'

require 'protobuf/generators/file_generator'

describe ::Protobuf::Generators::FileGenerator do

  let(:base_descriptor_fields) { { :name => 'test/foo.proto' } }
  let(:descriptor_fields) { base_descriptor_fields }
  let(:file_descriptor) { ::Google::Protobuf::FileDescriptorProto.new(descriptor_fields) }

  subject { described_class.new(file_descriptor) }
  its(:file_name) { should eq 'test/foo.pb.rb' }

  describe '#print_import_requires' do
    let(:descriptor_fields) do
      base_descriptor_fields.merge!({ :dependency => [ 'test/bar.proto',
                                                       'test/baz.proto' ] })
    end

    it 'prints a ruby require for each dependency' do
      subject.should_receive(:print_require).with('test/bar.pb')
      subject.should_receive(:print_require).with('test/baz.pb')
      subject.print_import_requires
    end

  end

end

