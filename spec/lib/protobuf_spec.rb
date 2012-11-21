require 'spec_helper'
require 'protobuf'

describe ::Protobuf do

  describe '.client_host' do
    after { ::Protobuf.instance_variable_set(:@_client_host, nil) }

    subject { ::Protobuf.client_host }

    context 'when client_host is not pre-configured' do
      it { should eq `hostname`.chomp }
    end

    context 'when client_host is pre-configured' do
      let(:hostname) { 'override.myhost.com' }
      before { ::Protobuf.client_host = hostname }
      it { should eq hostname }
    end
  end

  describe '.connector_type' do
    before { described_class.instance_variable_set(:@_connector_type, nil) }

    it 'defaults to socket' do
      described_class.connector_type.should eq :socket
    end

    it 'accepts socket, evented, or zmq' do
      [:socket, :evented, :zmq].each do |type|
        described_class.connector_type = type
        described_class.connector_type.should eq type
      end
    end

    it 'does not accept other types' do
      [:hello, :world].each do |type|
        expect {
          described_class.connector_type = type
        }.to raise_error(ArgumentError)
      end
    end
  end

  describe '.gc_pause_server_request?' do
    before { described_class.instance_variable_set(:@_gc_pause_server_request, nil) }

    it 'defaults to a false value' do
      described_class.gc_pause_server_request?.should be_false
    end

    it 'is settable' do
      described_class.gc_pause_server_request = true
      described_class.gc_pause_server_request?.should be_true
    end
  end

  describe '.print_deprecation_warnings?' do
    before { described_class.instance_variable_set(:@_print_deprecation_warnings, nil) }

    it 'defaults to a true value' do
      described_class.print_deprecation_warnings?.should be_true
    end

    it 'is settable' do
      described_class.print_deprecation_warnings = false
      described_class.print_deprecation_warnings?.should be_false
    end

    context 'when ENV["PB_IGNORE_DEPRECATIONS"] present' do
      it 'defaults to a false value' do
        ENV['PB_IGNORE_DEPRECATIONS'] = '1'
        described_class.print_deprecation_warnings?.should be_false
      end
    end
  end

end
