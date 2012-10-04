require 'spec_helper'
require 'spec/support/test/resource_service'
require 'protobuf/rpc/servers/evented_runner'
require 'protobuf/evented'

describe Protobuf::Rpc::Evented::Server do

  it "provides a Runner class" do
    runner_class = described_class.to_s.gsub(/Evented::Server/, "EventedRunner")
    expect { runner_class.constantize }.to_not raise_error
  end

  it "Runner provides a stop method" do
    runner_class = described_class.to_s.gsub(/Evented::Server/, "EventedRunner").constantize
    runner_class.respond_to?(:stop).should be_true
  end

end
