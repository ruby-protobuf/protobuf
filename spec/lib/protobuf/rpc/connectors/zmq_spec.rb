require 'spec_helper'
require 'protobuf/zmq'

describe ::Protobuf::Rpc::Connectors::Zmq do
  subject { described_class.new(options) }

  let(:options) {{
    :service => "Test::Service",
    :method => "find",
    :timeout => 3,
    :host => "127.0.0.1",
    :port => "9400"
  }}

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

  before do
    ::ZMQ::Context.stub(:new).and_return(zmq_context_mock)
  end

  describe "#server_uri" do
    let(:service_directory) { double('ServiceDirectory', :running? => running? ) }
    let(:listing) { double('Listing', :address => '127.0.0.2', :port => 9399) }
    let(:running?) { true }

    before do
      subject.stub(:service_directory) { service_directory }
    end

    context "when the service directory is running" do
      it "searches the service directory" do
        service_directory.should_receive(:lookup).and_return(listing)
        subject.send(:server_uri).should eq "tcp://127.0.0.2:9399"
      end

      it "defaults to the options" do
        service_directory.should_receive(:lookup) { nil }
        subject.send(:server_uri).should eq "tcp://127.0.0.1:9400"
      end
    end

    context "when the service directory is not running" do
      let(:running?) { false }

      it "does not search the directory" do
        service_directory.should_not_receive(:lookup)
        subject.send(:server_uri).should eq "tcp://127.0.0.1:9400"
      end
    end

  end

  pending
end
