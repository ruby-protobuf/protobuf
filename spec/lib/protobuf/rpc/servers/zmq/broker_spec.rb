require 'spec_helper'

describe ::Protobuf::Rpc::Zmq::Broker do
  before(:each) do
    load 'protobuf/zmq.rb'
  end

  after(:each) do
    subject.teardown
  end

  subject do
    described_class.new({ :host => '127.0.0.1', :port => 9399, :worker_port => 9400 })
  end

  it 'sets up a context' do
    subject.context.should be_a(::ZMQ::Context)
  end

  it 'sets up a backend socket' do
    subject.backend.should be_a(::ZMQ::Socket)
  end

  it 'sets up a polling object' do
    subject.poller.should be_a(::ZMQ::Poller)
  end

  describe '#poll' do
    # no unit tests for this method
  end
end
