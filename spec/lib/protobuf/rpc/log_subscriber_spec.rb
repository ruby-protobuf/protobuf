require 'spec_helper'
require 'securerandom'
require 'timecop'

describe ::Protobuf::Rpc::LogSubscriber do
  subject { described_class.new }

  let(:logger) { double('Logger') }
  let(:thread_id) { 'TID-123' }

  before do
    subject.stub(:thread_id) { thread_id }
    subject.stub(:logger) { logger }
  end

  def mock_event(name, duration=0, payload={})
    id = SecureRandom.hex(10)

    Timecop.freeze do
      subject.start(name, id, payload)

      Timecop.freeze(Time.now + duration) do
        yield if block_given?
        subject.finish(name, id, {})
      end
    end
  end

  it "prints a completed message with all the timings" do
    logger.should_receive(:info) do |&block|
      block.call.should eq "[TID-123] Completed in 60.0ms (5 Bytes) (Decode: 10.0ms | Dispatch: 20.0ms | Encode: 30.0ms)"
    end

    mock_event('handle_request.protobuf', 0.06, {'encoded_response' => '12345'}) do
      mock_event('decode_request', 0.01)
      mock_event('dispatch_request', 0.02)
      mock_event('encode_request', 0.03)
    end
  end
end
