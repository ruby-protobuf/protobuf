require 'spec_helper'

class ServiceWithHooks
  include Protobuf::Rpc::ServiceCallbacks

  # Initialize the hash keys as instance vars
  def initialize(ivar_hash)
    ivar_hash.each_pair do |key, value|
      self.class.class_eval do
        attr_accessor key
      end
      __send__("#{key}=", value)
    end
  end
end

describe Protobuf::Rpc::ServiceCallbacks do
  subject { ServiceWithHooks.new(params) }

  describe '#before_filter' do
    before(:all) do
      class ServiceWithHooks
        def verify_before
          @before_filter_called = true
        end
      end
    end

    after(:all) do
      class ServiceWithHooks
        undef :verify_before
      end
    end

    let(:params) { { :before_filter_called => false } }
    before { ServiceWithHooks.before_filter(:verify_before) }

    context 'when defining a before filter' do
      before { subject.run_before_filters! }

      its('class.before_filters') { should include(:verify_before) }
      its(:before_filter_called) { should be_true }
    end

    context 'when multiple methods are defined' do
      pending
    end

    context 'when same method is added' do
      before { ServiceWithHooks.before_filter(:verify_before) }
      before { ServiceWithHooks.before_filter(:verify_before) }
      before { ServiceWithHooks.before_filter(:verify_before) }

      it 'calls the method callback a single time' do
        subject.should_receive(:verify_before).once
        subject.run_before_filters!
      end
    end
  end

  describe '#after_filter' do
    before(:all) do
      class ServiceWithHooks
        def verify_after
          @after_filter_called = true
        end
      end
    end

    after(:all) do
      class ServiceWithHooks
        undef :verify_after
      end
    end

    let(:params) { { :after_filter_called => false } }

    before { ServiceWithHooks.after_filter(:verify_after) }
    before { subject.run_after_filters! }

    its('class.after_filters') { should include(:verify_after) }
    its(:after_filter_called) { should be_true }
  end
end
