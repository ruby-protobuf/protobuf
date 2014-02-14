require 'spec_helper'

describe Protobuf::Rpc::Middleware::RequestDecoder do
  let(:app) { Proc.new { |env| env } }
  let(:caller) { 'caller.test.co' }
  let(:env) {
    Protobuf::Rpc::Env.new(
      'encoded_request' => encoded_request,
      'log_signature' => 'log_signature'
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
  let(:response_type) { rpc_method.response_type }
  let(:rpc_method) { rpc_service.rpcs[method_name] }
  let(:rpc_service) { Test::ResourceService }
  let(:service_name) { rpc_service.to_s }

  subject { described_class.new(app) }

  describe "#call" do
    it "decodes the request" do
      stack_env = subject.call(env)
      stack_env.request.should eq request
    end

    it "calls the stack" do
      app.should_receive(:call).with(env)
      subject.call(env)
    end

    it "sets Env#caller" do
      stack_env = subject.call(env)
      stack_env.caller.should eq caller
    end

    it "sets Env#service_name" do
      stack_env = subject.call(env)
      stack_env.service_name.should eq service_name
    end

    it "sets Env#method_name" do
      stack_env = subject.call(env)
      stack_env.method_name.should eq method_name.to_sym
    end

    it "sets Env#request_type" do
      stack_env = subject.call(env)
      stack_env.request_type.should eq request_type
    end

    it "sets Env#response_type" do
      stack_env = subject.call(env)
      stack_env.response_type.should eq response_type
    end

    it "sets Env#rpc_method" do
      stack_env = subject.call(env)
      stack_env.rpc_method.should eq rpc_method
    end

    it "sets Env#rpc_service" do
      stack_env = subject.call(env)
      stack_env.rpc_service.should eq rpc_service
    end

    context "when decoding fails" do
      before { Protobuf::Socketrpc::Request.stub(:decode).and_raise(RuntimeError) }

      it "raises a bad request data exception" do
        expect { subject.call(env) }.to raise_exception(Protobuf::Rpc::BadRequestData)
      end
    end

    context "when the RPC service is not defined" do
      let(:request_wrapper) {
        Protobuf::Socketrpc::Request.new(
          :caller => caller,
          :service_name => 'Foo',
          :method_name => method_name.to_s,
          :request_proto => request
        )
      }

      it "raises a bad request data exception" do
        expect { subject.call(env) }.to raise_exception(Protobuf::Rpc::ServiceNotFound)
      end
    end

    context "when RPC method is not defined" do
      let(:request_wrapper) {
        Protobuf::Socketrpc::Request.new(
          :caller => caller,
          :service_name => service_name,
          :method_name => 'foo',
          :request_proto => request
        )
      }

      it "raises a bad request data exception" do
        expect { subject.call(env) }.to raise_exception(Protobuf::Rpc::MethodNotFound)
      end
    end
  end
end
