require 'spec_helper'

# Decode writes a decoded value to the values hash of the message. It does not
# call coerce! or FieldArray#normalize, so these specs check that the result
# is the same as a message that the setters build.
RSpec.describe 'Decoding without the setters' do
  module DirectDecodeSpec
    class Color < ::Protobuf::Enum
      define :RED, 0
      define :GREEN, 1
    end

    class Inner < ::Protobuf::Message
      optional :int32, :id, 1
    end

    class Message < ::Protobuf::Message
      optional :int32, :i32, 1
      optional :int64, :i64, 2
      optional :uint64, :u64, 3
      optional :sint64, :s64, 4
      optional :bool, :b, 5
      optional :double, :dbl, 6
      optional :string, :str, 7
      optional :bytes, :blob, 8
      optional ::DirectDecodeSpec::Color, :color, 9
      optional ::DirectDecodeSpec::Inner, :inner, 10
      repeated :int32, :r_i32, 11
      repeated :uint64, :r_u64, 12
      repeated ::DirectDecodeSpec::Color, :r_color, 13
      repeated :string, :r_str, 14
      repeated ::DirectDecodeSpec::Inner, :r_inner, 15
      map :string, :int64, :counts, 16
    end

    class Fixed < ::Protobuf::Message
      optional :fixed32, :f32, 1
      repeated :fixed32, :r_f32, 2
      repeated :fixed32, :p_f32, 3, :packed => true
    end

    class Required < ::Protobuf::Message
      required :int32, :id, 1
      required ::DirectDecodeSpec::Color, :color, 2
    end
  end

  def tag(field, wire_type)
    ::Protobuf::Varint.encode((field << 3) | wire_type)
  end

  def varint(field, value)
    tag(field, ::Protobuf::WireType::VARINT) + ::Protobuf::Varint.encode(value)
  end

  def len(field, bytes)
    tag(field, ::Protobuf::WireType::LENGTH_DELIMITED) + ::Protobuf::Varint.encode(bytes.bytesize) + bytes
  end

  let(:message) do
    DirectDecodeSpec::Message.new(
      :i32 => -5, :i64 => -2**40, :u64 => 2**64 - 1, :s64 => -2**63, :b => true, :dbl => 1.5,
      :str => 'héllo', :blob => "\x00\xFF".b, :color => :GREEN, :inner => { :id => 3 },
      :r_i32 => [1, -2, 3], :r_u64 => [0, 2**64 - 1], :r_color => [:RED, :GREEN],
      :r_str => %w[a b], :r_inner => [{ :id => 1 }, { :id => 2 }], :counts => { 'x' => -1 }
    )
  end

  let(:decoded) { DirectDecodeSpec::Message.decode(message.encode) }

  it 'gives the same message as the setters' do
    expect(decoded).to eq(message)
    expect(decoded.to_hash).to eq(message.to_hash)
    expect(decoded.encode).to eq(message.encode)
  end

  it 'gives values of the same classes as the setters' do
    expect(decoded.color).to be_a(DirectDecodeSpec::Color)
    expect(decoded.r_color).to all(be_a(DirectDecodeSpec::Color))
    expect(decoded.inner).to be_a(DirectDecodeSpec::Inner)
    expect(decoded.r_i32).to be_a(::Protobuf::Field::FieldArray)
    expect(decoded.str.encoding).to eq(Encoding::UTF_8)
    expect(decoded.blob.encoding).to eq(Encoding::BINARY)
  end

  it 'normalizes values that are added to a decoded repeated field' do
    decoded.r_color << 1
    decoded.r_inner << { :id => 9 }

    expect(decoded.r_color.last).to be_a(DirectDecodeSpec::Color)
    expect(decoded.r_inner.last).to eq(DirectDecodeSpec::Inner.new(:id => 9))
  end

  describe 'an enum tag that the enum does not define' do
    it 'leaves a singular field unset' do
      decoded = DirectDecodeSpec::Message.decode(varint(9, 7))
      expect(decoded.field?(:color)).to be(false)
    end

    # proto2 spec: a closed enum keeps the value from an earlier record.
    it 'keeps the value that an earlier record set' do
      decoded = DirectDecodeSpec::Message.decode(varint(9, 1) + varint(9, 7))
      expect(decoded.color).to eq(DirectDecodeSpec::Color::GREEN)
    end

    it 'keeps the low 32 bits of a wider varint' do
      decoded = DirectDecodeSpec::Message.decode(varint(9, 0x1_0000_0001))
      expect(decoded.color).to eq(DirectDecodeSpec::Color::GREEN)
    end

    it 'is not added to a repeated field' do
      decoded = DirectDecodeSpec::Message.decode(varint(13, 1) + varint(13, 7) + len(13, "\x07\x00".b))
      expect(decoded.r_color.map(&:to_i)).to eq([1, 0])
    end
  end

  describe 'required fields' do
    it 'can encode a message after decode sets all required fields' do
      bytes = DirectDecodeSpec::Required.new(:id => 1, :color => :GREEN).encode
      expect(DirectDecodeSpec::Required.decode(bytes).encode).to eq(bytes)
    end

    it 'cannot encode a message that is missing a required field' do
      decoded = DirectDecodeSpec::Required.decode(varint(1, 1))
      expect { decoded.encode }.to raise_error(::Protobuf::SerializationError)
    end

    it 'counts a required enum field with only an undefined tag as missing' do
      decoded = DirectDecodeSpec::Required.decode(varint(1, 1) + varint(2, 7))
      expect { decoded.encode }.to raise_error(::Protobuf::SerializationError, /color/)
    end

    it 'keeps a required enum field that an earlier record set' do
      decoded = DirectDecodeSpec::Required.decode(varint(1, 1) + varint(2, 1) + varint(2, 7))
      expect(decoded.encode).to eq(varint(1, 1) + varint(2, 1))
    end
  end

  # A fixed32 record with fewer than 4 bytes decodes to nil. Decode leaves the
  # field unset, as the setters do.
  describe 'a truncated fixed32 record' do
    def fixed32(field, bytes)
      tag(field, ::Protobuf::WireType::FIXED32) + bytes
    end

    it 'leaves a singular field unset' do
      decoded = DirectDecodeSpec::Fixed.decode(fixed32(1, "\x01\x02".b))
      expect(decoded.field?(:f32)).to be(false)
    end

    it 'adds nothing to a repeated field' do
      decoded = DirectDecodeSpec::Fixed.decode(fixed32(2, "\x01\x02".b))
      expect(decoded.r_f32).to eq([])
    end

    it 'adds only the whole values of a packed field' do
      decoded = DirectDecodeSpec::Fixed.decode(len(3, "\x01\x00\x00\x00\x02\x00".b))
      expect(decoded.p_f32).to eq([1])
    end
  end

  # A varint can hold up to 70 bits. VarintPure decodes all of them. A 64-bit
  # field cannot hold such a value, so decode raises TypeError, as the setters
  # do. The C varint gem keeps only the low 64 bits, so it does not raise.
  describe 'a varint wider than 64 bits' do
    let(:wide) { 2**70 - 1 }

    it 'raises for a singular 64-bit field' do
      skip 'the C varint gem keeps only 64 bits' if defined?(::Varint)
      expect { DirectDecodeSpec::Message.decode(varint(3, wide)) }.to raise_error(TypeError)
    end

    it 'raises for a repeated 64-bit field' do
      skip 'the C varint gem keeps only 64 bits' if defined?(::Varint)
      expect { DirectDecodeSpec::Message.decode(varint(12, wide)) }.to raise_error(TypeError)
    end

    it 'keeps the low 32 bits for an int32 field' do
      expect(DirectDecodeSpec::Message.decode(varint(1, wide)).i32).to eq(-1)
    end
  end
end
