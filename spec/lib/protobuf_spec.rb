require 'spec_helper'
require 'protobuf'

RSpec.describe ::Protobuf do
  describe '.print_deprecation_warnings?' do
    before { described_class.instance_variable_set(:@print_deprecation_warnings, nil) }

    it 'defaults to a true value' do
      expect(described_class.print_deprecation_warnings?).to be true
    end

    it 'is settable' do
      described_class.print_deprecation_warnings = false
      expect(described_class.print_deprecation_warnings?).to be false
    end

    context 'when ENV["PB_IGNORE_DEPRECATIONS"] present' do
      it 'defaults to a false value' do
        ENV['PB_IGNORE_DEPRECATIONS'] = '1'
        expect(described_class.print_deprecation_warnings?).to be false
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
      expect do
        described_class.ignore_unknown_fields = false
      end.to change {
        described_class.ignore_unknown_fields?
      }.from(true).to(false)
    end
  end

end
