require 'spec_helper'

describe Protobuf::Rpc::Middleware::Logger do
  let(:app) { Proc.new { |inner_env| inner_env } }
  let(:env) {
    Protobuf::Rpc::Env.new(
      'client_host' => 'client_host.test.co',
      'encoded_request' => request_wrapper.encode,
      'encoded_response' => response_wrapper.encode,
      'method_name' => method_name,
      'request' => request,
      'request_type' => rpc_method.request_type,
      'response' => response,
      'response_type' => rpc_method.response_type,
      'rpc_method' => rpc_method,
      'rpc_service' => service_class,
      'service_name' => service_name,
    )
  }
  let(:method_name) { :find }
  let(:request) { request_type.new(:name => 'required') }
  let(:request_type) { rpc_method.request_type }
  let(:request_wrapper) {
    Protobuf::Socketrpc::Request.new(
      :service_name => service_name,
      :method_name => method_name.to_s,
      :request_proto => request
    )
  }
  let(:response_wrapper) { Protobuf::Socketrpc::Response.new(:response_proto => response) }
  let(:response) { rpc_method.response_type.new(:name => 'required') }
  let(:rpc_method) { service_class.rpcs[method_name] }
  let(:rpc_service) { service_class.new(env) }
  let(:service_class) { Test::ResourceService }
  let(:service_name) { service_class.to_s }

  subject { described_class.new(app) }

  describe "#call" do
    it "calls the stack" do
      app.should_receive(:call).with(env)
      subject.call(env)
    end

    it "returns the env" do
      subject.call(env).should eq env
    end
  end
end
