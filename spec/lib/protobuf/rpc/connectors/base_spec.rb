require 'spec_helper'

describe Protobuf::Rpc::Connectors::Base do
  
  let(:opts) do
    { async: false, timeout: 60 }
  end
  
  subject { Protobuf::Rpc::Connectors::Base.new(opts) }
  
  describe "#send_request" do 
    it "raising an error when 'send_request' is not overridden" do 
      expect{ subject.send_request }.to raise_error(RuntimeError, /inherit a Connector/)
    end

    it "does not raise error when 'send_request' is overridden" do 
      new_sub = Class.new(subject.class){ def send_request; end }.new(opts)
      expect{ new_sub.send_request }.to_not raise_error
    end
  end

  describe '.new' do
    it 'assigns passed options' do
      subject.options.should eq(Protobuf::Rpc::Connectors::DEFAULT_OPTIONS.merge(opts))
    end
  end
  
  it 'emits the :success event' do
    subject.class.emits?(:success).should be_true
  end

  it 'emits the :failure event' do
    subject.class.emits?(:failure).should be_true
  end
  
  describe '#async?' do
    context 'when provided options[:async] is false' do
      let(:opts) do
        { async: false, timeout: 60 }
      end
  
      subject { Protobuf::Rpc::Connectors::Base.new(opts) }
    
      it 'returns false' do
        subject.async?.should be_false
      end
    end
    
    context 'when provided options[:async] is true' do
      let(:opts) do
        { async: true, timeout: 60 }
      end
  
      subject { Protobuf::Rpc::Connectors::Base.new(opts) }
    
      it 'returns true' do
        subject.async?.should be_true
      end
    end
    
    context 'when options doesn\'t denote async' do
      let(:opts) do
        { timeout: 60 }
      end
  
      subject { Protobuf::Rpc::Connectors::Base.new(opts) }
    
      it 'returns false' do
        subject.async?.should be_false
      end
    end
  end
  
end
