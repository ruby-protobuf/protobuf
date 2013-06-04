require 'spec_helper'

require 'protobuf/rpc/service_directory'

describe ::Protobuf::Rpc::ServiceDirectory do
  let(:instance) { ::Protobuf::Rpc::ServiceDirectory.instance }

  def listings
    instance.instance_variable_get(:@listings)
  end

  before(:all) do
    ::Protobuf::Rpc::ServiceDirectory.timeout = 0.1
  end

  after do
    instance.stop
  end

  it "is a singleton" do
    instance.should be_a_kind_of(Singleton)
  end

  describe "#find" do
    let(:server) { double('server', :uuid => '123',
                          :services => ['Known::Service'],
                          :address => "0.0.0.0",
                          :port => 9999,
                          :ttl => 15) }
    let(:listing) { ::Protobuf::Rpc::ServiceDirectory::Listing.new(server) }

    it "times out when nothing is found" do
      expect {
        instance.find("Unknown::Service")
      }.to raise_error(::Protobuf::Rpc::ServiceDirectory::ServiceNotFound)
    end

    it "returns a listing for the given service" do
      instance.add_listing_for(server)
      instance.find("Known::Service").should eq listing
    end

    it "delegates to #youngest_listing_for" do
      instance.should_receive(:youngest_listing_for)
              .with("Known::Service") { double('listing') }
      instance.find("Known::Service")
    end
  end

  describe "#remove_expired_listings" do
    before do
      instance.instance_variable_set(:@listings, {
        '1' => double(:expired? => true),
        '2' => double(:expired? => true),
        '3' => double(:expired? => false),
      })
    end

    it "removes expired listings" do
      expect {
        instance.remove_expired_listings
      }.to change(listings, :size).from(3).to(1)
      listings.keys.should eq ['3']
    end
  end

  describe "#start" do
    it "creates a thread" do
      Thread.should_receive(:new)
      instance.start
    end

    it "initializes the socket" do
      instance.should_receive :init_socket
      instance.start
    end

    it "calls #run" do
      instance.should_receive(:run)
      instance.start
      sleep 0.01
    end

    it "changes the running state" do
      expect {
        instance.start
      }.to change(instance, :running?).from(false).to(true)
    end
  end

  describe "#youngest_listing_for" do
    it "returns the youngest listing" do
      instance.add_listing_for double(:uuid => 1, :ttl => 5, :services => ["Test"])
      instance.add_listing_for double(:uuid => 2, :ttl => 15, :services => ["Test"])
      instance.add_listing_for double(:uuid => 3, :ttl => 10, :services => ["Test"])
      instance.youngest_listing_for("Test").uuid.should eq 2
    end

    it "does not return expired listings" do
      instance.instance_variable_set(:@listings, {
        '1' => double(:current? => false, :services => ["Test"]),
      })

      instance.youngest_listing_for("Test").should be_nil
    end
  end

  describe "a running service directory" do
    let(:socket) { UDPSocket.new }

    def thread
      instance.instance_variable_get(:@thread)
    end

    before do
      described_class.start do |config|
        config.address = "127.0.0.1"
        config.port = 33333
      end

      socket.connect described_class.address, described_class.port
    end

    context "receiving a heartbeat" do
      let(:server) { ::Protobuf::Rpc::DynamicDiscovery::Server.new(:uuid => 'heartbeat') }
      let(:beacon) { ::Protobuf::Rpc::DynamicDiscovery::Beacon.new(
        :server => server,
        :beacon_type => ::Protobuf::Rpc::DynamicDiscovery::BeaconType::HEARTBEAT
      )}
      let(:payload) { beacon.serialize_to_string }

      it "adds a listing" do
        instance.should_receive(:add_listing_for).with(server)
        instance.should_receive(:remove_expired_listings)
        socket.send(payload, 0)
        sleep 0.01
      end
    end

    context "receiving a flatline" do
      let(:server) { ::Protobuf::Rpc::DynamicDiscovery::Server.new(:uuid => 'flatline') }
      let(:beacon) { ::Protobuf::Rpc::DynamicDiscovery::Beacon.new(
        :server => server,
        :beacon_type => ::Protobuf::Rpc::DynamicDiscovery::BeaconType::FLATLINE
      )}
      let(:payload) { beacon.serialize_to_string }

      it "removes a listing" do
        instance.should_receive(:remove_listing_for).with(server)
        instance.should_receive(:remove_expired_listings)
        socket.send(payload, 0)
        sleep 0.01
      end
    end
  end
end
