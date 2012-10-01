require 'spec_helper'
require 'spec/proto/test_service_impl'

describe 'Functional Socket Client' do
  before(:all) do
    load "protobuf/socket.rb"
    ::Protobuf::Rpc::Connector.connector_for_client(true)
    Thread.abort_on_exception = true
    server = OpenStruct.new(:server => "127.0.0.1", :port => 9399, :backlog => 100, :threshold => 100)
    @server_thread = Thread.new(server) { |s| Protobuf::Rpc::SocketRunner.run(s) }
    Thread.pass until Protobuf::Rpc::Socket::Server.running?
  end

  after(:all) do
    Protobuf::Rpc::SocketRunner.stop
    @server_thread.join
  end

  it 'runs fine when required fields are set' do
    expect {
      client = ::Spec::Proto::TestService.client(:async => false)

      client.find(:name => 'Test Name', :active => true) do |c|
        c.on_success do |succ|
          succ.name.should eq("Test Name")
          succ.status.should eq(::Spec::Proto::StatusType::ENABLED)
        end

        c.on_failure do |err|
          raise err.inspect
        end
      end
    }.to_not raise_error
  end

  it 'calls the on_failure callback when a message is malformed' do
    error = nil
    request = ::Spec::Proto::ResourceFindRequest.new(:active => true)
    client = ::Spec::Proto::TestService.client(:async => false)

    client.find(request) do |c|
      c.on_success { raise "shouldn't pass"}
      c.on_failure {|e| error = e}
    end
    error.message.should =~ /ResourceFindRequest.*fields.*improperly set.*"name"/
  end

  it 'calls the on_failure callback when the request type is wrong' do
    error = nil
    request = ::Spec::Proto::Resource.new(:name => 'Test Name')
    client = ::Spec::Proto::TestService.client(:async => false)

    client.find(request) do |c|
      c.on_success { raise "shouldn't pass"}
      c.on_failure {|e| error = e}
    end
    error.message.should =~ /expected request.*ResourceFindRequest.*Resource instead/i
  end
end
