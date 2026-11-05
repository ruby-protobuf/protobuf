require 'spec_helper'

RSpec.describe Protobuf::Field::BoolField do

  it_behaves_like :packable_field, described_class do
    let(:value) { [true, false] }
  end

  class SomeBoolMessage < ::Protobuf::Message
    optional :bool, :some_bool, 1
    required :bool, :required_bool, 2
  end

  let(:instance) { SomeBoolMessage.new }

  describe 'setting and getting field' do
    subject { instance.some_bool = value; instance.some_bool }

    [true, false].each do |val|
      context "when set with #{val}" do
        let(:value) { val }

        it 'is readable as a bool' do
          expect(subject).to eq(val)
        end
      end
    end

    [['true', true], ['false', false]].each do |val, expected|
      context "when set with a string of #{val}" do
        let(:value) { val }

        it 'is readable as a bool' do
          expect(subject).to eq(expected)
        end
      end
    end

    context 'when set with a non-bool string' do
      let(:value) { "aaaa" }

      it 'throws an error' do
        expect { subject }.to raise_error(TypeError)
      end
    end

    context 'when set with something that is not a bool' do
      let(:value) { [1, 2, 3] }

      it 'throws an error' do
        expect { subject }.to raise_error(TypeError)
      end
    end
  end

  describe '#decode' do
    subject { described_class.new(SomeBoolMessage, :optional, described_class, :b, 1, :b, {}) }

    it 'decodes 0 as false' do
      expect(subject.decode(0)).to be(false)
    end

    it 'decodes 1 as true' do
      expect(subject.decode(1)).to be(true)
    end

    it 'decodes any other non-zero varint as true, like the reference parsers' do
      expect(subject.decode(2)).to be(true)
      expect(subject.decode(0xffff_ffff_ffff_ffff)).to be(true)
    end
  end

  it 'decodes a non-canonical varint (2) on the wire as true' do
    expect(SomeBoolMessage.decode("\x08\x02".b).some_bool).to be(true)
  end

  it 'defines ? method' do
    instance.required_bool = false
    expect(instance.required_bool?).to be(false)
  end

  describe '#default_value' do
    context 'optional and required fields' do
      it 'returns the class default' do
        expect(SomeBoolMessage.get_field('some_bool').default).to be nil
        expect(::Protobuf::Field::BoolField.default).to be false
        expect(instance.some_bool).to be false
      end

      context 'with field default' do
        class AnotherBoolMessage < ::Protobuf::Message
          optional :bool, :set_bool, 1, :default => true
        end

        it 'returns the set default' do
          expect(AnotherBoolMessage.get_field('set_bool').default).to be true
          expect(AnotherBoolMessage.new.set_bool).to be true
        end
      end
    end

    context 'repeated field' do
      class RepeatedBoolMessage < ::Protobuf::Message
        repeated :bool, :repeated_bool, 1
      end

      it 'returns the set default' do
        expect(RepeatedBoolMessage.new.repeated_bool).to eq []
      end
    end
  end
end
