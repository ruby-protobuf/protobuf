require 'spec_helper'

RSpec.describe Protobuf::Field::VarintField do
  describe '.encode' do
    limit = described_class::ENCODE_CACHE_LIMIT

    [0, 1, 127, 128, limit - 1, limit, 2**32 - 1, 2**64 - 1].each do |value|
      it "encodes #{value} the same as Protobuf::Varint" do
        expect(described_class.encode(value)).to eq(::Protobuf::Varint.encode(value))
      end
    end

    it 'returns one frozen binary string for a value below the cache limit' do
      encoded = described_class.encode(300)

      expect(encoded).to be_frozen
      expect(encoded.encoding).to eq(Encoding::BINARY)
      expect(described_class.encode(300)).to equal(encoded)
    end

    it 'returns a new string for a value at or above the cache limit' do
      expect(described_class.encode(limit)).not_to be_frozen
      expect(described_class.encode(limit)).not_to equal(described_class.encode(limit))
    end
  end

  # Each of these appends after the varint length. They must not change the
  # cached length string.
  describe 'length-delimited encode' do
    let(:inner) do
      Class.new(::Protobuf::Message) do
        optional :string, :name, 1
      end
    end

    let(:outer) do
      inner_class = inner
      Class.new(::Protobuf::Message) do
        optional inner_class, :inner, 1
        optional :string, :text, 2
        optional :bytes, :blob, 3
        repeated :int32, :packed_nums, 4, :packed => true
      end
    end

    it 'leaves the cached length strings unchanged' do
      cached = (0...16).map { |size| described_class.encode(size).dup }

      outer.new(:inner => { :name => 'abc' }, :text => 'hello', :blob => "\x00\x01".b, :packed_nums => [1, 2, 3]).encode
      outer.field_store[:inner].encode(inner.new(:name => 'abc'))
      outer.field_store[:text].encode('hello')
      outer.field_store[:blob].encode("\x00\x01".b)

      expect((0...16).map { |size| described_class.encode(size) }).to eq(cached)
    end
  end
end
