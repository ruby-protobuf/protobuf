require 'spec_helper'

RSpec.describe Protobuf::Field::MessageField do
  let(:field_message) do
    Class.new(::Protobuf::Message) do
      optional :int32, :field, 1
    end
  end

  let(:message) do
    Class.new(::Protobuf::Message) do
      optional FieldMessage, :message_field, 1
    end
  end

  before do
    stub_const('FieldMessage', field_message)
    stub_const('Message', message)
  end

  let(:instance) { message.new }

  describe 'setting and getting field' do
    context "when set with the message type" do
      it 'is readable as a message' do
        value = field_message.new(:field => 34)
        instance.message_field = value
        expect(instance.message_field).to eq(value)
      end
    end

    context "when set with #to_proto" do
      let(:to_proto_message) do
        Class.new do
          def to_proto
            FieldMessage.new(:field => 42)
          end
        end
      end

      it 'is readable as a message' do
        value = to_proto_message.new
        instance.message_field = value
        expect(instance.message_field).to eq(value.to_proto)
      end
    end

    context "when set with #to_proto that returns the wrong message type" do
      let(:to_proto_is_wrong_message) do
        Class.new do
          def to_proto
            Message.new
          end
        end
      end

      it 'fails' do
        value = to_proto_is_wrong_message.new
        expect { instance.message_field = value }.to raise_error TypeError
      end
    end

    context "when set with #to_hash" do
      let(:to_hash_message) do
        Class.new do
          def to_hash
            { :field => 989 }
          end
        end
      end

      it 'is readable as a message' do
        value = to_hash_message.new
        instance.message_field = value
        expect(instance.message_field).to eq(field_message.new(value.to_hash))
      end
    end
  end
end
