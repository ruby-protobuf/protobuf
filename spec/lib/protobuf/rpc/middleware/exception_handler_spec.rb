require 'spec_helper'

describe Protobuf::Rpc::Middleware::ExceptionHandler do
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

    context "when exceptions occur" do
      let(:error) { Protobuf::Rpc::MethodNotFound.new('Boom!') }

      before { app.stub(:call).and_raise(error, 'Boom!') }

      it "rescues exceptions" do
        expect { subject.call(env) }.not_to raise_exception
      end

      context "when exception is a Protobuf error" do
        let(:error) { Protobuf::Rpc::MethodNotFound.new('Boom!') }

        before { app.stub(:call).and_raise(error) }

        it "does not wrap the exception in a generic Protobuf error" do
          stack_env = subject.call(env)
          stack_env.response.should eq error
        end
      end

      context "when exception is not a Protobuf error" do
        let(:error) { Protobuf::Rpc::PbError.new('Boom!') }

        before { app.stub(:call).and_raise(RuntimeError, 'Boom!') }

        it "wraps the exception in a generic Protobuf error" do
          stack_env = subject.call(env)
          stack_env.response.should eq error
        end
      end
    end
  end
end
