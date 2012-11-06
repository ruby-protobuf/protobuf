require 'spec_helper'
require 'protobuf/socket'
require 'protobuf/evented'
require 'protobuf/zmq'

describe ::Protobuf::Rpc::Connector do

  describe '.connector_for_client(true)' do
    subject { described_class.connector_for_client }

    context 'Protobuf.connector_type is socket' do
      before { ::Protobuf.connector_type = :socket }
      it { should eq ::Protobuf::Rpc::Connectors::Socket }
    end

    context 'Protobuf.connector_type is not a known value' do
      before { ::Protobuf.connector_type = :socket }
      it { should eq ::Protobuf::Rpc::Connectors::Socket }
    end

    context 'Protobuf.connector_type is evented' do
      before { ::Protobuf.connector_type = :evented }
      it { should eq ::Protobuf::Rpc::Connectors::EventMachine }
    end

    context 'Protobuf.connector_type is zmq' do
      before { ::Protobuf.connector_type = :zmq }
      it { should eq ::Protobuf::Rpc::Connectors::Zmq }
    end
  end

end
