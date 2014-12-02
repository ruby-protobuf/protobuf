require 'spec_helper'

RSpec.describe Protobuf::Service do
  context 'class methods' do
    subject { Test::ResourceService }

    describe '.rpc' do
      before { Test::ResourceService.rpc(:update, Test::ResourceFindRequest, Test::Resource) }
      subject { Test::ResourceService.rpcs[:update] }
      specify { expect(subject.method).to eq :update }
      specify { expect(subject.request_type).to eq Test::ResourceFindRequest }
      specify { expect(subject.response_type).to eq Test::Resource }
    end

    describe '.rpc_method?' do
      before { Test::ResourceService.rpc(:delete, Test::Resource, Test::Resource) }

      context 'when given name is a pre-defined rpc method' do
        it 'returns true' do
          expect(subject.rpc_method?(:delete)).to be true
        end
      end

      context 'when given name is not a pre-defined rpc method' do
        it 'returns false' do
          expect(subject.rpc_method?(:zoobaboo)).to be false
        end
      end
    end
  end
end
