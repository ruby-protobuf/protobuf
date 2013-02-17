require 'spec_helper'

describe ::Protobuf::Rpc::Zmq::Worker do
  before(:each) do 
    load 'protobuf/zmq.rb'

    fake_socket = double
    fake_socket.should_receive(:connect).and_return(0)
    fake_socket.should_receive(:send_string).and_return(0)

    fake_context = double
    fake_context.should_receive(:socket).and_return( fake_socket )
    ::ZMQ::Context.should_receive(:new).and_return( fake_context )
  end

  subject do
    described_class.new({ :host => '127.0.0.1', :port => 9400 })
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
