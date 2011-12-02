require 'spec_helper'

describe Protobuf::Rpc::Connectors::Base do
  
  let(:opts) do
    { async: false, timeout: 60 }
  end
  
  subject { Protobuf::Rpc::Connectors::Base.new(opts) }
  
  describe '.new' do
    it 'assigns passed options and initializes success/failure callbacks' do
      subject.options.should eq opts
      subject.success_cb.should be_nil
      subject.failure_cb.should be_nil
    end
  end
  
  describe '#success_cb' do
    it 'allows setting the success callback and calling it' do
      subject.success_cb.should be_nil
      cb = proc {|res| raise res }
      subject.success_cb = cb
      subject.success_cb.should eq cb
      expect { subject.success_cb.call('an error from cb') }.to raise_error 'an error from cb'
    end
  end
  
  describe '#failure_cb' do
    it 'allows setting the failure callback and calling it' do
      subject.failure_cb.should be_nil
      cb = proc {|res| raise res }
      subject.failure_cb = cb
      subject.failure_cb.should eq cb
      expect { subject.failure_cb.call('an error from cb') }.to raise_error 'an error from cb'
    end
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
