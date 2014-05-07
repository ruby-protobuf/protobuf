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

  describe "#decode_request" do
    let(:decode_event) { OpenStruct.new(
      :duration => 0.01,
      :payload => {
        'service_name' => 'Service',
        'method_name'  => 'method',
        'client_host'  => 'client.example.com'
      }
    ) }

    it "logs a received message" do
      logger.should_receive(:info) do |&block|
        block.call.should eq "[TID-123] Received Service#method from client.example.com"
      end

      subject.decode_request(decode_event)
    end

    it "skips logging during an exception" do
      logger.should_not_receive(:info)
      decode_event.payload[:exception] = ["BadThings", "happened in decoding"]
      subject.decode_request(decode_event)
    end
  end

  describe "#handle_reqeust" do
    let(:decode_event) { OpenStruct.new(:payload => { 'timing' => 'Decode: 10.0ms' }) }
    let(:dispatch_event) { OpenStruct.new(:payload => { 'timing' => 'Dispatch: 20.0ms' }) }
    let(:encode_event) { OpenStruct.new(:payload => { 'timing' => 'Encode: 30.0ms' }) }

    let(:request_event) { OpenStruct.new(
      :duration => 60.0,
      :payload  => { 'encoded_response' => 'f4594f2851267ba87b5e22f4013460df' },
      :children => [ decode_event, dispatch_event, encode_event ]
    ) }

    it "logs a completed message with timing information from all events" do
      logger.should_receive(:info) do |&block|
        block.call.should eq "[TID-123] Completed in 60.0ms (32 Bytes) (Decode: 10.0ms | Dispatch: 20.0ms | Encode: 30.0ms)"
      end

      subject.handle_request(request_event)
    end
  end
end
