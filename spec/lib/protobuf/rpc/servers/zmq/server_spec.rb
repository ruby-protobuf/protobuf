require 'spec_helper'
require 'protobuf/rpc/servers/zmq/server'

describe Protobuf::Rpc::Zmq::Server do
  subject { described_class.new({}) }

  before(:each) do
    load 'protobuf/zmq.rb'
  end

  describe '.running?' do

    it 'returns true if running' do
      subject.instance_variable_set(:@running, true)
      subject.running?.should be_true
    end

    it 'returns false if not running' do
      subject.instance_variable_set(:@running, false)
      subject.running?.should be_false
    end
  end

  describe '.stop' do
    # keep threads instance variable from retaining any thread mocks we've
    # created (breaks tests down the line, otherwise)
    after(:each) do
      subject.instance_variable_set(:@threads, [])
    end

    it 'lets all threads stop' do
      thread_mock = double(Thread)
      thread_mock.should_receive(:join).and_return(thread_mock)
      subject.instance_variable_set(:@threads, [thread_mock])
      subject.stop
    end

    it 'sets running to false' do
      subject.instance_variable_set(:@threads, [])
      subject.stop
      subject.instance_variable_get(:@running).should be_false
    end
  end
end
