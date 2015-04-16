require 'spec_helper'

RSpec.describe Protobuf::Field::FieldArray do

  class SomeBasicMessage < ::Protobuf::Message
    optional :string, :field, 1
  end

  class MoreComplexMessage < SomeBasicMessage
  end

  class OtherBasicMessage < ::Protobuf::Message
    optional :string, :other_field, 1
  end

  class SomeRepeatMessage < ::Protobuf::Message
    optional :string, :some_string, 1
    repeated :string, :multiple_strings, 2
    repeated SomeBasicMessage, :multiple_basic_msgs, 3
  end

  let(:instance) { SomeRepeatMessage.new }

  %w(<< push).each do |method|
    describe "\##{method}" do
      context 'when applied to a string field array' do
        it 'adds a string' do
          expect(instance.multiple_strings).to be_empty
          instance.multiple_strings.send(method, 'string 1')
          expect(instance.multiple_strings).to eq(['string 1'])
          instance.multiple_strings.send(method, 'string 2')
          expect(instance.multiple_strings).to eq(['string 1', 'string 2'])
        end

        it 'fails if not adding a string' do
          expect { instance.multiple_strings.send(method, 100.0) }.to raise_error(TypeError)
        end
      end

      context 'when applied to a MessageField field array' do
        it 'adds a MessageField object' do
          expect(instance.multiple_basic_msgs).to be_empty
          basic_msg1 = SomeBasicMessage.new
          instance.multiple_basic_msgs.send(method, basic_msg1)
          expect(instance.multiple_basic_msgs).to eq([basic_msg1])
          basic_msg2 = SomeBasicMessage.new
          instance.multiple_basic_msgs.send(method, basic_msg2)
          expect(instance.multiple_basic_msgs).to eq([basic_msg1, basic_msg2])
        end

        it 'adds a Hash from a MessageField object' do
          expect(instance.multiple_basic_msgs).to be_empty
          basic_msg1 = SomeBasicMessage.new
          basic_msg1.field = 'my value'
          instance.multiple_basic_msgs.send(method, basic_msg1.to_hash)
          expect(instance.multiple_basic_msgs).to eq([basic_msg1])
        end

        it 'does not downcast a MessageField' do
          expect(instance.multiple_basic_msgs).to be_empty
          basic_msg1 = MoreComplexMessage.new
          instance.multiple_basic_msgs.send(method, basic_msg1)
          expect(instance.multiple_basic_msgs).to eq([basic_msg1])
          expect(instance.multiple_basic_msgs.first).to be_a(MoreComplexMessage)
        end
      end
    end
  end
end
