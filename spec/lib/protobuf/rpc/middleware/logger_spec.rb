require 'spec_helper'

describe Protobuf::Rpc::Middleware::Logger do
  let(:app) { Proc.new { |env| env } }
  let(:env) { Protobuf::Rpc::Env.new }

  subject { described_class.new(app) }

  describe "#call" do
    it "calls the stack" do
      app.should_receive(:call).with(env)
      subject.call(env)
    end

    it "returns the env" do
      subject.call(env).should eq env
    end
  end
end
