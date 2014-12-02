require 'spec_helper'
require 'protobuf/rpc/service'

RSpec.describe Protobuf::Rpc::Connectors::Common do
  let(:common_class) do
    Class.new(Protobuf::Rpc::Connectors::Base) do
      include Protobuf::Rpc::Connectors::Common
      attr_accessor :options
      attr_accessor :stats
    end
  end

  let(:subject_options) { {} }

  subject { @subject ||= common_class.new(subject_options) }

  context "API" do
    specify { expect(subject.respond_to?(:any_callbacks?)).to be true }
    specify { expect(subject.respond_to?(:request_caller)).to be true }
    specify { expect(subject.respond_to?(:data_callback)).to be true }
    specify { expect(subject.respond_to?(:error)).to be true }
    specify { expect(subject.respond_to?(:failure)).to be true }
    specify { expect(subject.respond_to?(:complete)).to be true }
    specify { expect(subject.respond_to?(:parse_response)).to be true }
    specify { expect(subject.respond_to?(:verify_options!)).to be true }
    specify { expect(subject.respond_to?(:verify_callbacks)).to be true }
  end

  describe "#any_callbacks?" do

    [:@complete_cb, :@success_cb, :@failure_cb].each do |cb|
      it "returns true if #{cb} is provided" do
        subject.instance_variable_set(cb, "something")
        expect(subject.any_callbacks?).to be true
      end
    end

    it "returns false when all callbacks are not provided" do
      subject.instance_variable_set(:@complete_cb, nil)
      subject.instance_variable_set(:@success_cb, nil)
      subject.instance_variable_set(:@failure_cb, nil)

      expect(subject.any_callbacks?).to be false
    end

  end

  describe '#request_caller' do
    specify { expect(subject.request_caller).to eq ::Protobuf.client_host }

    context 'when "client_host" option is given to initializer' do
      let(:hostname) { 'myhost.myserver.com' }
      let(:subject_options) { { :client_host => hostname } }

      specify { expect(subject.request_caller).to_not eq ::Protobuf.client_host }
      specify { expect(subject.request_caller).to eq hostname }
    end
  end

  describe "#data_callback" do
    it "changes state to use the data callback" do
      subject.data_callback("data")
      expect(subject.instance_variable_get(:@used_data_callback)).to be true
    end

    it "sets the data var when using the data_callback" do
      subject.data_callback("data")
      expect(subject.instance_variable_get(:@data)).to eq("data")
    end
  end

  describe '#request_bytes' do
    let(:service) { Test::ResourceService }
    let(:method) { :find }
    let(:request) { '' }
    let(:client_host) { 'myhost.myservice.com' }
    let(:subject_options) do
      {
        :service => service,
        :method => method,
        :request => request,
        :client_host => client_host,
      }
    end

    let(:expected) do
      ::Protobuf::Socketrpc::Request.new(
        :service_name => service.name,
        :method_name => 'find',
        :request_proto => '',
        :caller => client_host,
      )
    end

    before { allow(subject).to receive(:validate_request_type!).and_return(true) }
    before { expect(subject).not_to receive(:failure) }

    specify { expect(subject.request_bytes).to eq expected.encode }
  end

  describe "#verify_callbacks" do

    it "sets @failure_cb to #data_callback when no callbacks are defined" do
      subject.verify_callbacks
      expect(subject.instance_variable_get(:@failure_cb)).to eq(subject.method(:data_callback))
    end

    it "sets @success_cb to #data_callback when no callbacks are defined" do
      subject.verify_callbacks
      expect(subject.instance_variable_get(:@success_cb)).to eq(subject.method(:data_callback))
    end

    it "doesn't set @failure_cb when already defined" do
      set_cb = -> { true }
      subject.instance_variable_set(:@failure_cb, set_cb)
      subject.verify_callbacks
      expect(subject.instance_variable_get(:@failure_cb)).to eq(set_cb)
      expect(subject.instance_variable_get(:@failure_cb)).to_not eq(subject.method(:data_callback))
    end

    it "doesn't set @success_cb when already defined" do
      set_cb = -> { true }
      subject.instance_variable_set(:@success_cb, set_cb)
      subject.verify_callbacks
      expect(subject.instance_variable_get(:@success_cb)).to eq(set_cb)
      expect(subject.instance_variable_get(:@success_cb)).to_not eq(subject.method(:data_callback))
    end

  end

  shared_examples "a ConnectorDisposition" do |meth, cb, *args|

    it "calls #complete before exit" do
      subject.stats = double("Object", :stop => true)

      expect(subject).to receive(:complete)
      subject.method(meth).call(*args)
    end

    it "calls the #{cb} callback when provided" do
      stats = double("Object")
      allow(stats).to receive(:stop).and_return(true)
      subject.stats = stats
      some_cb = double("Object")

      subject.instance_variable_set("@#{cb}", some_cb)
      expect(some_cb).to receive(:call).and_return(true)
      subject.method(meth).call(*args)
    end

    it "calls the complete callback when provided" do
      stats = double("Object")
      allow(stats).to receive(:stop).and_return(true)
      subject.stats = stats
      comp_cb = double("Object")

      subject.instance_variable_set(:@complete_cb, comp_cb)
      expect(comp_cb).to receive(:call).and_return(true)
      subject.method(meth).call(*args)
    end

  end

  it_behaves_like("a ConnectorDisposition", :failure, "failure_cb", "code", "message")
  it_behaves_like("a ConnectorDisposition", :failure, "complete_cb", "code", "message")
  it_behaves_like("a ConnectorDisposition", :succeed, "complete_cb", "response")
  it_behaves_like("a ConnectorDisposition", :succeed, "success_cb", "response")
  it_behaves_like("a ConnectorDisposition", :complete, "complete_cb")

end
