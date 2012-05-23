require 'spec_helper'
require 'protobuf/rpc/servers/zmq/server'

describe Protobuf::Rpc::Zmq::Server do
  it 'functions' do
    StubServer.new(:port => 9399, :server => Protobuf::Rpc::Zmq::Server) do |server|
      with_constants "Protobuf::ClientType" => "Zmq" do
        client = Spec::Proto::TestService.client(:async => false, :port => 9399)
        client.find(:name => "Test Name", :active => true)
      end
      server.stop
    end
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
