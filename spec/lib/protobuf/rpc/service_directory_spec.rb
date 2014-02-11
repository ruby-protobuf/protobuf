require 'spec_helper'

require 'protobuf/rpc/service_directory'

describe ::Protobuf::Rpc::ServiceDirectory do
  subject { described_class.instance }

  let(:echo_server) {
    ::Protobuf::Rpc::DynamicDiscovery::Server.new(
      :uuid => 'echo',
      :address => '127.0.0.1',
      :port => '1111',
      :ttl => 10,
      :services => %w[EchoService]
    )
  }

  let(:hello_server) {
    ::Protobuf::Rpc::DynamicDiscovery::Server.new(
      :uuid => "hello",
      :address => '127.0.0.1',
      :port => "1112",
      :ttl => 10,
      :services => %w[HelloService]
    )
  }

  let(:hello_server_with_short_ttl) {
    ::Protobuf::Rpc::DynamicDiscovery::Server.new(
      :uuid => "hello_server_with_short_ttl",
      :address => '127.0.0.1',
      :port => '1113',
      :ttl => 1,
      :services => %w[HelloService]
    )
  }

  let(:combo_server) {
    ::Protobuf::Rpc::DynamicDiscovery::Server.new(
      :uuid => "combo",
      :address => '127.0.0.1',
      :port => '1114',
      :ttl => 10,
      :services => %w[HelloService EchoService]
    )
  }

  before(:all) do
    @address = "127.0.0.1"
    @port = 33333
    @socket = UDPSocket.new
    EchoService = Class.new

    described_class.address = @address
    described_class.port = @port
  end

  def expect_event_trigger(event)
    ::ActiveSupport::Notifications
      .should_receive(:instrument)
      .with(event, hash_including(:listing => an_instance_of(::Protobuf::Rpc::ServiceDirectory::Listing)))
      .once
  end

  def send_beacon(type, server)
    type = type.to_s.upcase
    beacon = ::Protobuf::Rpc::DynamicDiscovery::Beacon.new(
      :server => server,
      :beacon_type => ::Protobuf::Rpc::DynamicDiscovery::BeaconType.fetch(type)
    )

    @socket.send(beacon.encode, 0, @address, @port)
    sleep 0.01 # give the service directory time to process the beacon
  end

  it "should be a singleton" do
    subject.should be_a_kind_of(Singleton)
  end

  it "should be configured to listen to address 127.0.0.1" do
    described_class.address.should eq '127.0.0.1'
  end

  it "should be configured to listen to port 33333" do
    described_class.port.should eq 33333
  end

  it "should defer .start to the instance#start" do
    described_class.instance.should_receive(:start)
    described_class.start
  end

  it "should yeild itself to blocks passed to .start" do
    described_class.instance.stub(:start)
    expect { |b| described_class.start(&b) }.to yield_with_args(described_class)
  end

  it "should defer .stop to the instance#stop" do
    described_class.instance.should_receive(:stop)
    described_class.stop
  end

  context "stopped" do
    before { subject.stop }

    describe "#lookup" do
      it "should return nil" do
        send_beacon(:heartbeat, echo_server)
        subject.lookup("EchoService").should be_nil
      end
    end

    describe "#restart" do
      it "should start the service" do
        subject.restart
        subject.should be_running
      end
    end

    describe "#running" do
      it "should be false" do
        subject.should_not be_running
      end
    end

    describe "#stop" do
      it "has no effect" do
        subject.stop
      end
    end
  end

  context "started" do
    before { subject.start }
    after { subject.stop }

    it { should be_running }

    it "should trigger added events" do
      expect_event_trigger("directory.listing.added")
      send_beacon(:heartbeat, echo_server)
    end

    it "should trigger updated events" do
      send_beacon(:heartbeat, echo_server)
      expect_event_trigger("directory.listing.updated")
      send_beacon(:heartbeat, echo_server)
    end

    it "should trigger removed events" do
      send_beacon(:heartbeat, echo_server)
      expect_event_trigger("directory.listing.removed")
      send_beacon(:flatline, echo_server)
    end

    describe "#all_listings_for" do
      context "when listings are present" do
        it "returns all listings for a given service" do
          send_beacon(:heartbeat, hello_server)
          send_beacon(:heartbeat, combo_server)

          subject.all_listings_for("HelloService").size.should eq(2)
        end
      end

      context "when no listings are present" do
        it "returns and empty array" do
          subject.all_listings_for("HelloService").size.should eq(0)
        end
      end
    end

    describe "#each_listing" do
      it "should yield to a block for each listing" do
        send_beacon(:heartbeat, hello_server)
        send_beacon(:heartbeat, echo_server)
        send_beacon(:heartbeat, combo_server)

        expect { |block|
          subject.each_listing(&block)
        }.to yield_control.exactly(3).times
      end
    end

    describe "#lookup" do
      it "should provide listings by service" do
        send_beacon(:heartbeat, hello_server)
        subject.lookup("HelloService").to_hash.should eq hello_server.to_hash
      end

      it "should return random listings" do
        send_beacon(:heartbeat, hello_server)
        send_beacon(:heartbeat, combo_server)

        uuids = 100.times.map { subject.lookup("HelloService").uuid }
        uuids.count("hello").should be_within(25).of(50)
        uuids.count("combo").should be_within(25).of(50)
      end

      it "should not return expired listings" do
        send_beacon(:heartbeat, hello_server_with_short_ttl)
        sleep 1
        subject.lookup("HelloService").should be_nil
      end

      it "should not return flatlined servers" do
        send_beacon(:heartbeat, echo_server)
        send_beacon(:heartbeat, combo_server)
        send_beacon(:flatline, echo_server)

        uuids = 100.times.map { subject.lookup("EchoService").uuid }
        uuids.count("combo").should eq 100
      end

      it "should return up-to-date listings" do
        send_beacon(:heartbeat, echo_server)
        echo_server.port = "7777"
        send_beacon(:heartbeat, echo_server)

        subject.lookup("EchoService").port.should eq "7777"
      end

      context 'when given service identifier is a class name' do
        it 'returns the listing corresponding to the class name' do
          send_beacon(:heartbeat, echo_server)
          subject.lookup(EchoService).uuid.should eq echo_server.uuid
        end
      end
    end

    describe "#restart" do
      it "should clear all listings" do
        send_beacon(:heartbeat, echo_server)
        send_beacon(:heartbeat, combo_server)
        subject.restart
        subject.lookup("EchoService").should be_nil
      end
    end

    describe "#running" do
      it "should be true" do
        subject.should be_running
      end
    end

    describe "#stop" do
      it "should clear all listings" do
        send_beacon(:heartbeat, echo_server)
        send_beacon(:heartbeat, combo_server)
        subject.stop
        subject.lookup("EchoService").should be_nil
      end

      it "should stop the server" do
        subject.stop
        subject.should_not be_running
      end
    end
  end

  if ENV.key?("BENCH")
    context "performance" do
      let(:servers) {
        100.times.collect do |x|
          ::Protobuf::Rpc::DynamicDiscovery::Server.new(
            :uuid => "performance_server#{x + 1}",
            :address => '127.0.0.1',
            :port => (5555 + x).to_s,
            :ttl => rand(1..5),
            :services => 10.times.collect { |y| "PerformanceService#{y}" }
          )
        end
      }

      before do
        require 'benchmark'
        subject.start
        servers.each { |server| send_beacon(:heartbeat, server) }
      end

      after do
        subject.stop
      end

      it "should perform lookups in constant time" do
        print "\n\n"
        Benchmark.bm(17) do |x|
          x.report("  1_000 lookups:") {   1_000.times { subject.lookup("PerformanceService#{rand(0..9)}") } }
          x.report(" 10_000 lookups:") {  10_000.times { subject.lookup("PerformanceService#{rand(0..9)}") } }
          x.report("100_000 lookups:") { 100_000.times { subject.lookup("PerformanceService#{rand(0..9)}") } }
        end
      end
    end
  end
end
