require 'spec_helper'
require 'stringio'

describe ::Protobuf::LogSubscriber do
  let(:event_start) { Time.now }
  let(:event_end) { event_start + 0.1 }
  let(:transaction_id) { 'transaction id' }
  let(:payload) { {
    :client_host      => 'client',
    :encoded_request  => 'ha',
    :encoded_response => 'blargh',
    :response         => 'response',
  } }

  let(:event) { ::ActiveSupport::Notifications::Event.new(
    event_name, event_start, event_end, transaction_id, payload
  )}

  let(:mock_logger) {
    ::Logger.new('/dev/null').tap { |l| l.level = ::Logger::DEBUG }
  }

  before do
    @old_logger = ::Protobuf::LogSubscriber.logger
    ::Protobuf::LogSubscriber.logger = mock_logger
  end

  after do
    described_class.new.handle_request(event)
   ::Protobuf::LogSubscriber.logger  = @old_logger
  end

  describe '#handle_request' do
    let(:event_name) { 'handle_request.protobuf' }

    it 'logs successful requests' do
      mock_logger.should_receive(:info).with(
        "OK client=client i/o=2B/6B"
      )
    end

    it 'logs failed requests' do
      payload[:response] = ::Protobuf::Rpc::RpcFailed.new
      mock_logger.should_receive(:info).with(
        "FAILED (RPC failed) client=client i/o=2B/6B"
      )
    end
  end
end
