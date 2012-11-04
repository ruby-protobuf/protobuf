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

  def endpoint
    @called << :endpoint
  end

  def self.clear_filters!
    @defined_filters = nil
    @filters = nil
  end
end

describe Protobuf::Rpc::ServiceCallbacks do
  subject { ServiceWithHooks.new(params) }
  after(:each) { ServiceWithHooks.clear_filters! }

  describe '#before_filter' do
    let(:params) do
      { :called => [],
        :before_filter_calls => 0 }
    end

    before(:all) do
      class ServiceWithHooks
        def verify_before
          @called << :verify_before
          @before_filter_calls += 1
        end

        def foo
          @called << :foo
        end
      end
    end

    before do
      ServiceWithHooks.before_filter(:verify_before)
      ServiceWithHooks.before_filter(:verify_before)
      ServiceWithHooks.before_filter(:foo)
    end

    it 'calls filters in the order they were defined' do
      subject.__send__(:run_filters) { subject.endpoint }
      subject.called.should eq [ :verify_before, :foo, :endpoint ]
      subject.before_filter_calls.should eq 1
    end
  end

  describe '#after_filter' do
    let(:params) do
      { :called => [],
        :after_filter_calls => 0 }
    end

    before(:all) do
      class ServiceWithHooks
        def verify_after
          @called << :verify_after
          @after_filter_calls += 1
        end

        def foo
          @called << :foo
        end
      end
    end

    before do
      ServiceWithHooks.after_filter(:verify_after)
      ServiceWithHooks.after_filter(:verify_after)
      ServiceWithHooks.after_filter(:foo)
    end

    it 'calls filters in the order they were defined' do
      subject.__send__(:run_filters) { subject.endpoint }
      subject.called.should eq [ :endpoint, :verify_after, :foo ]
      subject.after_filter_calls.should eq 1
    end
  end

  describe '#around_filter' do
    let(:params) do
      { :called => [] }
    end

    before(:all) do
      class ServiceWithHooks
        def outer_around
          @called << :outer_around_top
          yield
          @called << :outer_around_bottom
        end

        def inner_around
          @called << :inner_around_top
          yield
          @called << :inner_around_bottom
        end
      end
    end

    before do
      ServiceWithHooks.around_filter(:outer_around)
      ServiceWithHooks.around_filter(:inner_around)
      ServiceWithHooks.around_filter(:outer_around)
      ServiceWithHooks.around_filter(:inner_around)
    end

    it 'calls filters in the order they were defined' do
      subject.__send__(:run_filters) { subject.endpoint }
      subject.called.should eq([ :outer_around_top,
                                 :inner_around_top,
                                 :endpoint,
                                 :inner_around_bottom,
                                 :outer_around_bottom ])
    end

    context 'when around_filter does not yield' do
      before do
        class ServiceWithHooks
          def inner_around
            @called << :inner_around
          end
        end
      end

      before do
        ServiceWithHooks.around_filter(:outer_around)
        ServiceWithHooks.around_filter(:inner_around)
      end

      it 'calls filters in the order they were defined' do
        subject.should_not_receive(:endpoint)
        subject.__send__(:run_filters) { subject.endpoint }
        subject.called.should eq([ :outer_around_top,
                                   :inner_around,
                                   :outer_around_bottom ])
      end

    end
  end

end
