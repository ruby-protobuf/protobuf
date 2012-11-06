require 'spec_helper'

describe Protobuf::Rpc::Connectors::Base do

  let(:options) do
    { :timeout => 60 }
  end

  subject { Protobuf::Rpc::Connectors::Base.new(options) }

  describe "#send_request" do
    it "raising an error when 'send_request' is not overridden" do
      expect{ subject.send_request }.to raise_error(RuntimeError, /inherit a Connector/)
    end

    it "does not raise error when 'send_request' is overridden" do
      new_sub = Class.new(subject.class){ def send_request; end }.new(options)
      expect{ new_sub.send_request }.to_not raise_error
    end
  end

  describe '.new' do
    it 'assigns passed options and initializes success/failure callbacks' do
      subject.options.should eq(Protobuf::Rpc::Connectors::DEFAULT_OPTIONS.merge(options))
      subject.success_cb.should be_nil
      subject.failure_cb.should be_nil
    end
  end

  describe '#success_cb' do
    it 'allows setting the success callback and calling it' do
      subject.success_cb.should be_nil
      cb = proc {|res| raise res }
      subject.success_cb = cb
      subject.success_cb.should eq(cb)
      expect { subject.success_cb.call('an error from cb') }.to raise_error 'an error from cb'
    end
  end

  describe '#failure_cb' do
    it 'allows setting the failure callback and calling it' do
      subject.failure_cb.should be_nil
      cb = proc {|res| raise res }
      subject.failure_cb = cb
      subject.failure_cb.should eq(cb)
      expect { subject.failure_cb.call('an error from cb') }.to raise_error 'an error from cb'
    end
  end

end
