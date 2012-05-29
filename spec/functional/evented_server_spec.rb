require 'spec_helper'
require 'spec/proto/test_service_impl'

describe 'Functional EventMachine Client' do
  before(:each) do
    ::Spec::Proto::TestService.configure(::Spec::Proto::TestService::DEFAULT_LOCATION)
  end

  it 'runs fine when required fields are set' do
    expect {
      EventMachine.fiber_run do
        StubServer.new do |server|
          client = ::Spec::Proto::TestService.client(:async => false, :timeout => 5)

          client.find(:name => 'Test Name', :active => true) do |c|
            c.on_success do |succ|
              succ.name.should eq("Test Name")
              succ.status.should eq(::Spec::Proto::StatusType::ENABLED)
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
        request = ::Spec::Proto::ResourceFindRequest.new(:active => true)
        client = ::Spec::Proto::TestService.client(:async => false)

        client.find(request) do |c|
          c.on_success { raise "shouldn't pass"}
          c.on_failure {|e| error = e}
        end
      end
      EM.stop
    end
    error.message.should =~ /ResourceFindRequest.*fields.*improperly set.*"name"/
  end

  it 'calls the on_failure callback when the request type is wrong' do
    error = nil
    EventMachine.fiber_run do
      StubServer.new do |server|
        request = ::Spec::Proto::Resource.new(:name => 'Test Name')
        client = ::Spec::Proto::TestService.client(:async => false)

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
