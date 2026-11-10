require 'spec_helper'

RSpec.describe 'Encoding packed repeated fields' do
  module PackedEncodingSpec
    class Packed < ::Protobuf::Message
      repeated :int32, :ints, 1, :packed => true
      repeated :double, :dbls, 2, :packed => true
    end
  end

  let(:message_class) { ::PackedEncodingSpec::Packed }

  it 'writes one record with the byte length of the values' do
    expect(message_class.new(:ints => [1, 300]).encode).to eq "\x0A\x03\x01\xAC\x02".b
  end

  it 'writes no record for an empty field' do
    expect(message_class.new.encode).to eq ''.b
  end

  it 'writes no record for a field that was only read' do
    message = message_class.new(:ints => [1])
    message.dbls
    message.inspect

    expect(message.encode).to eq "\x0A\x01\x01".b
  end

  it 'writes no record for a field that was cleared' do
    message = message_class.new(:ints => [1], :dbls => [1.5])
    message.dbls.clear

    expect(message.encode).to eq "\x0A\x01\x01".b
  end
end
