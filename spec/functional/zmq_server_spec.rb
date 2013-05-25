require 'spec_helper'
require 'spec/support/test/resource_service'

describe 'Functional ZMQ Client' do
  let(:options) {{
    :host => "127.0.0.1",
    :port => 9399,
    :worker_port => 9400,
    :backlog => 100,
    :threshold => 100,
    :threads => 5,
    :dynamic_discovery => true,
    :beacon_port => 9398
  }}

  let(:server) { ::Protobuf::Rpc::Zmq::Server.new(options) }
  let(:server_thread) { Thread.new(server) { |server| server.run } }

  before do
    load "protobuf/zmq.rb"
    server_thread.abort_on_exception = true
    Thread.pass until server.running?
  end

  after do
    server.stop
    server_thread.join
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
    error.message.should =~ /name.*required/
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
