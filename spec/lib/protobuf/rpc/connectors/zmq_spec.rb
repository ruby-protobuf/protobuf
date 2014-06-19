require 'spec_helper'
require 'protobuf/zmq'

describe ::Protobuf::Rpc::Connectors::Zmq do
  subject { described_class.new(options) }
  
  it_behaves_like "a Protobuf Connector"

  specify{ described_class.include?(Protobuf::Rpc::Connectors::Common).should be_truthy }

  let(:options) {{
    :service => "Test::Service",
    :method => "find",
    :timeout => 3,
    :host => "127.0.0.1",
    :port => "9400"
  }}

  let(:socket_double) { double(::ZMQ::Socket, :connect => 0) }
  let(:zmq_context_double) { double(::ZMQ::Context, :socket => socket_double) }

  before do
    allow(::ZMQ::Context).to receive(:new).and_return(zmq_context_double)
  end

  before(:all) do
    @ping_port_before = ENV['PB_RPC_PING_PORT']
  end

  after(:all) do
    ENV['PB_RPC_PING_PORT'] = @ping_port_before
  end

  describe "#lookup_server_uri" do
    let(:service_directory) { double('ServiceDirectory', :running? => running? ) }
    let(:listing) { double('Listing', :address => '127.0.0.2', :port => 9399) }
    let(:listings) { [listing] }
    let(:running?) { true }

    before { allow(subject).to receive(:service_directory).and_return(service_directory) }

    context "when the service directory is running" do
      it "searches the service directory" do
        allow(service_directory).to receive(:all_listings_for).and_return(listings)
        expect(subject.send(:lookup_server_uri)).to eq "tcp://127.0.0.2:9399"
      end

      it "defaults to the options" do
        allow(service_directory).to receive(:all_listings_for).and_return([])
        expect(subject.send(:lookup_server_uri)).to eq "tcp://127.0.0.1:9400"
      end
    end

    context "when the service directory is not running" do
      let(:running?) { false }

      it "defaults to the options" do
        allow(service_directory).to receive(:all_listings_for).and_return([])
        expect(subject.send(:lookup_server_uri)).to eq "tcp://127.0.0.1:9400"
      end
    end

    it "checks if the server is alive" do
      allow(service_directory).to receive(:all_listings_for).and_return([])
      expect(subject).to receive(:host_alive?).with("127.0.0.1") { true }
      expect(subject.send(:lookup_server_uri)).to eq "tcp://127.0.0.1:9400"
    end

    context "when no host is alive" do
      it "raises an error" do
        allow(service_directory).to receive(:all_listings_for).and_return(listings)
        allow(subject).to receive(:host_alive?).and_return(false)
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
        expect(subject.send(:host_alive?, "yip.yip")).to be_truthy
      end

      it "does not attempt a connection" do
        expect(TCPSocket).not_to receive(:new)
        subject.send(:host_alive?, "blargh.com")
      end
    end

    context "when the PB_RPC_PING_PORT is set" do
      before do
        ENV["PB_RPC_PING_PORT"] = "3307"
      end

      it "returns true when the connection succeeds" do
        expect(TCPSocket).to receive(:new).with("huzzah.com", 3307).and_return(double(:close => nil))
        expect(subject.send(:host_alive?, "huzzah.com")).to be_truthy
      end

      it "returns false when the connection fails" do
        expect(TCPSocket).to receive(:new).with("hayoob.com", 3307).and_raise(Errno::ECONNREFUSED)
        expect(subject.send(:host_alive?, "hayoob.com")).to be_falsey
      end

      it "closes the socket" do
        socket = double("TCPSocket")
        expect(socket).to receive(:close)
        expect(TCPSocket).to receive(:new).with("absorbalof.com", 3307).and_return(socket)
        expect(subject.send(:host_alive?, "absorbalof.com")).to be_truthy
      end
    end
  end
end
