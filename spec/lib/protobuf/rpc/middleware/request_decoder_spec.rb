require 'spec_helper'

describe Protobuf::Rpc::Middleware::RequestDecoder do
  let(:app) { Proc.new { |env| env } }
  let(:caller) { 'caller.test.co' }
  let(:env) {
    Protobuf::Rpc::Env.new(
      'encoded_request' => encoded_request,
      'log_signature' => 'log_signature',
      'stats' => Protobuf::Rpc::Stat.new(:SERVER)
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

    it "sets Env#stats.request_size" do
      stack_env = subject.call(env)
      stack_env.stats.request_size.should eq encoded_request.size
    end

    it "sets Env#stats.client" do
      stack_env = subject.call(env)
      stack_env.stats.client.should eq caller
    end

    context "when decoding fails" do
      let(:error) { Protobuf::Rpc::BadRequestData.new("Unable to decode request: Boom!") }
      let(:response) { error.to_response }

      before { Protobuf::Socketrpc::Request.stub(:decode).and_raise(RuntimeError, 'Boom!') }

      it "does not call the stack" do
        app.should_not_receive(:call)
        subject.call(env)
      end

      it "sets Env#response" do
        stack_env = subject.call(env)
        stack_env.response.should eq error
      end
    end
  end
end
