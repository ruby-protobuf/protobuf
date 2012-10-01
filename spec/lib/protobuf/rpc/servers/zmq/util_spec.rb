require 'spec_helper'

class UtilTest
  include ::Protobuf::Rpc::Zmq::Util
end

describe ::Protobuf::Rpc::Zmq::Util do
  before(:each) do
    load 'protobuf/zmq.rb' 
    ::Protobuf::Rpc::Connector.connector_for_client(true)
  end

  subject { UtilTest.new }
  describe '#zmq_error_check' do
    it 'raises when the error code is less than 0' do
      expect {
        subject.zmq_error_check(-1)
      }.to raise_error
    end

    it 'retrieves the error string from ZeroMQ' do
      ZMQ::Util.stub(:error_string).and_return('an error from zmq')
      expect {
        subject.zmq_error_check(-1)
      }.to raise_error(RuntimeError, /an error from zmq/i)
    end

    it 'does nothing if the error code is > 0' do
      expect {
        subject.zmq_error_check(1)
      }.to_not raise_error
    end

    it 'does nothing if the error code is == 0' do
      expect {
        subject.zmq_error_check(0)
      }.to_not raise_error
    end
  end

  describe '#log_signature' do
    it 'returns the signature for the log' do
      subject.log_signature.should include('server', 'UtilTest')
    end
  end
end
