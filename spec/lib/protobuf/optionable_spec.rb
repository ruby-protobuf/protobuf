require 'spec_helper'
require 'protobuf/optionable'

RSpec.describe 'Optionable' do

  describe '.set_option' do
    before(:all) do
      OptionableSetOptionTest = ::Class.new do
        include ::Protobuf::Optionable
      end
    end

    it 'stores the given option and value' do
      expect(OptionableSetOptionTest).to respond_to(:set_option)
      expect(OptionableSetOptionTest.method(:set_option).arity).to eq(-2)
      expect do
        OptionableSetOptionTest.set_option(:foo, :bar)
      end.to_not raise_error
    end

    it 'defaults the value to true' do
      OptionableSetOptionTest.set_option(:baz_enabled)
      expect(OptionableSetOptionTest.get_option(:baz_enabled)).to be true
    end
  end

  describe '.get_option' do
    before(:all) do
      OptionableGetOptionTest = ::Class.new do
        include ::Protobuf::Optionable
        set_option :foo, :bar
      end
    end

    it 'retrieves the option for the given name, if any' do
      expect(OptionableGetOptionTest.get_option(:foo)).to eq(:bar)
      expect(OptionableGetOptionTest.get_option(:baz)).to be_nil
    end

    it 'retrieves the option in the context of an instance' do
      expect(OptionableGetOptionTest.new.get_option(:foo)).to eq(:bar)
      expect(OptionableGetOptionTest.new.get_option(:baz)).to be_nil
    end
  end

end
