require 'spec_helper'

RSpec.describe 'Protobuf::Rpc::ServiceFilters inheritance' do
  let(:parent) do
    Class.new do
      include Protobuf::Rpc::ServiceFilters
    end
  end

  def callables(klass, type)
    klass.filters[type].map { |filter| filter[:callable] }
  end

  it 'copies the parent filters to a new subclass' do
    parent.before_filter :authenticate
    parent.around_filter :instrument
    child = Class.new(parent)

    expect(callables(child, :before)).to eq([:authenticate])
    expect(callables(child, :around)).to eq([:instrument])
  end

  it 'does not add subclass filters to the parent' do
    child = Class.new(parent)
    child.before_filter :child_only

    expect(callables(parent, :before)).to eq([])
  end

  it 'adds a filter that the parent defines later to existing subclasses' do
    child = Class.new(parent)
    grandchild = Class.new(child)
    child.before_filter :child_only
    parent.before_filter :shared

    expect(callables(child, :before)).to eq([:child_only, :shared])
    expect(callables(grandchild, :before)).to eq([:child_only, :shared])
  end

  it 'does not add the same filter two times to a subclass' do
    parent.before_filter :authenticate
    child = Class.new(parent)
    child.before_filter :authenticate
    parent.before_filter :authenticate

    expect(callables(child, :before)).to eq([:authenticate])
  end

  describe 'rescue_from' do
    let(:parent_handler) { ->(_service, _ex) {} }
    let(:child_handler) { ->(_service, _ex) {} }

    it 'copies the parent rescue filters to a new subclass' do
      parent.rescue_from(ArgumentError, :with => parent_handler)
      child = Class.new(parent)

      expect(child.rescue_filters).to eq(ArgumentError => parent_handler)
    end

    it 'adds a rescue filter that the parent defines later to existing subclasses' do
      child = Class.new(parent)
      parent.rescue_from(ArgumentError, :with => parent_handler)

      expect(child.rescue_filters).to eq(ArgumentError => parent_handler)
    end

    it 'keeps a handler that the subclass defined for the same exception class' do
      child = Class.new(parent)
      child.rescue_from(ArgumentError, :with => child_handler)
      parent.rescue_from(ArgumentError, :with => parent_handler)

      expect(child.rescue_filters[ArgumentError]).to eq(child_handler)
    end

    it 'replaces an inherited handler when the parent changes it' do
      parent.rescue_from(ArgumentError, :with => child_handler)
      child = Class.new(parent)
      parent.rescue_from(ArgumentError, :with => parent_handler)

      expect(child.rescue_filters[ArgumentError]).to eq(parent_handler)
    end
  end

  it 'runs filters from Protobuf::Rpc::ApplicationService on a subclass' do
    base = Class.new(Protobuf::Rpc::ApplicationService) do
      before_filter :mark

      def mark
        @marked = true
      end
    end
    service = Class.new(base) do
      def marked?
        @marked
      end

      def endpoint; end
    end

    instance = service.allocate
    instance.__send__(:run_filters, :endpoint)

    expect(instance).to be_marked
  end
end
