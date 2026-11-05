require 'spec_helper'
require 'protobuf/railtie'

RSpec.describe Protobuf::Railtie do
  let(:config) do
    double('config', :protobuf => ::ActiveSupport::OrderedOptions.new)
  end

  let(:app) { double('app', :config => config, :root => Pathname.new('/srv/app')) }

  describe '.services_path' do
    it 'is nil when not configured (opt-in)' do
      expect(described_class.services_path(app)).to be_nil
    end

    it 'is nil when configured as an empty string' do
      config.protobuf.services_path = ''
      expect(described_class.services_path(app)).to be_nil
    end

    it 'honors an absolute path' do
      config.protobuf.services_path = '/custom/services'
      expect(described_class.services_path(app)).to eq('/custom/services')
    end

    it 'resolves a relative path against the app root' do
      config.protobuf.services_path = 'app/services/rpc'
      expect(described_class.services_path(app)).to eq('/srv/app/app/services/rpc')
    end

    it 'accepts a Pathname' do
      config.protobuf.services_path = Pathname.new('/custom/services')
      expect(described_class.services_path(app)).to eq('/custom/services')
    end
  end

  describe '.load_services' do
    let(:loader) { double('autoloader') }

    before do
      allow(described_class).to receive(:services_path).and_return('/svc')
      allow(::File).to receive(:directory?).and_call_original
      allow(::File).to receive(:directory?).with('/svc').and_return(true)
      stub_const('Rails', double('Rails', :autoloaders => double(:main => loader)))
    end

    it 'does nothing when no path is configured' do
      allow(described_class).to receive(:services_path).and_return(nil)
      expect(::Protobuf::ServiceLoader).not_to receive(:load_services)
      described_class.load_services(app)
    end

    it 'does nothing when the directory is missing' do
      allow(::File).to receive(:directory?).with('/svc').and_return(false)
      expect(::Protobuf::ServiceLoader).not_to receive(:load_services)
      described_class.load_services(app)
    end

    it 'eager-loads through the autoloader when eager_load_dir is available' do
      allow(loader).to receive(:respond_to?).with(:eager_load_dir).and_return(true)
      expect(loader).to receive(:eager_load_dir).with('/svc')
      expect(::Protobuf::ServiceLoader).not_to receive(:load_services)
      described_class.load_services(app)
    end

    it 'falls back to ServiceLoader when eager_load_dir is unavailable' do
      allow(loader).to receive(:respond_to?).with(:eager_load_dir).and_return(false)
      expect(::Protobuf::ServiceLoader).to receive(:load_services).with('/svc')
      described_class.load_services(app)
    end

    it 'falls back to ServiceLoader with the classic autoloader (no main loader)' do
      stub_const('Rails', double('Rails', :autoloaders => double(:main => nil)))
      expect(::Protobuf::ServiceLoader).to receive(:load_services).with('/svc')
      described_class.load_services(app)
    end

    it 'falls back to ServiceLoader when the path is not autoloader-managed' do
      stub_const('Zeitwerk::Error', Class.new(StandardError))
      allow(loader).to receive(:respond_to?).with(:eager_load_dir).and_return(true)
      allow(loader).to receive(:eager_load_dir).and_raise(::Zeitwerk::Error)
      expect(::Protobuf::ServiceLoader).to receive(:load_services).with('/svc')
      described_class.load_services(app)
    end
  end
end
