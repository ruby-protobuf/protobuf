require 'spec_helper'

describe Protobuf::Rpc::Middleware::ResponseEncoder do
  let(:app) { Proc.new { |env| env } }
  let(:env) {
    Protobuf::Rpc::Env.new(
      'response' => response_proto,
      'log_signature' => 'log_signature'
    )
  }
  let(:encoded_response) { response.encode }
  let(:response) {
    Protobuf::Socketrpc::Response.new(
      :response_proto => response_proto
    )
  }
  let(:response_proto) { Test::Resource.new(:name => 'required') }

  subject { described_class.new(app) }

  describe "#call" do
    it "encodes the response" do
      stack_env = subject.call(env)
      stack_env.encoded_response.should eq encoded_response
    end

    it "calls the stack" do
      app.should_receive(:call).with(env).and_return(env)
      subject.call(env)
    end

    context "when response is a Protobuf error" do
      let(:encoded_response) { response.encode }
      let(:env) {
        Protobuf::Rpc::Env.new(
          'response' => error,
          'log_signature' => 'log_signature'
        )
      }
      let(:error) { Protobuf::Rpc::RpcError.new }
      let(:response) { error.to_response }

      it "encodes the response" do
        stack_env = subject.call(env)
        stack_env.encoded_response.should eq encoded_response
      end
    end

    context "when encoding fails" do
      before { Protobuf::Socketrpc::Response.stub(:encode).and_raise(RuntimeError) }

      it "raises a bad request data exception" do
        expect { subject.call(env) }.to raise_exception(Protobuf::Rpc::PbError)
      end
    end
  end
end
