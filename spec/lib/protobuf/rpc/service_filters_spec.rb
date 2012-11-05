require 'spec_helper'

class FilterTest
  include Protobuf::Rpc::ServiceFilters

  attr_accessor :called

  # Initialize the hash keys as instance vars
  def initialize(ivar_hash)
    @called = []
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

describe Protobuf::Rpc::ServiceFilters do
  subject { FilterTest.new(params) }
  after(:each) { FilterTest.clear_filters! }

  describe '#before_filter' do
    let(:params) { { :before_filter_calls => 0 } }

    before(:all) do
      class FilterTest
        private
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
      FilterTest.before_filter(:verify_before)
      FilterTest.before_filter(:verify_before)
      FilterTest.before_filter(:foo)
    end

    it 'calls filters in the order they were defined' do
      subject.__send__(:run_filters, :endpoint)
      subject.called.should eq [ :verify_before, :foo, :endpoint ]
      subject.before_filter_calls.should eq 1
    end

    context 'when filter is configured with "only"' do
      before(:all) do
        class FilterTest
          private
          def endpoint_with_verify
            @called << :endpoint_with_verify
          end
        end
      end

      before do
        FilterTest.clear_filters!
        FilterTest.before_filter(:verify_before, :only => :endpoint_with_verify)
      end

      context 'when invoking a method defined in "only" option' do
        it 'invokes the filter' do
          subject.__send__(:run_filters, :endpoint_with_verify)
          subject.called.should eq [ :verify_before, :endpoint_with_verify ]
        end
      end

      context 'when invoking a method not defined by "only" option' do
        it 'does not invoke the filter' do
          subject.__send__(:run_filters, :endpoint)
          subject.called.should eq [ :endpoint ]
        end
      end
    end

    context 'when filter is configured with "except"' do
      before(:all) do
        class FilterTest
          private
          def endpoint_without_verify
            @called << :endpoint_without_verify
          end
        end
      end

      before do
        FilterTest.clear_filters!
        FilterTest.before_filter(:verify_before, :except => :endpoint_without_verify)
      end

      context 'when invoking a method not defined in "except" option' do
        it 'invokes the filter' do
          subject.__send__(:run_filters, :endpoint)
          subject.called.should eq [ :verify_before, :endpoint ]
        end
      end

      context 'when invoking a method defined by "except" option' do
        it 'does not invoke the filter' do
          subject.__send__(:run_filters, :endpoint_without_verify)
          subject.called.should eq [ :endpoint_without_verify ]
        end
      end
    end

    context 'when filter is configured with "if"' do
      before(:all) do
        class FilterTest
          private
          def check_true; return true; end
          def check_false; return false; end
          def verify_before; @called << :verify_before; end
        end
      end

      context 'when "if" option is a method that returns true' do
        before do
          FilterTest.clear_filters!
          FilterTest.before_filter(:verify_before, :if => :check_true)
        end

        it 'invokes the filter' do
          subject.__send__(:run_filters, :endpoint)
          subject.called.should eq [ :verify_before, :endpoint ]
        end
      end

      context 'when "if" option is a callable that returns true' do
        before do
          FilterTest.clear_filters!
          FilterTest.before_filter(:verify_before, :if => lambda { |service| true })
        end

        it 'invokes the filter' do
          subject.__send__(:run_filters, :endpoint)
          subject.called.should eq [ :verify_before, :endpoint ]
        end
      end

      context 'when "if" option is a method that returns false' do
        before do
          FilterTest.clear_filters!
          FilterTest.before_filter(:verify_before, :if => :check_false)
        end

        it 'skips the filter' do
          subject.__send__(:run_filters, :endpoint)
          subject.called.should eq [ :endpoint ]
        end
      end

      context 'when "if" option is a callable that returns false' do
        before do
          FilterTest.clear_filters!
          FilterTest.before_filter(:verify_before, :if => lambda { |service| false })
        end

        it 'skips the filter' do
          subject.__send__(:run_filters, :endpoint)
          subject.called.should eq [ :endpoint ]
        end
      end
    end

    context 'when filter is configured with "unless"' do
      before(:all) do
        class FilterTest
          private
          def check_true; return true; end
          def check_false; return false; end
          def verify_before; @called << :verify_before; end
        end
      end

      context 'when "unless" option is a method that returns false' do
        before do
          FilterTest.clear_filters!
          FilterTest.before_filter(:verify_before, :unless => :check_false)
        end

        it 'invokes the filter' do
          subject.__send__(:run_filters, :endpoint)
          subject.called.should eq [ :verify_before, :endpoint ]
        end
      end

      context 'when "unless" option is a callable that returns true' do
        before do
          FilterTest.clear_filters!
          FilterTest.before_filter(:verify_before, :unless => lambda { |service| false })
        end

        it 'invokes the filter' do
          subject.__send__(:run_filters, :endpoint)
          subject.called.should eq [ :verify_before, :endpoint ]
        end
      end

      context 'when "unless" option is a method that returns false' do
        before do
          FilterTest.clear_filters!
          FilterTest.before_filter(:verify_before, :unless => :check_true)
        end

        it 'skips the filter' do
          subject.__send__(:run_filters, :endpoint)
          subject.called.should eq [ :endpoint ]
        end
      end

      context 'when "unless" option is a callable that returns false' do
        before do
          FilterTest.clear_filters!
          FilterTest.before_filter(:verify_before, :unless => lambda { |service| true })
        end

        it 'skips the filter' do
          subject.__send__(:run_filters, :endpoint)
          subject.called.should eq [ :endpoint ]
        end
      end
    end

    context 'when filter returns false' do
      before(:all) do
        class FilterTest
          private
          def short_circuit_filter
            @called << :short_circuit_filter
            return false
          end
        end
      end

      before do
        FilterTest.clear_filters!
        FilterTest.before_filter(:short_circuit_filter)
      end

      it 'does not invoke the rpc method' do
        subject.should_not_receive(:endpoint)
        subject.__send__(:run_filters, :endpoint)
        subject.called.should eq [ :short_circuit_filter ]
      end
    end
  end

  describe '#after_filter' do
    let(:params) { { :after_filter_calls => 0 } }

    before(:all) do
      class FilterTest
        private
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
      FilterTest.after_filter(:verify_after)
      FilterTest.after_filter(:verify_after)
      FilterTest.after_filter(:foo)
    end

    it 'calls filters in the order they were defined' do
      subject.__send__(:run_filters, :endpoint)
      subject.called.should eq [ :endpoint, :verify_after, :foo ]
      subject.after_filter_calls.should eq 1
    end
  end

  describe '#around_filter' do
    let(:params) { {} }

    before(:all) do
      class FilterTest
        private
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
      FilterTest.around_filter(:outer_around)
      FilterTest.around_filter(:inner_around)
      FilterTest.around_filter(:outer_around)
      FilterTest.around_filter(:inner_around)
    end

    it 'calls filters in the order they were defined' do
      subject.__send__(:run_filters, :endpoint)
      subject.called.should eq([ :outer_around_top,
                                 :inner_around_top,
                                 :endpoint,
                                 :inner_around_bottom,
                                 :outer_around_bottom ])
    end

    context 'when around_filter does not yield' do
      before do
        class FilterTest
          private
          def inner_around
            @called << :inner_around
          end
        end
      end

      before do
        FilterTest.around_filter(:outer_around)
        FilterTest.around_filter(:inner_around)
      end

      it 'cancels calling the rest of the filters and the endpoint' do
        subject.should_not_receive(:endpoint)
        subject.__send__(:run_filters, :endpoint)
        subject.called.should eq([ :outer_around_top,
                                   :inner_around,
                                   :outer_around_bottom ])
      end

    end
  end

end
