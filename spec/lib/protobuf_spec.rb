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
      expect(described_class.connector_type).to eq :socket
    end

    it 'accepts socket or zmq' do
      [:socket, :zmq].each do |type|
        described_class.connector_type = type
        expect(described_class.connector_type).to eq type
      end
    end

    it 'does not accept other types' do
      [:hello, :world, :evented].each do |type|
        expect {
          described_class.connector_type = type
        }.to raise_error(ArgumentError)
      end
    end
  end

  describe '.gc_pause_server_request?' do
    before { described_class.instance_variable_set(:@_gc_pause_server_request, nil) }

    it 'defaults to a false value' do
      expect(described_class.gc_pause_server_request?).to be_falsey
    end

    it 'is settable' do
      described_class.gc_pause_server_request = true
      expect(described_class.gc_pause_server_request?).to be_truthy
    end
  end

  describe '.print_deprecation_warnings?' do
    before { described_class.instance_variable_set(:@_print_deprecation_warnings, nil) }

    it 'defaults to a true value' do
      expect(described_class.print_deprecation_warnings?).to be_truthy
    end

    it 'is settable' do
      described_class.print_deprecation_warnings = false
      expect(described_class.print_deprecation_warnings?).to be_falsey
    end

    context 'when ENV["PB_IGNORE_DEPRECATIONS"] present' do
      it 'defaults to a false value' do
        ENV['PB_IGNORE_DEPRECATIONS'] = '1'
        expect(described_class.print_deprecation_warnings?).to be_falsey
      end
    end
  end

  describe '.ignore_unknown_fields?' do
    before do
      if described_class.instance_variable_defined?(:@_ignore_unknown_fields)
        described_class.send(:remove_instance_variable, :@_ignore_unknown_fields)
      end
    end

    it 'defaults to a true value' do
      expect(described_class.ignore_unknown_fields?).to be true
    end

    it 'is settable' do
      expect {
        described_class.ignore_unknown_fields = false
      }.to change {
        described_class.ignore_unknown_fields?
      }.from(true).to(false)
    end
  end

end
