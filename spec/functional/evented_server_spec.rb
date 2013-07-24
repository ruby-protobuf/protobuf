require 'spec_helper'
require 'spec/support/test/resource.pb'

describe 'Functional EventMachine Client' do
  before(:each) do
    load 'protobuf/evented.rb'
  end

  it 'runs fine when required fields are set' do
    expect {
      EventMachine.fiber_run do
        StubServer.new do |server|
          client = ::Test::ResourceService.client(:timeout => 5)

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
        EM.stop
      end
    }.to_not raise_error
  end

  it 'calls the on_failure callback when a message is malformed' do
    error = nil
    EventMachine.fiber_run do
      StubServer.new do |server|
        request = ::Test::ResourceFindRequest.new(:active => true)
        client = ::Test::ResourceService.client

        client.find(request) do |c|
          c.on_success { raise "shouldn't pass"}
          c.on_failure {|e| error = e}
        end
      end
      EM.stop
    end
    error.message.should =~ /name.*required/
  end

  it 'calls the on_failure callback when the request type is wrong' do
    error = nil
    EventMachine.fiber_run do
      StubServer.new do |server|
        request = ::Test::Resource.new(:name => 'Test Name')
        client = ::Test::ResourceService.client

        client.find(request) do |c|
          c.on_success { raise "shouldn't pass"}
          c.on_failure {|e| error = e}
        end
      end
      EM.stop
    end
    error.message.should =~ /expected request.*ResourceFindRequest.*Resource instead/i
  end
end
