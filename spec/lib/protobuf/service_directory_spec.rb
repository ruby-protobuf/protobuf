require 'spec_helper'

require 'protobuf/rpc/service_directory'

describe ::Protobuf::Rpc::ServiceDirectory do
  let(:instance) { ::Protobuf::Rpc::ServiceDirectory.instance }
  let(:server) { double('server', :uuid => '123',
                                  :services => ['Known::Service'],
                                  :address => "0.0.0.0",
                                  :port => 9999,
                                  :ttl => 15) }

  before(:all) do
    ::Protobuf::Rpc::ServiceDirectory.timeout = 0.5
  end

  after do
    instance.stop
  end

  it "is a singleton" do
    instance.should be_a_kind_of(Singleton)
  end

  describe "#find" do
    it "times out when nothing is found" do
      expect {
        instance.find("Unknown::Service")
      }.to raise_error(::Protobuf::Rpc::ServiceDirectory::ServiceNotFound)
    end

    it "returns a listing for the given service" do
      instance.add_listing_for(server)
      instance.find("Known::Service").should eq [server.address, server.port]
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
      }.to change(instance, :listing_count).from(3).to(1)
    end
  end
end
