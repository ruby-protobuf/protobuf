require 'spec_helper'
require 'protobuf/rpc/servers/zmq/server'

describe Protobuf::Rpc::Zmq::Server do
  before(:each) do 
    load 'protobuf/zmq.rb'
    ::Protobuf::Rpc::Connector.connector_for_client(true)
  end

  describe '.running?' do
    it 'returns true if running' do
      described_class.instance_variable_set(:@running, true)
      described_class.running?.should be_true
    end

    it 'returns false if not running' do
      described_class.instance_variable_set(:@running, false)
      described_class.running?.should be_false
    end
  end

  describe '.stop' do
    # keep threads instance variable from retaining any thread mocks we've
    # created (breaks tests down the line, otherwise)
    after(:each) do
      described_class.instance_variable_set(:@threads, [])
    end

    it 'lets all threads stop' do
      thread_mock = double(Thread)
      thread_mock.should_receive(:join)
      described_class.instance_variable_set(:@threads, [thread_mock])
      described_class.stop
    end

    it 'sets running to false' do
      described_class.instance_variable_set(:@threads, [])
      described_class.stop
      described_class.instance_variable_get(:@running).should be_false
    end
  end
end
