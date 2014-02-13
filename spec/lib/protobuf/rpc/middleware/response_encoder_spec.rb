require 'spec_helper'

describe Protobuf::Rpc::Middleware::ResponseEncoder do
  let(:app) { Proc.new { |env| env } }
  let(:env) {
    Protobuf::Rpc::Env.new(
      'response' => response_proto,
      'log_signature' => 'log_signature',
      'stats' => Protobuf::Rpc::Stat.new(:SERVER)
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

    it "sets Env#stats.request_size" do
      stack_env = subject.call(env)
      stack_env.stats.response_size.should eq encoded_response.size
    end

    context "when response is a Protobuf error" do
      let(:encoded_response) { response.encode }
      let(:env) {
        Protobuf::Rpc::Env.new(
          'response' => error,
          'log_signature' => 'log_signature',
          'stats' => Protobuf::Rpc::Stat.new(:SERVER)
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
      let(:error) { Protobuf::Rpc::PbError.new('Boom!') }
      let(:response) { error.to_response }

      before { Protobuf::Socketrpc::Response.stub(:encode).and_raise(RuntimeError, 'Boom!') }

      it "sets Env#response" do
        stack_env = subject.call(env)
        stack_env.response.should eq error
      end

      it "encodes the response" do
        stack_env = subject.call(env)
        stack_env.encoded_response.should eq encoded_response
      end
    end
  end
end
