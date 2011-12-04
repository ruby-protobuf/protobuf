require 'spec_helper'
require 'spec/proto/test_service_impl'
require 'protobuf/rpc/servers/socket_runner'

describe Protobuf::Rpc::SocketServer do
  before(:all) do 
    server = OpenStruct.new(:server => "127.0.0.1", :port => 9399)
    Thread.new { Protobuf::Rpc::SocketRunner.run(server) }
    Thread.pass # Pass control to the SocketRunner thread to let it startup
  end

  after(:all) do 
    Protobuf::Rpc::SocketRunner.stop
  end

  it "signals the SocketServer is running" do 
    Protobuf::Rpc::SocketServer.running?.should be_true
  end

  it "calls the service in the client request" do 
    client = Spec::Proto::TestService.client(:async => false)

    client.find(:name => "Test Name", :active => true) do |c|
      c.on_success do |succ|
        succ.name.should eq("Test Name")
        succ.status.should eq(Spec::Proto::StatusType::Enabled)
      end

      c.on_failure do |err|
        raise err.inspect
      end
    end
  end

  context 'when sending response objects' do
    it 'should be able to send a hash object as a response' do
      server = Protobuf::Rpc::SocketServer.new

      # Setup the right mocks
      server.instance_variable_set(:@klass, Spec::Proto::TestService)
      response_wrapper = mock('response')
      response_wrapper.stub(:response_proto=)
      server.instance_variable_set(:@response, response_wrapper)
      Spec::Proto::TestService.stub_chain(:rpcs, :[], :[], :response_type).and_return(Spec::Proto::ResourceFindRequest)
     
      # Setup expectations
      hash_response = {:name => 'Test Name', :active => false}
      expected = Spec::Proto::ResourceFindRequest.new(hash_response)
      Spec::Proto::ResourceFindRequest.should_receive(:new).with(hash_response).and_return(expected)
      server.should_not_receive(:handle_error)
      
      # Call the method
      server.send(:parse_response_from_service, hash_response)
    end
  end
end
