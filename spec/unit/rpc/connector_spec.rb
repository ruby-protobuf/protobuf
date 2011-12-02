require 'spec_helper'

describe Protobuf::Rpc::Connector do
  
  describe '.connector_for_platform' do
    
    context 'when platform is java' do
      let(:platform) { 'jruby' }
      it 'returns a socket connector class reference' do
        Protobuf::Rpc::Connector.connector_for_platform(platform).should eq Protobuf::Rpc::Connectors::Socket
      end
    end
  
    context 'when platform is mri' do
      let(:platform) { 'mri' }
      it 'returns an eventmachine connector class reference' do
        Protobuf::Rpc::Connector.connector_for_platform(platform).should eq Protobuf::Rpc::Connectors::EventMachine
      end
    end
  
    context 'when platform is unknown' do
      let(:platform) { 'some_bogus_engine' }
      it 'returns an eventmachine connector class reference' do
        Protobuf::Rpc::Connector.connector_for_platform(platform).should eq Protobuf::Rpc::Connectors::EventMachine
      end
    end
  
    context 'when platform is not given' do
      it 'returns an eventmachine connector class reference' do
        Protobuf::Rpc::Connector.connector_for_platform.should eq Protobuf::Rpc::Connectors::EventMachine
      end
    end
  
  end
  
end
