require 'spec_helper'
require 'protobuf/rpc/servers/zmq_server'

describe Protobuf::Rpc::ZmqServer do
  it 'functions' do
    StubServer.new(:port => 9399, :server => Protobuf::Rpc::ZmqServer) do |server|
      with_constants "Protobuf::ClientType" => "Zmq" do
        client = Spec::Proto::TestService.client(:async => false, :port => 9399)
        client.find(:name => "Test Name", :active => true)
      end
      server.stop
    end
  end
end
