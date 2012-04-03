require 'spec_helper'

describe Protobuf::Rpc::Connector do
  
  describe '.connector_for_client' do
    
    context 'when set to Socket connector' do
      it 'returns a socket connector class reference' do
        with_constants "Protobuf::ClientType" => "Socket" do
          Protobuf::Rpc::Connector.connector_for_client.should eq(Protobuf::Rpc::Connectors::Socket)
        end
      end
    end
  
    context 'when set to non Socket Connector' do
      it 'returns an eventmachine connector class reference' do
        with_constants "Protobuf::ClientType" => "EventMachine" do 
          Protobuf::Rpc::Connector.connector_for_client.should eq Protobuf::Rpc::Connectors::EventMachine
        end
      end
    end
  
    context 'when connector type not given' do
      it 'returns an eventmachine connector class reference' do
        Protobuf::Rpc::Connector.connector_for_client.should eq Protobuf::Rpc::Connectors::EventMachine
      end
    end
  
  end
  
end
