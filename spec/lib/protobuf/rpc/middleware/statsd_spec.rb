require 'spec_helper'
require 'timecop'

describe Protobuf::Rpc::Middleware::Statsd do
  let(:app) { Proc.new { |inner_env| Timecop.freeze(Time.now + call_time); inner_env } }
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
  let(:response) { rpc_method.response_type.new(:name => 'required') }
  let(:response_wrapper) { Protobuf::Socketrpc::Response.new(:response_proto => response) }
  let(:rpc_method) { service_class.rpcs[method_name] }
  let(:rpc_service) { service_class.new(env) }
  let(:service_class) { Test::ResourceService }
  let(:service_name) { service_class.to_s }
  let(:stats_path) { 'rpc-server.test.resourceservice.find' }
  let(:call_time) { 100 }

  subject { described_class.new(app) }

  describe "#call" do
    context "without Protobuf::Statsd.client set" do
      before :each do
        Protobuf::Statsd.client = nil
      end

      it "calls the stack" do
        app.should_receive(:call).with(env)
        subject.call(env)
      end

      it "returns the env" do
        subject.call(env).should eq env
      end
    end

    context "with Protobuf::Statsd.client set" do
      let(:statsd_client) { double("Statsd::Client") }

      before :each do
        Protobuf::Statsd.client = statsd_client
        Protobuf::Rpc::Middleware::Statsd.any_instance.stub(:statsd_base_path).and_return(stats_path)
        Timecop.freeze(Time.now)
      end

      after :each do
        Protobuf::Statsd.client = nil
        Timecop.return
      end

      context "with success response" do
        it "should increment the proper stats" do
          expect(statsd_client).to receive(:increment).with("#{stats_path}.success")
          expect(statsd_client).to receive(:timing).with("#{stats_path}.time", call_time)

          subject.call(env)
        end
      end

      context "with failure response" do
        let(:type) { Protobuf::Socketrpc::ErrorReason::BAD_REQUEST_DATA }
        let(:response) { Protobuf::Rpc::PbError.new('ooops', type) }
        let(:response_wrapper) { response.to_response }

        it "should increment the proper stats" do
          expect(statsd_client).to receive(:increment).with("#{stats_path}.failure.total")
          expect(statsd_client).to receive(:increment).with("#{stats_path}.failure.#{type}")
          expect(statsd_client).to receive(:timing).with("#{stats_path}.time", call_time)

          subject.call(env)
        end
      end
    end
  end

  describe "#statsd_base_path" do
    it "should return a good path" do
      expect(subject.statsd_base_path(env)).to eql "rpc-server.test.resourceservice.find"
    end
  end
end
