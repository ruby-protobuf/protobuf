require 'spec_helper'

# Input that other protobuf implementations decode, but that made this gem
# raise for the whole message.
RSpec.describe 'Decoding input from other protobuf implementations' do
  module WireCompatDecodingSpec
    class Message < ::Protobuf::Message
      optional :int32, :i32, 1
      optional :uint32, :u32, 2
      optional :sint32, :s32, 3
      repeated :int32, :r_i32, 4
      optional :int64, :i64, 5
      optional :string, :str, 15
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

  def decode(bytes)
    WireCompatDecodingSpec::Message.decode(bytes.b)
  end

  # The language guide calls int32, uint32, int64, and uint64 compatible: a
  # parser keeps the low 32 bits, as in a C++ cast.
  describe 'a 32-bit field that gets a wider varint' do
    it 'keeps the low 32 bits of an int32' do
      expect(decode(varint(1, 0xffff_ffff)).i32).to eq(-1)
      expect(decode(varint(1, 0x1_0000_0005)).i32).to eq(5)
      expect(decode(varint(1, 0xffff_ffff_8000_0000)).i32).to eq(-2_147_483_648)
    end

    it 'keeps the low 32 bits of a uint32' do
      expect(decode(varint(2, 0x1_0000_0001)).u32).to eq(1)
    end

    it 'keeps the low 32 bits of a sint32 before the zigzag decode' do
      # zigzag(-2) is 3; the bits above 32 are dropped.
      expect(decode(varint(3, 0x4_0000_0003)).s32).to eq(-2)
    end

    it 'keeps the low 32 bits in a packed run' do
      run = ::Protobuf::Varint.encode(0x1_0000_0007) + ::Protobuf::Varint.encode(1)
      expect(decode(len(4, run)).r_i32.to_a).to eq([7, 1])
    end

    it 'decodes the other fields of the message' do
      message = decode(varint(1, 0x1_0000_0005) + len(15, 'ok'))
      expect([message.i32, message.str]).to eq([5, 'ok'])
    end

    it 'does not change values in range' do
      message = WireCompatDecodingSpec::Message.new(
        :i32 => -2_147_483_648, :u32 => 4_294_967_295, :s32 => -7, :r_i32 => [-1, 2_147_483_647], :i64 => -2**40,
      )
      expect(WireCompatDecodingSpec::Message.decode(message.encode)).to eq(message)
    end
  end
end
