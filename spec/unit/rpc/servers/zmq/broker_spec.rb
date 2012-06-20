require 'spec_helper'

describe ::Protobuf::Rpc::Zmq::Broker do
  after(:each) do
    subject.teardown
  end

  it 'sets up a context' do
    subject.context.should be_a(::ZMQ::Context)
  end

  it 'sets up a frontend socket' do
    subject.frontend.should be_a(::ZMQ::Socket)
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
