require 'spec_helper'
require 'protobuf/zmq'

describe ::Protobuf::Rpc::Connectors::Zmq do
  let(:socket_mock) do
    sm = mock(::ZMQ::Socket)
    sm.stub(:connect).and_return(0)
    sm
  end

  let(:zmq_context_mock) do
    zc = mock(::ZMQ::Context)
    zc.stub(:socket).and_return(socket_mock)
    zc
  end

  before(:each) do
    ::ZMQ::Context.stub(:new).and_return(zmq_context_mock)
  end

  it 'raises if async is true' do
    expect {
      described_class.new(async: true).send_request
    }.to raise_error
  end

end
