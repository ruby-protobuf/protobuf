require 'spec_helper'
require 'protobuf/socket'
require 'protobuf/zmq'

RSpec.describe ::Protobuf::Rpc::Connector do

  describe '.connector_for_client(true)' do
    subject { described_class.connector_for_client }

    context 'Protobuf.connector_type is socket' do
      before { ::Protobuf.connector_type = :socket }
      specify { expect(subject).to eq ::Protobuf::Rpc::Connectors::Socket }
    end

    context 'Protobuf.connector_type is not a known value' do
      before { allow(::Protobuf).to receive(:connector_type).and_return(:foo) }
      specify { expect(subject).to eq(::Protobuf::Rpc::Connectors::Socket) }
    end

    context 'Protobuf.connector_type is zmq' do
      before { ::Protobuf.connector_type = :zmq }
      specify { expect(subject).to eq(::Protobuf::Rpc::Connectors::Zmq) }
    end
  end

end
