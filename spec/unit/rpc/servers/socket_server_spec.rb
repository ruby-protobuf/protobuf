require 'spec_helper'
require 'spec/proto/test_service_impl'
require 'protobuf/rpc/servers/socket_runner'

describe Protobuf::Rpc::SocketServer do
  before(:all) do 
    Thread.abort_on_exception = true
    server = OpenStruct.new(:server => "127.0.0.1", :port => 9399, :backlog => 100, :threshold => 100)
    @server_thread = Thread.new(server) { |s| Protobuf::Rpc::SocketRunner.run(s) }
    Thread.pass until Protobuf::Rpc::SocketServer.running?
  end

  after(:all) do 
    Protobuf::Rpc::SocketRunner.stop
    Thread.kill(@server_thread)
  end

  it "Runner provides a stop method" do
    runner_class = described_class.to_s.gsub(/Server/, "Runner")
    runner_class = Protobuf::Util.constantize(runner_class)
    runner_class.respond_to?(:stop).should be_true
  end

  it "provides a stop method" do
    described_class.respond_to?(:stop).should be_true
  end

  it "provides a Runner class" do 
    runner_class = described_class.to_s.gsub(/Server/, "Runner")
    expect { Protobuf::Util.constantize(runner_class) }.to_not raise_error     
  end

  it "signals the Server is running" do 
    described_class.running?.should be_true
  end

  context "Eventmachine client" do 
    it "calls the service in the client request" do 
      with_constants "Protobuf::ClientType" => "Evented" do
        client = Spec::Proto::TestService.client(:async => false, :port => 9399, :host => "127.0.0.1")

        client.find(:name => "Test Name", :active => true) do |c|
          c.on_success do |succ|
            succ.name.should eq("Test Name")
            succ.status.should eq(Spec::Proto::StatusType::ENABLED)
          end

          c.on_failure do |err|
            raise err.inspect
          end
        end
      end
    end
    
  end

end
