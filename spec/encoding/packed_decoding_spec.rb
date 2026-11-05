require 'spec_helper'

# The protobuf spec: "Protobuf parsers must be able to parse repeated fields
# that were compiled as packed as if they were not packed, and vice versa."
# https://protobuf.dev/programming-guides/encoding/#packed
#
# proto3 encoders (Go, Java, C++, google-protobuf) pack repeated scalars by
# default, so these fields must decode packed input although they do not
# declare `packed`.
RSpec.describe 'Decoding packed and unpacked repeated scalar fields' do
  module PackedDecodingSpec
    class Color < ::Protobuf::Enum
      define :RED, 0
      define :GREEN, 1
      define :BLUE, 2
    end

    class Unpacked < ::Protobuf::Message
      optional :string, :name, 15
      repeated :int32, :r_i32, 21
      repeated :int64, :r_i64, 22
      repeated :uint32, :r_u32, 23
      repeated :uint64, :r_u64, 24
      repeated :sint32, :r_s32, 25
      repeated :sint64, :r_s64, 26
      repeated :bool, :r_b, 27
      repeated ::PackedDecodingSpec::Color, :r_color, 28
      repeated :fixed32, :r_f32, 29
      repeated :fixed64, :r_f64, 30
      repeated :sfixed32, :r_sf32, 31
      repeated :sfixed64, :r_sf64, 32
      repeated :float, :r_flt, 33
      repeated :double, :r_dbl, 34
      repeated :string, :r_str, 35
    end

    class Packed < ::Protobuf::Message
      repeated :int32, :r_i32, 21, :packed => true
      repeated :bool, :r_b, 27, :packed => true
      repeated :double, :r_dbl, 34, :packed => true
    end

    class Singular < ::Protobuf::Message
      optional :int32, :i32, 1
      optional :bool, :b, 7
      optional :string, :str, 15
    end
  end

  def tag(field, wire_type)
    ::Protobuf::Varint.encode((field << 3) | wire_type)
  end

  def varint(value)
    ::Protobuf::Varint.encode(value)
  end

  def len(field, bytes)
    tag(field, ::Protobuf::WireType::LENGTH_DELIMITED) + varint(bytes.bytesize) + bytes
  end

  def unpacked_varints(field, values)
    values.map { |v| tag(field, ::Protobuf::WireType::VARINT) + varint(v) }.join.b
  end

  # Bytes made by google-protobuf 4.36.2 (proto3, so every repeated scalar is
  # packed) for:
  #   r_i32: [1, -1, 300], r_i64: [5, -9_000_000_000],
  #   r_u32: [0, 4_294_967_295], r_u64: [18_446_744_073_709_551_615],
  #   r_s32: [-1, 2, -300], r_s64: [-5_000_000_000], r_b: [true, false, true],
  #   r_color: [GREEN, BLUE], r_f32: [7, 4_294_967_295], r_f64: [8],
  #   r_sf32: [-7], r_sf64: [-8], r_flt: [1.5, -2.25], r_dbl: [3.5, -0.125]
  let(:google_protobuf_packed) do
    hex = 'aa010d01ffffffffffffffffff01ac02b2010b0580ccbbbcdeffffffff01ba010600ffffffff0f' \
          'c2010affffffffffffffffff01ca01040104d704d20105ffc7afa025da0103010001e201020102' \
          'ea010807000000fffffffff201080800000000000000fa0104f9ffffff820208f8ffffffffffffff' \
          '8a02080000c03f000010c09202100000000000000c40000000000000c0bf'
    [hex].pack('H*')
  end

  describe 'packed input for fields that do not declare packed' do
    subject(:message) { PackedDecodingSpec::Unpacked.decode(google_protobuf_packed) }

    {
      :r_i32 => [1, -1, 300],
      :r_i64 => [5, -9_000_000_000],
      :r_u32 => [0, 4_294_967_295],
      :r_u64 => [18_446_744_073_709_551_615],
      :r_s32 => [-1, 2, -300],
      :r_s64 => [-5_000_000_000],
      :r_b => [true, false, true],
      :r_f32 => [7, 4_294_967_295],
      :r_f64 => [8],
      :r_sf32 => [-7],
      :r_sf64 => [-8],
      :r_flt => [1.5, -2.25],
      :r_dbl => [3.5, -0.125],
    }.each do |field, expected|
      it "decodes #{field}" do
        expect(message.public_send(field).to_a).to eq(expected)
      end
    end

    it 'decodes enums' do
      expect(message.r_color.to_a).to eq([PackedDecodingSpec::Color::GREEN, PackedDecodingSpec::Color::BLUE])
    end

    it 'decodes the report case: packed bools are not all false' do
      expect(PackedDecodingSpec::Unpacked.decode(len(27, "\x01".b)).r_b.to_a).to eq([true])
      expect(PackedDecodingSpec::Unpacked.decode(len(27, "\x01\x01".b)).r_b.to_a).to eq([true, true])
    end

    it 'decodes the report case: packed int64 does not raise' do
      expect(PackedDecodingSpec::Unpacked.decode(len(22, "\x05\x09".b)).r_i64.to_a).to eq([5, 9])
    end
  end

  describe 'packed records' do
    it 'concatenates a packed run that is split over two records' do
      bytes = len(21, "\x01\x02".b) + len(15, 'x') + len(21, "\x03".b)
      expect(PackedDecodingSpec::Unpacked.decode(bytes).r_i32.to_a).to eq([1, 2, 3])
    end

    it 'accepts packed and unpacked records for the same field' do
      bytes = len(21, "\x01\x02".b) + unpacked_varints(21, [3])
      expect(PackedDecodingSpec::Unpacked.decode(bytes).r_i32.to_a).to eq([1, 2, 3])
    end

    it 'adds no values for an empty packed record' do
      expect(PackedDecodingSpec::Unpacked.decode(len(21, ''.b)).r_i32.to_a).to eq([])
    end

    it 'does not change other fields' do
      bytes = len(15, 'name') + len(21, "\x01".b) + len(35, 'a') + len(35, 'b')
      message = PackedDecodingSpec::Unpacked.decode(bytes)
      expect([message.name, message.r_i32.to_a, message.r_str.to_a]).to eq(['name', [1], %w[a b]])
    end
  end

  describe 'unpacked input for fields that declare packed' do
    it 'decodes varints' do
      bytes = unpacked_varints(21, [1, 2])
      expect(PackedDecodingSpec::Packed.decode(bytes).r_i32.to_a).to eq([1, 2])
    end

    it 'decodes bools' do
      bytes = unpacked_varints(27, [1, 0])
      expect(PackedDecodingSpec::Packed.decode(bytes).r_b.to_a).to eq([true, false])
    end

    it 'decodes fixed64 values' do
      bytes = [3.5, -0.125].map { |v| tag(34, ::Protobuf::WireType::FIXED64) + [v].pack('E') }.join.b
      expect(PackedDecodingSpec::Packed.decode(bytes).r_dbl.to_a).to eq([3.5, -0.125])
    end
  end

  describe 'unchanged behavior' do
    it 'decodes unpacked input for fields that do not declare packed' do
      bytes = unpacked_varints(21, [1, 2]) + unpacked_varints(27, [1])
      message = PackedDecodingSpec::Unpacked.decode(bytes)
      expect([message.r_i32.to_a, message.r_b.to_a]).to eq([[1, 2], [true]])
    end

    it 'decodes packed input for fields that declare packed' do
      expect(PackedDecodingSpec::Packed.decode(len(21, "\x01\x02".b)).r_i32.to_a).to eq([1, 2])
    end

    it 'round-trips both declarations' do
      unpacked = PackedDecodingSpec::Unpacked.new(:r_i32 => [1, -1], :r_b => [true, false], :r_dbl => [1.5])
      packed = PackedDecodingSpec::Packed.new(:r_i32 => [1, -1], :r_b => [true, false], :r_dbl => [1.5])
      expect(PackedDecodingSpec::Unpacked.decode(unpacked.encode)).to eq(unpacked)
      expect(PackedDecodingSpec::Packed.decode(packed.encode)).to eq(packed)
    end

    it 'decodes across declarations: packed writer, unpacked reader and back' do
      packed = PackedDecodingSpec::Packed.new(:r_i32 => [1, 300], :r_b => [true, false], :r_dbl => [1.5, 2.5])
      unpacked = PackedDecodingSpec::Unpacked.decode(packed.encode)
      expect([unpacked.r_i32.to_a, unpacked.r_b.to_a, unpacked.r_dbl.to_a]).to eq([[1, 300], [true, false], [1.5, 2.5]])

      back = PackedDecodingSpec::Packed.decode(unpacked.encode)
      expect(back).to eq(packed)
    end

    it 'does not change encoding' do
      message = PackedDecodingSpec::Unpacked.new(:r_i32 => [1, 2])
      expect(message.encode).to eq(unpacked_varints(21, [1, 2]))
    end
  end

  describe 'a record with the wrong wire type for a known field' do
    it 'is skipped for a singular scalar field' do
      bytes = len(1, 'xx') + len(7, "\x01".b) + len(15, 'ok')
      message = PackedDecodingSpec::Singular.decode(bytes)
      expect([message.i32, message.field?(:i32), message.b, message.field?(:b), message.str]).to eq([0, false, false, false, 'ok'])
    end

    it 'is skipped for a repeated scalar field' do
      bytes = tag(29, ::Protobuf::WireType::VARINT) + varint(5) + len(21, "\x01".b)
      message = PackedDecodingSpec::Unpacked.decode(bytes)
      expect([message.r_f32.to_a, message.r_i32.to_a]).to eq([[], [1]])
    end
  end

  describe 'callers that do not know the wire type' do
    it 'Decoder.decode_each_field still works with a two-argument block' do
      seen = []
      ::Protobuf::Decoder.decode_each_field(StringIO.new(unpacked_varints(21, [7]))) { |tag, bytes| seen << [tag, bytes] }
      expect(seen).to eq([[21, 7]])
    end

    it 'BaseField#set without a wire type uses the field declaration' do
      message = PackedDecodingSpec::Packed.new
      PackedDecodingSpec::Packed.get_field(:r_i32).set(message, "\x01\x02".b)
      expect(message.r_i32.to_a).to eq([1, 2])

      unpacked = PackedDecodingSpec::Unpacked.new
      PackedDecodingSpec::Unpacked.get_field(:r_i32).set(unpacked, 3)
      expect(unpacked.r_i32.to_a).to eq([3])
    end
  end
end
