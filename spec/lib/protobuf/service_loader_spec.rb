require 'spec_helper'
require 'tmpdir'
require 'fileutils'
require 'protobuf/service_loader'

RSpec.describe Protobuf::ServiceLoader do
  describe '.load_services' do
    around do |example|
      Dir.mktmpdir do |dir|
        @services_dir = dir
        example.run
      end
    end

    let(:tracker) { [] }

    before do
      # Expose the tracker globally so the required files can reach it.
      $service_loader_spec_tracker = tracker # rubocop:disable Style/GlobalVars
    end

    after do
      $service_loader_spec_tracker = nil # rubocop:disable Style/GlobalVars
    end

    def write_service(relative_path, marker)
      full = File.join(@services_dir, relative_path)
      FileUtils.mkdir_p(File.dirname(full))
      File.write(full, "$service_loader_spec_tracker << #{marker.inspect}\n")
      full
    end

    it 'returns an empty array when path is nil' do
      expect(described_class.load_services(nil)).to eq([])
    end

    it 'returns an empty array when directory does not exist' do
      expect(described_class.load_services('/no/such/dir/here')).to eq([])
    end

    it 'loads every .rb file under the path' do
      write_service('foo_service.rb', 'foo')
      write_service('nested/bar_service.rb', 'bar')
      write_service('helper.rb', 'helper')
      write_service('notes.txt', 'nope')

      described_class.load_services(@services_dir)

      expect(tracker).to contain_exactly('foo', 'bar', 'helper')
    end

    it 'loads files in deterministic (sorted) order' do
      write_service('b_service.rb', 'b')
      write_service('a_service.rb', 'a')
      write_service('c_service.rb', 'c')

      described_class.load_services(@services_dir)

      expect(tracker).to eq(%w[a b c])
    end

    it 'does not execute a file a second time on later calls' do
      write_service('once_service.rb', 'one')

      described_class.load_services(@services_dir)
      described_class.load_services(@services_dir)

      expect(tracker).to eq(%w[one])
    end

    it 'accepts a Pathname for the path' do
      write_service('path_service.rb', 'path')

      described_class.load_services(Pathname.new(@services_dir))

      expect(tracker).to eq(['path'])
    end

    it 'honors a custom glob' do
      write_service('foo_handler.rb', 'handler')
      write_service('bar_service.rb', 'service')

      described_class.load_services(@services_dir, '**/*_handler.rb')

      expect(tracker).to eq(['handler'])
    end
  end
end
