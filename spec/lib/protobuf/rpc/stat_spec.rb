require 'spec_helper'
require 'timecop'
require 'active_support/core_ext/numeric/time'

describe ::Protobuf::Rpc::Stat do

  before(:all) do
    unless defined?(BarService)
      class BarService < ::Struct.new(:method_name); end
    end
  end

  describe 'server mode' do
    it 'describes a server response to a client' do
      ::Timecop.freeze(10.minutes.ago) do
        stats = ::Protobuf::Rpc::Stat.new(:SERVER)
        stats.client = 'myserver1'
        stats.dispatcher = double('dispatcher', :service => BarService.new(:find_bars))
        stats.request_size = 43
        stats.response_size = 1302

        ::Timecop.freeze(1.62.seconds.from_now) do
          stats.stop
          stats.to_s.should eq "[SRV] - myserver1 - #{stats.trace_id} - BarService#find_bars - 43B/1302B - 1.62s - #{::Time.now.iso8601}"
        end
      end
    end

    context 'when request is still running' do
      it 'omits response size, duration, and timestamp' do
        stats = ::Protobuf::Rpc::Stat.new(:SERVER)
        stats.client = 'myserver1'
        stats.dispatcher = double('dispatcher', :service => BarService.new(:find_bars))
        stats.request_size = 43
        stats.to_s.should eq "[SRV] - myserver1 - #{stats.trace_id} - BarService#find_bars - 43B/-"
      end
    end
  end

  describe 'client mode' do
    it 'describes a client request to a server' do
      ::Timecop.freeze(10.minutes.ago) do
        stats = ::Protobuf::Rpc::Stat.new(:CLIENT)
        stats.server = ['30000', 'myserver1.myhost.com']
        stats.service = 'Foo::BarService'
        stats.method_name = 'find_bars'
        stats.request_size = 37
        stats.response_size = 12345

        ::Timecop.freeze(0.832.seconds.from_now) do
          stats.stop
          stats.to_s.should eq "[CLT] - myserver1.myhost.com:30000 - #{stats.trace_id} - Foo::BarService#find_bars - 37B/12345B - 0.832s - #{::Time.now.iso8601}"
        end

      end
    end

    context 'when request is still running' do
      it 'omits response size, duration, and timestamp' do
        stats = ::Protobuf::Rpc::Stat.new(:CLIENT)
        stats.server = ['30000', 'myserver1.myhost.com']
        stats.service = 'Foo::BarService'
        stats.method_name = 'find_bars'
        stats.request_size = 37
        stats.to_s.should eq "[CLT] - myserver1.myhost.com:30000 - #{stats.trace_id} - Foo::BarService#find_bars - 37B/-"
      end
    end
  end

  describe "statsd_base_path" do
    let(:stats) { described_class.new(:CLIENT) }
    subject(:statsd_base_path) { stats.statsd_base_path }

    before :each do
      stats.service = 'Foo::BarService'
      stats.method_name = 'find_bars'
    end

    it "should use correct base path" do
      expect(statsd_base_path).to eq "rpc-client.foo.barservice.find_bars"
    end
  end

  describe "#stop" do
    let(:stats) { described_class.new(:CLIENT) }
    let(:start_time) { Time.now - 3000 }
    let(:end_time) { Time.now }
    let(:service) { 'Foo::BarService' }
    let(:method_name) { 'find_bars' }
    let(:stats_path) { 'rpc-client.foo.barservice.find_bars' }

    before :each do
      stats.service = service
      stats.method_name = method_name
      stats.start_time = start_time
      stats.end_time = end_time
      stats.stub(:statsd_base_path).and_return(stats_path)
    end

    subject(:stop) { stats.stop }

    context "when statsd_client hasn't been set" do
      it "should not raise" do
        expect{ stop }.not_to raise_error
      end
    end

    context "when statsd_client has been set" do
      let(:statsd_client) { double("Statsd::Client") }

      before :each do
        Protobuf::Statsd.client = statsd_client
      end

      after :each do
        Protobuf::Statsd.client = nil
      end

      context "on success" do
        before :each do
          stats.success
        end

        it "should increment the proper stats" do
          expect(statsd_client).to receive(:increment).with("#{stats_path}.success")
          expect(statsd_client).to receive(:timing).with("#{stats_path}.time",
                                                         end_time - start_time)

          stop
        end
      end

      context "on failure" do
        let(:code) { 8 }

        before :each do
          stats.failure(code)
        end

        it "should increment the proper stats" do
          expect(statsd_client).to receive(:increment).with("#{stats_path}.failure.total")
          expect(statsd_client).to receive(:increment).with("#{stats_path}.failure.#{code}")
          expect(statsd_client).to receive(:timing).with("#{stats_path}.time",
                                                         end_time - start_time)

          stop
        end
      end
    end
  end
end
