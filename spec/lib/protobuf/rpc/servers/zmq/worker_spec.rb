require 'spec_helper'

describe ::Protobuf::Rpc::Zmq::Worker do
  before(:each) do 
    load 'protobuf/zmq.rb'
    ::Protobuf::Rpc::Connector.connector_for_client(true)
  end

  after(:each) do
    subject.instance_variable_get(:@socket).close
    subject.instance_variable_get(:@zmq_context).terminate
  end

  it 'sets the context' do
    subject.instance_variable_get(:@zmq_context).should be_a(::ZMQ::Context)
  end

  it 'sets the poller' do
    subject.instance_variable_get(:@socket).should be_a(::ZMQ::Socket)
  end

  it 'sets the socket' do
    subject.instance_variable_get(:@poller).should be_a(::ZMQ::Poller)
  end

  describe '#run' do
    # not tested via unit tests
  end

  describe '#handle_request' do
    # not tested via unit tests
  end

  describe '#initialize_buffers' do
    # not tested via unit tests
  end

  describe '#send_data' do
    # not tested via unit tests
  end
end
