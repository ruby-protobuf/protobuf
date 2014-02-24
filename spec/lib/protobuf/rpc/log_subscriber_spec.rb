require 'spec_helper'
require 'securerandom'

describe ::Protobuf::Rpc::LogSubscriber do
  subject { described_class.new }

  let(:logger) { double('Logger') }
  let(:thread_id) { 'TID-123' }

  before do
    subject.stub(:thread_id) { thread_id }
    subject.stub(:logger) { logger }
  end

  def mock_event(name, duration=0)
    id = SecureRandom.hex(10)
    payload = {}

    subject.start(name, id, payload)
    sleep(duration) if duration > 0
    yield if block_given?
    subject.finish(name, id, payload)
  end

  it "prints a completed message with all the timings" do
    logger.should_receive(:info) do |&block|
      block.call.should match /\[TID-123\] Completed in 60\.\dms \(Decode: 10\.\dms | Dispatch: 20\.\dms | Encode: 30\.\dms\)/
    end

    mock_event('handle_request.protobuf') do
      mock_event('decode_request', 0.01)
      mock_event('dispatch_request', 0.02)
      mock_event('encode_request', 0.03)
    end
  end
end
