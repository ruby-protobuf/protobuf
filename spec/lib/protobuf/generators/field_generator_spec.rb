require 'spec_helper'

require 'protobuf/generators/field_generator'

RSpec.describe ::Protobuf::Generators::FieldGenerator do

  let(:label_enum) { :LABEL_OPTIONAL }
  let(:name) { 'foo_bar' }
  let(:number) { 3 }
  let(:type_enum) { :TYPE_STRING }
  let(:type_name) { nil }
  let(:default_value) { nil }
  let(:extendee) { nil }
  let(:field_options) { {} }

  let(:field_fields) do
    {
      :label => label_enum,
      :name => name,
      :number => number,
      :type => type_enum,
      :type_name => type_name,
      :default_value => default_value,
      :extendee => extendee,
      :options => field_options,
    }
  end

  let(:field) { ::Google::Protobuf::FieldDescriptorProto.new(field_fields) }

  describe '#compile' do
    subject { described_class.new(field).to_s }

    specify { expect(subject).to eq "optional :string, :foo_bar, 3\n" }

    context 'when the type is another message' do
      let(:type_enum) { :TYPE_MESSAGE }
      let(:type_name) { '.foo.bar.Baz' }

      specify { expect(subject).to eq "optional ::Foo::Bar::Baz, :foo_bar, 3\n" }
    end

    context 'when a default value is used' do
      let(:type_enum) { :TYPE_INT32 }
      let(:default_value) { '42' }
      specify { expect(subject).to eq "optional :int32, :foo_bar, 3, :default => 42\n" }

      context 'when type is an enum' do
        let(:type_enum) { :TYPE_ENUM }
        let(:type_name) { '.foo.bar.Baz' }
        let(:default_value) { 'QUUX' }

        specify { expect(subject).to eq "optional ::Foo::Bar::Baz, :foo_bar, 3, :default => ::Foo::Bar::Baz::QUUX\n" }
      end

      context 'when the type is a string' do
        let(:type_enum) { :TYPE_STRING }
        let(:default_value) { "a default \"string\"" }

        specify { expect(subject).to eq "optional :string, :foo_bar, 3, :default => \"a default \"string\"\"\n" }
      end

      context 'when float or double field type' do
        let(:type_enum) { :TYPE_DOUBLE }

        context 'when the default value is "nan"' do
          let(:default_value) { 'nan' }
          specify { expect(subject).to match(/::Float::NAN/) }
        end

        context 'when the default value is "inf"' do
          let(:default_value) { 'inf' }
          specify { expect(subject).to match(/::Float::INFINITY/) }
        end

        context 'when the default value is "-inf"' do
          let(:default_value) { '-inf' }
          specify { expect(subject).to match(/-::Float::INFINITY/) }
        end
      end
    end

    context 'when the field is an extension' do
      let(:extendee) { 'foo.bar.Baz' }

      specify { expect(subject).to eq "optional :string, :foo_bar, 3, :extension => true\n" }
    end

    context 'when field is packed' do
      let(:field_options) { { :packed => true } }

      specify { expect(subject).to eq "optional :string, :foo_bar, 3, :packed => true\n" }
    end

    context 'when field is deprecated' do
      let(:field_options) { { :deprecated => true } }

      specify { expect(subject).to eq "optional :string, :foo_bar, 3, :deprecated => true\n" }
    end
  end

end
