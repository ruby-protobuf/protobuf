require 'spec_helper'
require 'protobuf/rpc/servers/zmq/server'

describe Protobuf::Rpc::Zmq::Server do
  subject { described_class.new(options) }

  let(:options) {{
    :host => '127.0.0.1',
    :port => 9399,
    :worker_port => 9400,
    :workers_only => true
  }}

  before do
    load 'protobuf/zmq.rb'
  end

  after do
    subject.teardown
  end

  it 'sets up a ZMQ context' do
    subject.instance_variable_get(:@zmq_context).should be_a(::ZMQ::Context)
  end

  it 'sets up a backend socket' do
    subject.instance_variable_get(:@backend_socket).should be_a(::ZMQ::Socket)
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
    it 'signals shutdown' do
      subject.should_receive(:signal_shutdown)
      subject.stop
    end

    it 'sets running to false' do
      subject.instance_variable_set(:@workers, [])
      subject.stop
      subject.instance_variable_get(:@running).should be_false
    end
  end
end
