require 'spec_helper'

require 'protobuf/generators/field_generator'

describe ::Protobuf::Generators::FieldGenerator do

  let(:label_enum) { :LABEL_OPTIONAL }
  let(:name) { 'foo_bar' }
  let(:number) { 3 }
  let(:type_enum) { :TYPE_STRING }
  let(:type_name) { nil }
  let(:default_value) { nil }
  let(:extendee) { nil }
  let(:field_options) { {} }

  let(:field_fields) { { :label => label_enum,
                         :name => name,
                         :number => number,
                         :type => type_enum,
                         :type_name => type_name,
                         :default_value => default_value,
                         :extendee => extendee,
                         :options => field_options } }

  let(:field) { ::Google::Protobuf::FieldDescriptorProto.new(field_fields) }

  describe '#compile' do
    subject { described_class.new(field).to_s }

    it { should eq "optional ::Protobuf::Field::StringField, :foo_bar, 3\n" }

    context 'when the type is another message' do
      let(:type_enum) { :TYPE_MESSAGE }
      let(:type_name) { '.foo.bar.Baz' }

      it { should eq "optional ::Foo::Bar::Baz, :foo_bar, 3\n" }
    end

    context 'when a default value is used' do
      let(:type_enum) { :TYPE_INT32 }
      let(:default_value) { '42' }
      it { should eq "optional ::Protobuf::Field::Int32Field, :foo_bar, 3, :default => 42\n" }

      context 'when type is an enum' do
        let(:type_enum) { :TYPE_ENUM }
        let(:type_name) { '.foo.bar.Baz' }
        let(:default_value) { 'QUUX' }

        it { should eq "optional ::Foo::Bar::Baz, :foo_bar, 3, :default => ::Foo::Bar::Baz::QUUX\n" }
      end

      context 'when the type is a string' do
        let(:type_enum) { :TYPE_STRING }
        let(:default_value) { "a default 'string'" }

        it { should eq "optional ::Protobuf::Field::StringField, :foo_bar, 3, :default => 'a default \\'string\\''\n" }
      end
    end

    context 'when the field is an extension' do
      let(:extendee) { 'foo.bar.Baz' }

      it { should eq "optional ::Protobuf::Field::StringField, :foo_bar, 3, :extension => true\n" }
    end

    context 'when field is packed' do
      let(:field_options) { { :packed => true } }

      it { should eq "optional ::Protobuf::Field::StringField, :foo_bar, 3, :packed => true\n" }
    end

    context 'when field is deprecated' do
      let(:field_options) { { :deprecated => true } }

      it { should eq "optional ::Protobuf::Field::StringField, :foo_bar, 3, :deprecated => true\n" }
    end
  end

end

