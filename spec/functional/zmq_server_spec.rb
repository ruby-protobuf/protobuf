require 'spec_helper'
require 'spec/support/test/resource_service'

describe 'Functional ZMQ Client' do
  before(:all) do
    load "protobuf/zmq.rb"
  end

  it 'runs fine when required fields are set' do
    expect {
      StubServer.new(:server => Protobuf::Rpc::Zmq::Server) do
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
      end
    }.to_not raise_error
  end

  it 'calls the on_failure callback when a message is malformed' do
    error = nil
    StubServer.new(:server => Protobuf::Rpc::Zmq::Server) do
      request = ::Test::ResourceFindRequest.new(:active => true)
      client = ::Test::ResourceService.client

      client.find(request) do |c|
        c.on_success { raise "shouldn't pass" }
        c.on_failure {|e| error = e }
      end
    end
    error.message.should =~ /name.*required/
  end

  it 'calls the on_failure callback when the request type is wrong' do
    error = nil
    StubServer.new(:server => Protobuf::Rpc::Zmq::Server) do
      request = ::Test::Resource.new(:name => 'Test Name')
      client = ::Test::ResourceService.client

      client.find(request) do |c|
        c.on_success { raise "shouldn't pass" }
        c.on_failure {|e| error = e}
      end
    end
    error.message.should =~ /expected request.*ResourceFindRequest.*Resource instead/i
  end
end
