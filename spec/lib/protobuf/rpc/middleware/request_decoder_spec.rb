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
  let(:encoded_request) { request.encode }
  let(:method_name) { 'bar' }
  let(:request) {
    Protobuf::Socketrpc::Request.new(
      :caller => caller,
      :service_name => service_name,
      :method_name => method_name
    )
  }
  let(:service_name) { 'Foo' }

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
      stack_env.method_name.should eq method_name
    end

    context "when decoding fails" do
      before { Protobuf::Socketrpc::Request.stub(:decode).and_raise(RuntimeError) }

      it "raises a bad request data exception" do
        expect { subject.call(env) }.to raise_exception(Protobuf::Rpc::BadRequestData)
      end
    end
  end
end
