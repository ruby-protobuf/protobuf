require 'spec_helper'

RSpec.describe Protobuf::Field::Int32Field do

  class SomeBoolMessage < ::Protobuf::Message
    optional :bool, :some_bool, 1
    required :bool, :required_bool, 2
  end

  let(:instance) { SomeBoolMessage.new }

  describe '#define_setter' do
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

  describe '#define_getter' do
    context 'when required bool field is set to false' do
      subject { instance.required_bool = false; instance.required_bool }

      it 'returns false' do
        expect(subject).to eq(false)
      end
    end
  end
end
