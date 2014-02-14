require 'spec_helper'
require 'protobuf/rpc/service_dispatcher'

describe Protobuf::Rpc::ServiceDispatcher do
  let(:app) { Proc.new { |env| env } }
  let(:caller) { 'caller.test.co' }
  let(:env) {
    Protobuf::Rpc::Env.new(
      'caller' => caller,
      'encoded_request' => encoded_request,
      'log_signature' => 'log_signature',
      'method_name' => method_name,
      'request' => request,
      'request_type' => request_type,
      'response_type' => response_type,
      'rpc_method' => rpc_method,
      'rpc_service' => service_class,
      'service_name' => service_name,
    )
  }
  let(:encoded_request) { request_wrapper.encode }
  let(:method_name) { :find }
  let(:request) { request_type.new(:name => 'required') }
  let(:request_type) { rpc_method.request_type }
  let(:request_wrapper) {
    Protobuf::Socketrpc::Request.new(
      :caller => caller,
      :service_name => service_name,
      :method_name => method_name.to_s,
      :request_proto => request
    )
  }
  let(:response) { response_type.new(:name => 'required') }
  let(:response_type) { rpc_method.response_type }
  let(:rpc_method) { service_class.rpcs[method_name] }
  let(:rpc_service) { service_class.new(env) }
  let(:service_class) { Test::ResourceService }
  let(:service_name) { service_class.to_s }

  subject { described_class.new(app) }

  before { subject.stub(:rpc_service).and_return(rpc_service) }

  describe '#call' do
    before { rpc_service.stub(:callable_rpc_method).and_return(lambda {}) }

    context 'regular invocation' do
      before { rpc_service.stub(:response).and_return(response) }

      it "sets Env#response" do
        stack_env = subject.call(env)
        stack_env.response.should eq response
      end
    end

    context 'when service responds with' do
      context 'a hash object' do
        before { rpc_service.stub(:response).and_return(response.to_hash) }

        it "sets Env#response" do
          stack_env = subject.call(env)
          stack_env.response.should eq response
        end
      end

      context 'an object that responds to to_hash but is not a hash' do
        let(:hashable) {
          double('hashable', :to_hash => response.to_hash)
        }

        before { rpc_service.stub(:response).and_return(hashable) }

        it "sets Env#response" do
          stack_env = subject.call(env)
          stack_env.response.should eq response
        end
      end

      context 'an object that responds to to_proto' do
        let(:protoable) {
          double('protoable', :to_proto => response)
        }

        before { rpc_service.stub(:response).and_return(protoable) }

        it "sets Env#response" do
          stack_env = subject.call(env)
          stack_env.response.should eq response
        end
      end

      context 'a type not identified by the rpc definition' do
        before { rpc_service.stub(:response).and_return("I'm not a valid response") }

        it "raises a bad response proto exception" do
          expect { subject.call(env) }.to raise_exception(Protobuf::Rpc::BadResponseProto)
        end
      end
    end

    context 'when service invokes rpc failed callback' do
      let(:method_name) { :find_with_rpc_failed }

      before { rpc_service.stub(:callable_rpc_method).and_return(lambda { rpc_service.__send__(method_name) }) }

      it "sets Env#response to an error" do
        expect { subject.call(env) }.to raise_exception(Protobuf::Rpc::RpcFailed)
      end
    end
  end
end
