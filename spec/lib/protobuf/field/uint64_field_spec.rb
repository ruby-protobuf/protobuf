require 'spec_helper'

RSpec.describe Protobuf::Field::Uint64Field do

  it_behaves_like :packable_field, described_class

  let(:message) do
    Class.new(::Protobuf::Message) do
      optional :uint64, :field, 1
    end
  end

  # https://developers.google.com/protocol-buffers/docs/proto3#json
  describe '.{to_json, from_json}' do
    it 'serialises 0 as empty' do
      instance = message.new(:field => 0)
      expect(instance.to_json).to eq('{}')
    end

    it 'serialises max value as string' do
      instance = message.new(:field => described_class.max)
      expect(instance.to_json).to eq('{"field":"18446744073709551615"}')
    end

    it 'serialises min value as string' do
      instance = message.new(:field => described_class.min)
      expect(instance.to_json).to eq('{}')
    end
  end
end
