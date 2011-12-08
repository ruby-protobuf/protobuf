require 'spec_helper'
require 'spec/proto/test_service_impl'
require 'protobuf/rpc/servers/socket_runner'

describe Protobuf::Rpc::SocketServer do
  before(:all) do 
    server = OpenStruct.new(:server => "127.0.0.1", :port => 9399)
    Thread.new { Protobuf::Rpc::SocketRunner.run(server) }
    sleep 0.5 # TODO figure out how to do this without sleep (Thread.pass didn't work either...hmmmm)
  end

  after(:all) do 
    sleep 2
    Protobuf::Rpc::SocketRunner.stop
  end

  it "provides a stop method" do
    described_class.respond_to?(:stop).should be_true
  end

  it "provides a Runner class" do 
    runner_class = described_class.to_s.gsub(/Server/, "Runner")
    expect { Protobuf::Util.constantize(runner_class) }.to_not raise_error     
  end

  it "signals the Server is running" do 
    Protobuf::Rpc::SocketServer.running?.should be_true
  end

  context "Eventmachine client" do 

    it "calls the service in the client request" do 
      with_constants "Protobuf::ConnectorType" => "Evented" do
        client = Spec::Proto::TestService.client(:async => false, :port => 9939, :host => "127.0.0.1")

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
