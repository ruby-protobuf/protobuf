require 'spec_helper'
require 'spec/support/test/resource_service'

describe Protobuf::Rpc::Service do

  context 'when configuring' do
    before :each do
      reset_service_location Test::ResourceService
    end

    it 'should have a default location configured' do
      Test::ResourceService.host.should == Protobuf::Rpc::Service::DEFAULT_LOCATION[:host]
      Test::ResourceService.port.should == Protobuf::Rpc::Service::DEFAULT_LOCATION[:port]
    end

    it "should be able to pre-configure a service location for clients" do
      Test::ResourceService.located_at 'google.com:12345'
      client = Test::ResourceService.client
      client.options[:host].should == 'google.com'
      client.options[:port].should == 12345
    end

    context 'configuring host' do
      before(:each) { Test::ResourceService.configure :host => 'somehost.com' }
      after(:each) { Test::ResourceService.configure :host => '127.0.0.1' }

      it 'should be able to configure and read the host' do
        Test::ResourceService.host.should == 'somehost.com'
      end
    end

    it 'should be able to configure and read the port' do
      Test::ResourceService.configure :port => 12345
      Test::ResourceService.port.should == 12345
    end

    it 'should skip configuring location if the location passed does not match host:port syntax' do
      invalid_locations = [nil, 'myhost:', ':9939', 'badhost123']
      invalid_locations.each do |location|
        Test::ResourceService.located_at location
        Test::ResourceService.host.should == Protobuf::Rpc::Service::DEFAULT_LOCATION[:host]
        Test::ResourceService.port.should == Protobuf::Rpc::Service::DEFAULT_LOCATION[:port]
      end
    end
  end

  context 'when server calls the service method' do

    before(:all) do
      class ::NewTestService < Protobuf::Rpc::Service
        rpc :bad_method, Test::ResourceFindRequest, Test::Resource
        rpc :bad_var, Test::ResourceFindRequest, Test::Resource
        def bad_method
          hash = {}
          hash[:one].explode
        end
        def bad_var
          invalidvar
        end
      end
    end

    it 'raises an undefined method name error when calling a method on a non-existant object' do
      expect {
        req = mock('RequestWrapper', :request_proto => Test::ResourceFindRequest.new(:name => 'mmeh').to_s)
        ::NewTestService.new.bad_method(req)
      }.to raise_error(NoMethodError)
    end

    it 'raises a name error when accessing a non-existant object' do
      expect {
        req = mock('RequestWrapper', :request_proto => Test::ResourceFindRequest.new(:name => 'mmeh').to_s)
        ::NewTestService.new.bad_var(req)
      }.to raise_error(NameError)
    end

  end

end
