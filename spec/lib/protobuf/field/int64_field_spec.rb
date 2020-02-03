require 'spec_helper'

RSpec.describe Protobuf::Field::Int64Field do

  it_behaves_like :packable_field, described_class

  let(:message) do
    Class.new(::Protobuf::Message) do
      optional :int64, :field, 1
    end
  end

  # https://developers.google.com/protocol-buffers/docs/proto3#json
  describe '.{to_json, from_json}' do
    it 'serialises int64 value as string' do
      instance = message.new(:field => 10)
      expect(instance.to_json).to eq('{"field":"10"}')
    end
  end
end
