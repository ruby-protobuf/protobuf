require 'spec_helper'
require 'spec/support/test/resource_service'
require 'protobuf/rpc/servers/socket_runner'
require 'protobuf/evented'
require 'protobuf/socket'

describe Protobuf::Rpc::Socket::Server do
  before(:each) do
    load 'protobuf/socket.rb'
  end

  before(:all) do
    load 'protobuf/socket.rb'
    Thread.abort_on_exception = true
    @options = OpenStruct.new(:host => "127.0.0.1", :port => 9399, :backlog => 100, :threshold => 100)
    @runner = ::Protobuf::Rpc::SocketRunner.new(@options)
    @server = @runner.instance_variable_get(:@server)
    @server_thread = Thread.new(@runner) { |runner| runner.run }
    Thread.pass until @server.running?
  end

  after(:all) do
    @server.stop
    @server_thread.join
  end

  it "Runner provides a stop method" do
    @runner.should respond_to(:stop)
  end

  it "provides a stop method" do
    @server.should respond_to(:stop)
  end

  it "provides a Runner class" do
    runner_class = described_class.to_s.gsub(/Evented::Server/, "EventedRunner")
    expect { runner_class.constantize }.to_not raise_error
  end

  it "signals the Server is running" do
    @server.should be_running
  end

end
