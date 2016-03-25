require 'spec_helper'

RSpec.describe Protobuf::Field::EnumField do
  let(:message) do
    Class.new(::Protobuf::Message) do
      enum_class = Class.new(::Protobuf::Enum) do
        define :POSITIVE, 22
        define :NEGATIVE, -33
      end

      optional enum_class, :enum, 1
    end
  end

  describe '.{encode, decode}' do
    it 'handles positive enum constants' do
      instance = message.new(:enum => :POSITIVE)
      expect(message.decode(instance.encode).enum).to eq(22)
    end

    it 'handles negative enum constants' do
      instance = message.new(:enum => :NEGATIVE)
      expect(message.decode(instance.encode).enum).to eq(-33)
    end
  end
end
