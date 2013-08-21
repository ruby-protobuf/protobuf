require 'spec_helper'
require 'protobuf/rpc/service'

describe Protobuf::Rpc::Connectors::Common do
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
    specify { subject.respond_to?(:any_callbacks?).should be_true }
    specify { subject.respond_to?(:request_caller).should be_true }
    specify { subject.respond_to?(:data_callback).should be_true }
    specify { subject.respond_to?(:error).should be_true }
    specify { subject.respond_to?(:fail).should be_true }
    specify { subject.respond_to?(:complete).should be_true }
    specify { subject.respond_to?(:parse_response).should be_true }
    specify { subject.respond_to?(:verify_options!).should be_true }
    specify { subject.respond_to?(:verify_callbacks).should be_true }
  end

  describe "#any_callbacks?" do

    [:@complete_cb, :@success_cb, :@failure_cb].each do |cb|
      it "returns true if #{cb} is provided" do
        subject.instance_variable_set(cb, "something")
        subject.any_callbacks?.should be_true
      end
    end

    it "returns false when all callbacks are not provided" do
      subject.instance_variable_set(:@complete_cb, nil)
      subject.instance_variable_set(:@success_cb, nil)
      subject.instance_variable_set(:@failure_cb, nil)

      subject.any_callbacks?.should be_false
    end

  end

  describe '#request_caller' do
    its(:request_caller) { should eq ::Protobuf.client_host }

    context 'when "client_host" option is given to initializer' do
      let(:hostname) { 'myhost.myserver.com' }
      let(:subject_options) { { :client_host => hostname } }

      its(:request_caller) { should_not eq ::Protobuf.client_host }
      its(:request_caller) { should eq hostname }
    end
  end

  describe "#data_callback" do
    it "changes state to use the data callback" do
      subject.data_callback("data")
      subject.instance_variable_get(:@used_data_callback).should be_true
    end

    it "sets the data var when using the data_callback" do
      subject.data_callback("data")
      subject.instance_variable_get(:@data).should eq("data")
    end
  end

  describe '#request_bytes' do
    let(:service) { Test::ResourceService }
    let(:method) { :find }
    let(:request) { '' }
    let(:client_host) { 'myhost.myservice.com' }
    let(:subject_options) { { :service => service,
                              :method => method,
                              :request => request,
                              :client_host => client_host } }

    let(:expected) { ::Protobuf::Socketrpc::Request.new({ :service_name => service.name,
                                                          :method_name => 'find',
                                                          :request_proto => '',
                                                          :caller => client_host }) }

    before { subject.stub(:validate_request_type!).and_return(true) }
    before { subject.should_not_receive(:fail) }

    its(:request_bytes) { should eq expected.encode }
  end

  describe "#verify_callbacks" do

    it "sets @failure_cb to #data_callback when no callbacks are defined" do
      subject.verify_callbacks
      subject.instance_variable_get(:@failure_cb).should eq(subject.method(:data_callback))
    end

    it "sets @success_cb to #data_callback when no callbacks are defined" do
      subject.verify_callbacks
      subject.instance_variable_get(:@success_cb).should eq(subject.method(:data_callback))
    end

    it "doesn't set @failure_cb when already defined" do
      set_cb = lambda{ true }
      subject.instance_variable_set(:@failure_cb, set_cb)
      subject.verify_callbacks
      subject.instance_variable_get(:@failure_cb).should eq(set_cb)
      subject.instance_variable_get(:@failure_cb).should_not eq(subject.method(:data_callback))
    end

    it "doesn't set @success_cb when already defined" do
      set_cb = lambda{ true }
      subject.instance_variable_set(:@success_cb, set_cb)
      subject.verify_callbacks
      subject.instance_variable_get(:@success_cb).should eq(set_cb)
      subject.instance_variable_get(:@success_cb).should_not eq(subject.method(:data_callback))
    end

  end

  shared_examples "a ConnectorDisposition" do |meth, cb, *args|

    it "calls #complete before exit" do
      stats = double("Object")
      stats.stub(:stop) { true }
      subject.stats = stats

      subject.should_receive(:complete)
      subject.method(meth).call(*args)
    end

    it "calls the #{cb} callback when provided" do
      stats = double("Object")
      stats.stub(:stop) { true }
      subject.stats = stats
      _cb = double("Object")

      subject.instance_variable_set("@#{cb}", _cb)
      _cb.should_receive(:call).and_return(true)
      subject.method(meth).call(*args)
    end

    it "calls the complete callback when provided" do
      stats = double("Object")
      stats.stub(:stop) { true }
      subject.stats = stats
      comp_cb = double("Object")

      subject.instance_variable_set(:@complete_cb, comp_cb)
      comp_cb.should_receive(:call).and_return(true)
      subject.method(meth).call(*args)
    end

  end

  it_behaves_like("a ConnectorDisposition", :fail, "failure_cb", "code", "message")
  it_behaves_like("a ConnectorDisposition", :fail, "complete_cb", "code", "message")
  it_behaves_like("a ConnectorDisposition", :succeed, "complete_cb", "response")
  it_behaves_like("a ConnectorDisposition", :succeed, "success_cb", "response")
  it_behaves_like("a ConnectorDisposition", :complete, "complete_cb")

end
