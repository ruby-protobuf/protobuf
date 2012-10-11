require 'spec_helper'
require 'spec/support/test/resource_service'

describe Protobuf::Rpc::Service do

  context 'class methods' do
    subject { Test::ResourceService }

    before :each do
      reset_service_location Test::ResourceService
    end

    describe '.host' do
      its(:host) { should eq described_class::DEFAULT_HOST }
    end

    describe '.host=' do
      before { subject.host = 'mynewhost.com' }
      its(:host) { should eq 'mynewhost.com' }
    end

    describe '.port' do
      its(:port) { should eq described_class::DEFAULT_PORT }
    end

    describe '.port=' do
      before { subject.port = 12345 }
      its(:port) { should eq 12345 }
    end

    describe '.configure' do
      context 'when providing a host' do
        before { subject.configure(:host => 'mynewhost.com') }
        its(:host) { should eq 'mynewhost.com' }
      end

      context 'when providing a port' do
        before { subject.configure(:port => 12345) }
        its(:port) { should eq 12345 }
      end
    end

    describe '.located_at' do
      context 'when given location is empty' do
        before { subject.located_at(nil) }
        its(:host) { should eq described_class::DEFAULT_HOST }
        its(:port) { should eq described_class::DEFAULT_PORT }
      end

      context 'when given location is invalid' do
        before { subject.located_at('i like pie') }
        its(:host) { should eq described_class::DEFAULT_HOST }
        its(:port) { should eq described_class::DEFAULT_PORT }
      end

      context 'when given location contains a host and port' do
        before { subject.located_at('mynewdomain.com:12345') }
        its(:host) { should eq 'mynewdomain.com' }
        its(:port) { should eq 12345 }
      end
    end

    describe '.client' do
      it 'initializes a client object for this service' do
        client = double('client')
        ::Protobuf::Rpc::Client.should_receive(:new)
                                .with(hash_including({ :service => subject,
                                                       :host => subject.host,
                                                       :port => subject.port }))
                                .and_return(client)
        subject.client.should eq client
      end
    end

    describe '.rpc' do
      before { Test::ResourceService.rpc(:update, Test::ResourceFindRequest, Test::Resource) }
      subject { Test::ResourceService.rpcs[:update] }
      its(:method) { should eq :update }
      its(:request_type) { should eq Test::ResourceFindRequest }
      its(:response_type) { should eq Test::Resource }
    end

    describe '.rpc_method?' do
      before { Test::ResourceService.rpc(:delete, Test::Resource, Test::Resource) }

      context 'when given name is a pre-defined rpc method' do
        it 'returns true' do
          subject.rpc_method?(:delete).should be_true
        end
      end

      context 'when given name is not a pre-defined rpc method' do
        it 'returns false' do
          subject.rpc_method?(:zoobaboo).should be_false
        end
      end
    end
  end

  context 'instance methods' do
    subject { Test::ResourceService.new }

    context 'when invoking a service call' do
      before(:all) do
        class ::NewTestService < Protobuf::Rpc::Service
          rpc :find, Test::ResourceFindRequest, Test::Resource
          def find(request, response)
            response
          end

          rpc :find_with_rpc_failed, Test::ResourceFindRequest, Test::Resource
          def find_with_rpc_failed(request, response)
            rpc_failed('This is a failed endpoint')
            response.name = 'Name will still be set'
            return response
          end
        end
      end


      let(:request) do
        Test::ResourceFindRequest.new(:name => 'resource')
      end

      let(:response) do
        Test::Resource.new
      end

      subject { NewTestService.new(:find) }
      specify { subject.find(request, response).should eq response }

      context 'when calling rpc_failed in the method' do
        it 'invokes the rpc_failed callback with the error' do
          error = nil
          service = NewTestService.new(:find_with_rpc_failed)
          service.on_rpc_failed(lambda { |err| error = err })
          returned_response = service.find_with_rpc_failed(request, response)
          error.should eq 'This is a failed endpoint'
          returned_response.name.should eq 'Name will still be set'
        end
      end
    end

  end

end
