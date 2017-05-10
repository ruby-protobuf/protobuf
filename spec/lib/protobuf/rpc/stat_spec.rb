require 'spec_helper'
require 'timecop'
require 'active_support/core_ext/numeric/time'

RSpec.describe ::Protobuf::Rpc::Stat do

  before(:all) do
    BarService = ::Struct.new(:method_name) unless defined?(BarService)
  end

  describe '#server=' do
    it 'understands Array' do
      stat = ::Protobuf::Rpc::Stat.new
      stat.server = [3333, "127.0.0.1"]
      expect(stat.server).to eq("127.0.0.1:3333")
    end

    it 'understands String' do
      stat = ::Protobuf::Rpc::Stat.new
      stat.server = "thatserverthough"
      expect(stat.server).to eq("thatserverthough")
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
          expect(stats.to_s).to eq "[SRV] - myserver1 - #{stats.trace_id} - BarService#find_bars - 43B/1302B - 1.62s - #{::Time.now.iso8601}"
        end
      end
    end

    context 'when request is still running' do
      it 'omits response size, duration, and timestamp' do
        stats = ::Protobuf::Rpc::Stat.new(:SERVER)
        stats.client = 'myserver1'
        stats.dispatcher = double('dispatcher', :service => BarService.new(:find_bars))
        stats.request_size = 43
        expect(stats.to_s).to eq "[SRV] - myserver1 - #{stats.trace_id} - BarService#find_bars - 43B/-"
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
          expect(stats.to_s).to eq "[CLT] - myserver1.myhost.com:30000 - #{stats.trace_id} - Foo::BarService#find_bars - 37B/12345B - 0.832s - #{::Time.now.iso8601}"
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
        expect(stats.to_s).to eq "[CLT] - myserver1.myhost.com:30000 - #{stats.trace_id} - Foo::BarService#find_bars - 37B/-"
      end
    end
  end

end
