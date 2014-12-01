require 'spec_helper'

RSpec.describe Protobuf::Field::FloatField do

  class SomeFloatMessage < ::Protobuf::Message
    optional :float, :some_float, 1
  end

  let(:instance) { SomeFloatMessage.new }

  describe '#define_setter' do
    subject { instance.some_float = value; instance.some_float }

    context 'when set with an int' do
      let(:value) { 100 }

      it 'is readable as a float' do
        expect(subject).to eq(100.0)
      end
    end

    context 'when set with a float' do
      let(:value) { 100.1 }

      it 'is readable as a float' do
        expect(subject).to eq(100.1)
      end
    end

    context 'when set with a string of a float' do
      let(:value) { "101.1" }

      it 'is readable as a float' do
        expect(subject).to eq(101.1)
      end
    end

    context 'when set with a non-numeric string' do
      let(:value) { "aaaa" }

      it 'throws an error' do
        expect { subject }.to raise_error(ArgumentError)
      end
    end

    context 'when set with something that is not a float' do
      let(:value) { [1, 2, 3] }

      it 'throws an error' do
        expect { subject }.to raise_error(TypeError)
      end
    end
  end

end
