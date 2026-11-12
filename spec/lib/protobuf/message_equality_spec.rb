require 'spec_helper'

RSpec.describe 'Protobuf::Message equality' do
  module MessageEqualitySpec
    class Color < ::Protobuf::Enum
      define :RED, 0
      define :GREEN, 1
    end

    class Inner < ::Protobuf::Message
      optional :int32, :id, 1
    end

    class Message < ::Protobuf::Message
      optional :int32, :id, 1
      optional :string, :name, 2
      optional :bool, :active, 3
      optional :double, :score, 4
      optional ::MessageEqualitySpec::Color, :color, 5
      optional ::MessageEqualitySpec::Inner, :inner, 6
      repeated :int32, :ids, 7
      repeated ::MessageEqualitySpec::Inner, :inners, 8
      map :string, :int32, :counts, 9
    end

    class Other < ::Protobuf::Message
      optional :int32, :id, 1
    end

    class Child < Message; end
  end

  let(:fields) do
    {
      :id => 5, :name => 'x', :active => true, :score => 1.5, :color => :GREEN,
      :inner => { :id => 1 }, :ids => [1, 2], :inners => [{ :id => 2 }], :counts => { 'a' => 1 }
    }
  end
  let(:message) { MessageEqualitySpec::Message.new(fields) }
  let(:same) { MessageEqualitySpec::Message.new(fields) }

  def expect_same_key(first, second)
    expect(first).to eq(second)
    expect(first).to eql(second)
    expect(first.hash).to eq(second.hash)
    expect([first, second].uniq.size).to eq(1)
    expect({ first => :found }[second]).to eq(:found)
  end

  def expect_different_key(first, second)
    expect(first).not_to eql(second)
    expect([first, second].uniq.size).to eq(2)
    expect({ first => :found }[second]).to be_nil
  end

  it 'makes messages with equal values the same Hash key' do
    expect_same_key(message, same)
  end

  it 'makes a decoded message the same Hash key as the original' do
    expect_same_key(message, MessageEqualitySpec::Message.decode(message.encode))
  end

  it 'makes messages with different values different Hash keys' do
    expect_different_key(message, MessageEqualitySpec::Message.new(fields.merge(:id => 6)))
    expect_different_key(message, MessageEqualitySpec::Message.new(fields.merge(:ids => [2, 1])))
    expect_different_key(message, MessageEqualitySpec::Message.new(fields.merge(:inner => { :id => 9 })))
    expect_different_key(message, MessageEqualitySpec::Message.new(fields.merge(:counts => { 'a' => 2 })))
  end

  # == compares an unset field as its default value, so hash must too.
  it 'makes an unset field the same Hash key as a field set to its default' do
    defaults = MessageEqualitySpec::Message.new(
      :id => 0, :name => '', :active => false, :score => 0.0, :color => :RED, :ids => [], :counts => {},
    )
    expect_same_key(MessageEqualitySpec::Message.new, defaults)
  end

  it 'makes an enum set by tag the same Hash key as one set by name' do
    expect_same_key(MessageEqualitySpec::Message.new(:color => 1), MessageEqualitySpec::Message.new(:color => :GREEN))
  end

  it 'makes an unset message field a different key from an empty message' do
    expect_different_key(MessageEqualitySpec::Message.new, MessageEqualitySpec::Message.new(:inner => {}))
  end

  it 'makes messages of different classes different Hash keys' do
    expect_different_key(MessageEqualitySpec::Other.new(:id => 1), MessageEqualitySpec::Message.new(:id => 1))
  end

  # == accepts a subclass instance on the right side only. eql? must be
  # symmetric, so it requires the same class.
  it 'is not eql? for a subclass instance on either side' do
    parent = MessageEqualitySpec::Message.new(:id => 1)
    child = MessageEqualitySpec::Child.new(:id => 1)

    expect(parent).not_to eql(child)
    expect(child).not_to eql(parent)
  end

  it 'does not add empty repeated or map fields to the message' do
    a = MessageEqualitySpec::Message.new
    b = MessageEqualitySpec::Message.new

    expect(a).to eq(b)
    a.hash
    [a, b].uniq
    { a => true }[b]

    expect(a.to_hash).to eq({})
    expect(a.to_json).to eq('{}')
  end

  it 'gives a new hash after the message changes' do
    before = message.hash
    message.ids << 3

    expect(message.hash).not_to eq(before)
    expect(message).not_to eql(same)
  end
end
