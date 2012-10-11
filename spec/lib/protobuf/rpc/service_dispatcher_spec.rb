require 'spec_helper'
require 'protobuf/rpc/service_dispatcher'

describe Protobuf::Rpc::ServiceDispatcher do
  let(:service_name) { 'Test::ResourceService' }
  let(:method_name) { 'find' }
  let(:request) { Test::ResourceFindRequest.new(:name => 'resource') }
  let(:request_bytes) { request.to_s }
  let(:response) { Test::Resource.new }
  let(:wrapper) do
    Protobuf::Socketrpc::Request.new({ :service_name => service_name,
                                       :method_name => method_name,
                                       :request_proto => request_bytes })

  end

  subject { described_class.new(wrapper) }

  context 'creating a new dispatcher' do
    its(:service) { should be_instance_of service_name.constantize }
    its(:callable_method) { should be_a(Method) }
    its(:outer_request) { should eq wrapper }
    its(:error) { should be_nil }

    context 'when service name is not a valid constant' do
      let(:service_name) { 'FlibbityGibbit' }
      its(:success?) { should be_false }
      its(:error) { should be_instance_of(Protobuf::Rpc::ServiceNotFound) }
    end

    context 'when method is not defined by the service' do
      let(:method_name) { 'holly_hooby_whaty' }
      its(:success?) { should be_false }
      its(:error) { should be_instance_of(Protobuf::Rpc::MethodNotFound) }
    end

    context 'when method is defined but is not an rpc method' do
      before do
        class Test::Resource
          def non_rpc_method; end
        end
      end

      let(:method_name) { 'non_rpc_method' }
      its(:success?) { should be_false }
      its(:error) { should be_instance_of(Protobuf::Rpc::MethodNotFound) }
    end
  end

  describe '#invoke!' do
    context 'regular invocation' do
      before { subject.callable_method.should_receive(:call).with(request, response).and_return(response) }
      before { subject.invoke! }
      its(:request) { should be_instance_of Test::ResourceFindRequest }
      its(:response) { should be_instance_of Test::Resource }
      its(:success?) { should be_true }
    end

    context 'when service responds with' do
      context 'a hash object' do
        let(:returned_response) { { :name => 'returned' } }
        before { subject.callable_method.should_receive(:call).and_return(returned_response) }
        before { subject.invoke! }
        its(:success?) { should be_true }
        its(:response) { should eq Test::Resource.new(:name => 'returned') }
      end

      context 'a type not identified by the rpc definition' do
        let(:invalid_response) { "I'm not a valid response" }
        before { subject.callable_method.should_receive(:call).and_return(invalid_response) }
        before { subject.invoke! }
        its(:error) { should be_instance_of(Protobuf::Rpc::BadResponseProto) }
      end
    end

    context 'when service invokes rpc failed callback' do
      before(:all) do
        class Test::ResourceService
          rpc :find_with_rpc_failed, Test::ResourceFindRequest, Test::Resource
          def find_with_rpc_failed(request, response)
            rpc_failed('Find failed')
          end
        end
      end

      let(:method_name) { 'find_with_rpc_failed' }
      before { subject.service.find_with_rpc_failed(request, response) }

      its(:success?) { should be_false }
      its(:error) { should be_instance_of(Protobuf::Rpc::RpcFailed) }
    end
  end

end
