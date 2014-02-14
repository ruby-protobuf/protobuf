require 'spec_helper'
require 'protobuf/rpc/service_dispatcher'

describe Protobuf::Rpc::ServiceDispatcher do
  let(:app) { proc { |env| env } }
  let(:env) {
    Protobuf::Rpc::Env.new(
      'method_name' => method_name,
      'rpc_service' => service_class,
      'service_name' => service_name,
    )
  }
  let(:method_name) { :find }
  let(:response) { response_type.new(:name => 'required') }
  let(:response_type) { service_class.rpcs[method_name].response_type }
  let(:rpc_service) { service_class.new(env) }
  let(:service_class) { Test::ResourceService }
  let(:service_name) { service_class.to_s }

  subject { described_class.new(app) }

  before { subject.stub(:rpc_service).and_return(rpc_service) }

  describe '#call' do
    before { rpc_service.stub(:callable_rpc_method).and_return(lambda {}) }
    before { rpc_service.stub(:response).and_return(response) }

    it "dispatches the request" do
      stack_env = subject.call(env)
      stack_env.response.should eq response
    end

    context "when the given RPC method is not implemented" do
      before { rpc_service.stub(:callable_rpc_method).and_return(lambda { rpc_service.__send__(:foo) }) }

      it "raises a method not found exception" do
        expect { subject.call(env) }.to raise_exception(Protobuf::Rpc::MethodNotFound)
      end
    end
  end
end
