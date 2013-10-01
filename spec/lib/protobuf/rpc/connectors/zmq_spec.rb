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

  let(:socket_double) do
    sm = double(::ZMQ::Socket)
    sm.stub(:connect).and_return(0)
    sm
  end

  let(:zmq_context_double) do
    zc = double(::ZMQ::Context)
    zc.stub(:socket).and_return(socket_double)
    zc
  end

  before do
    ::ZMQ::Context.stub(:new).and_return(zmq_context_double)
  end

  describe "#lookup_server_uri" do
    let(:service_directory) { double('ServiceDirectory', :running? => running? ) }
    let(:listing) { double('Listing', :address => '127.0.0.2', :port => 9399) }
    let(:listings) { [listing] }
    let(:running?) { true }

    before do
      subject.stub(:service_directory) { service_directory }
    end

    context "when the service directory is running" do
      it "searches the service directory" do
        service_directory.should_receive(:all_listings_for).and_return(listings)
        subject.send(:lookup_server_uri).should eq "tcp://127.0.0.2:9399"
      end

      it "defaults to the options" do
        service_directory.should_receive(:all_listings_for) { nil }
        subject.send(:lookup_server_uri).should eq "tcp://127.0.0.1:9400"
      end
    end

    context "when the service directory is not running" do
      let(:running?) { false }

      it "defaults to the options" do
        service_directory.should_receive(:all_listings_for) { nil }
        subject.send(:lookup_server_uri).should eq "tcp://127.0.0.1:9400"
      end
    end

    it "checks if the server is alive" do
      service_directory.should_receive(:all_listings_for) { nil }
      subject.should_receive(:host_alive?).with("127.0.0.1") { true }
      subject.send(:lookup_server_uri).should eq "tcp://127.0.0.1:9400"
    end

    context "when no host is alive" do
      it "raises an error" do
        service_directory.stub(:all_listings_for).and_return(listings)
        subject.stub(:host_alive?).and_return(false)
        expect { subject.send(:lookup_server_uri) }.to raise_error
      end
    end

  end

  describe "#host_alive?" do
    context "when the PB_RPC_PING_PORT is not set" do
      before do
        ENV.delete("PB_RPC_PING_PORT")
      end

      it "returns true" do
        subject.send(:host_alive?, "yip.yip").should be_true
      end

      it "does not attempt a connection" do
        TCPSocket.should_not_receive(:new)
        subject.send(:host_alive?, "blargh.com")
      end
    end

    context "when the PB_RPC_PING_PORT is set" do
      before do
        ENV["PB_RPC_PING_PORT"] = "3307"
      end

      it "returns true when the connection succeeds" do
        TCPSocket.should_receive(:new).with("huzzah.com", 3307) { double(:close => nil) }
        subject.send(:host_alive?, "huzzah.com").should be_true
      end

      it "returns false when the connection fails" do
        TCPSocket.should_receive(:new).with("hayoob.com", 3307).and_raise(Errno::ECONNREFUSED)
        subject.send(:host_alive?, "hayoob.com").should be_false
      end

      it "closes the socket" do
        socket = double("TCPSocket")
        socket.should_receive(:close)
        TCPSocket.should_receive(:new).with("absorbalof.com", 3307) { socket }
        subject.send(:host_alive?, "absorbalof.com").should be_true
      end
    end
  end
end
