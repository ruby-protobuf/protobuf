require 'spec_helper'
require 'protobuf/socket'
require 'protobuf/evented'
require 'protobuf/zmq'

describe ::Protobuf::Rpc::Connector do

  describe '.connector_for_client(true)' do
    after { described_class.instance_variable_set(:@_connector, nil) }

    context 'Protobuf.connector_type is socket' do
      it 'returns a socket connector class' do
        ::Protobuf.connector_type = :socket
        described_class.connector_for_client(true).should eq ::Protobuf::Rpc::Connectors::Socket
      end
    end

    context 'Protobuf.connector_type is not a known value' do
      it 'returns a socket connector class' do
        ::Protobuf.stub(:connector_type).and_return('some value')
        described_class.connector_for_client(true).should eq ::Protobuf::Rpc::Connectors::Socket
      end
    end

    context 'Protobuf.connector_type is evented' do
      it 'returns an eventmachine connector class' do
        ::Protobuf.connector_type = :evented
        described_class.connector_for_client(true).should eq ::Protobuf::Rpc::Connectors::EventMachine
      end
    end

    context 'Protobuf.connector_type is zmq' do
      it 'returns a zmq connector class' do
        ::Protobuf.connector_type = :zmq
        described_class.connector_for_client(true).should eq ::Protobuf::Rpc::Connectors::Zmq
      end
    end

  end

end
