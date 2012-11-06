require 'spec_helper'
require 'spec/support/test/resource_service'

describe 'Functional Socket Client' do
  before(:all) do
    load "protobuf/socket.rb"
    Thread.abort_on_exception = true
    server = OpenStruct.new(:host => "127.0.0.1", :port => 9399, :backlog => 100, :threshold => 100)
    @server_thread = Thread.new(server) { |s| Protobuf::Rpc::SocketRunner.run(s) }
    Thread.pass until Protobuf::Rpc::Socket::Server.running?
  end

  after(:all) do
    Protobuf::Rpc::SocketRunner.stop
    @server_thread.join
  end

  it 'runs fine when required fields are set' do
    expect {
      client = ::Test::ResourceService.client

      client.find(:name => 'Test Name', :active => true) do |c|
        c.on_success do |succ|
          succ.name.should eq("Test Name")
          succ.status.should eq(::Test::StatusType::ENABLED)
        end

        c.on_failure do |err|
          raise err.inspect
        end
      end
    }.to_not raise_error
  end

  it 'calls the on_failure callback when a message is malformed' do
    error = nil
    request = ::Test::ResourceFindRequest.new(:active => true)
    client = ::Test::ResourceService.client

    client.find(request) do |c|
      c.on_success { raise "shouldn't pass"}
      c.on_failure {|e| error = e}
    end
    error.message.should =~ /ResourceFindRequest.*fields.*improperly set/
  end

  it 'calls the on_failure callback when the request type is wrong' do
    error = nil
    request = ::Test::Resource.new(:name => 'Test Name')
    client = ::Test::ResourceService.client

    client.find(request) do |c|
      c.on_success { raise "shouldn't pass"}
      c.on_failure {|e| error = e}
    end
    error.message.should =~ /expected request.*ResourceFindRequest.*Resource instead/i
  end
end
