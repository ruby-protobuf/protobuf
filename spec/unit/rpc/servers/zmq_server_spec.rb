require 'spec_helper'
require 'protobuf/rpc/servers/zmq/server'

describe Protobuf::Rpc::Zmq::Server do
  it 'functions' do
    StubServer.new(:port => 9399, :server => Protobuf::Rpc::Zmq::Server) do |server|
      with_constants "Protobuf::ClientType" => "Zmq" do
        client = Spec::Proto::TestService.client(:async => false, :port => 9399)
        client.find(:name => "Test Name", :active => true)
      end
      server.stop
    end
  end
end
