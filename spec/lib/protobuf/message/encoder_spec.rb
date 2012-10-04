require 'spec_helper'

class EncoderTest
  extend ::Protobuf::Encoder
end

describe Protobuf::Encoder do
  describe '#encode' do
    context "when there's no value for a required field" do
      let(:message) { ::Test::Resource.new }
      let(:stream) { StringIO.new }
      it "raises a 'message not initialized' error" do
        expect {
          EncoderTest.__send__(:encode, stream, message)
        }.to raise_error(Protobuf::NotInitializedError, /message.*not initialized/i)
      end
    end
  end
end
