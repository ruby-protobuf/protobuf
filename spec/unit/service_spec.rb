require 'spec_helper'
require 'spec/proto/test_service_impl'

describe Protobuf::Rpc::Service do
  
  context 'when configuring' do
    before :each do
      reset_service_location Spec::Proto::TestService
    end
  
    it 'should have a default location configured' do
      Spec::Proto::TestService.host.should == Protobuf::Rpc::Service::DEFAULT_LOCATION[:host]
      Spec::Proto::TestService.port.should == Protobuf::Rpc::Service::DEFAULT_LOCATION[:port]
    end
  
    it "should be able to pre-configure a service location for clients" do
      Spec::Proto::TestService.located_at 'google.com:12345'
      client = Spec::Proto::TestService.client
      client.options[:host].should == 'google.com'
      client.options[:port].should == 12345
    end
  
    it 'should be able to configure and read the host' do
      Spec::Proto::TestService.configure :host => 'somehost.com'
      Spec::Proto::TestService.host.should == 'somehost.com'
    end
  
    it 'should be able to configure and read the port' do
      Spec::Proto::TestService.configure :port => 12345
      Spec::Proto::TestService.port.should == 12345
    end
  
    it 'should skip configuring location if the location passed does not match host:port syntax' do
      invalid_locations = [nil, 'myhost:', ':9939', 'badhost123']
      invalid_locations.each do |location|
        Spec::Proto::TestService.located_at location
        Spec::Proto::TestService.host.should == Protobuf::Rpc::Service::DEFAULT_LOCATION[:host]
        Spec::Proto::TestService.port.should == Protobuf::Rpc::Service::DEFAULT_LOCATION[:port]
      end
    end
  end
  
  context 'when server calls the service method' do
    
    before(:all) do
      class ::NewTestService < Protobuf::Rpc::Service
        rpc :bad_method, Spec::Proto::ResourceFindRequest, Spec::Proto::Resource
        rpc :bad_var, Spec::Proto::ResourceFindRequest, Spec::Proto::Resource
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
        req = mock('RequestWrapper', :request_proto => Spec::Proto::ResourceFindRequest.new.to_s)
        ::NewTestService.new.bad_method(req)
      }.to raise_error(NoMethodError)
    end
    
    it 'raises a name error when accessing a non-existant object' do
      expect {
        req = mock('RequestWrapper', :request_proto => Spec::Proto::ResourceFindRequest.new.to_s)
        ::NewTestService.new.bad_var(req)
      }.to raise_error(NameError)
    end
    
  end
  
end