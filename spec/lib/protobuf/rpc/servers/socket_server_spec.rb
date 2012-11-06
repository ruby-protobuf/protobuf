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
    server = OpenStruct.new(:server => "127.0.0.1", :port => 9399, :backlog => 100, :threshold => 100)
    @server_thread = Thread.new(server) { |s| Protobuf::Rpc::SocketRunner.run(s) }
    Thread.pass until Protobuf::Rpc::Socket::Server.running?
  end

  after(:all) do
    Protobuf::Rpc::SocketRunner.stop
    @server_thread.join
  end

  it "Runner provides a stop method" do
    runner_class = described_class.to_s.gsub(/Evented::Server/, "EventedRunner").constantize
    runner_class.respond_to?(:stop).should be_true
  end

  it "provides a stop method" do
    described_class.respond_to?(:stop).should be_true
  end

  it "provides a Runner class" do
    runner_class = described_class.to_s.gsub(/Evented::Server/, "EventedRunner")
    expect { runner_class.constantize }.to_not raise_error
  end

  it "signals the Server is running" do
    described_class.running?.should be_true
  end

end
