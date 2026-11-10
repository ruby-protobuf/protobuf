require 'spec_helper'

# Decoder.decode_message decodes nested messages without recursion. These
# specs check that the result and the errors are the same as the recursive
# decode, and that the depth of the input does not use up the stack.
RSpec.describe 'Decoding nested messages without recursion' do
  module IterativeDecodeSpec
    class Color < ::Protobuf::Enum
      define :RED, 0
      define :GREEN, 1
    end

    class Node < ::Protobuf::Message; end
    class Leaf < ::Protobuf::Message; end

    class Leaf
      optional :int32, :id, 1
      optional :string, :name, 2
      repeated :int32, :nums, 3
    end

    class Node
      optional :int32, :v, 1
      optional ::IterativeDecodeSpec::Node, :child, 2
      repeated ::IterativeDecodeSpec::Node, :children, 3
      optional ::IterativeDecodeSpec::Leaf, :leaf, 4
      repeated ::IterativeDecodeSpec::Leaf, :leaves, 5
      map :string, ::IterativeDecodeSpec::Node, :nodes, 6
      map :string, ::IterativeDecodeSpec::Color, :colors, 7
      optional :string, :s, 8
      optional :bytes, :blob, 9
      optional ::IterativeDecodeSpec::Color, :color, 10
    end

    class WithRequired < ::Protobuf::Message
      required :int32, :id, 1
    end

    class Parent < ::Protobuf::Message
      optional ::IterativeDecodeSpec::WithRequired, :req, 1
      repeated ::IterativeDecodeSpec::WithRequired, :reqs, 2
    end

    # Changes how it decodes, so it must not take the iterative path.
    class CustomDecode < ::Protobuf::Message
      optional :int32, :id, 1

      def decode_from(stream)
        super
        self.id = id + 1000
        self
      end
    end

    class CustomSetFieldBytes < ::Protobuf::Message
      optional :int32, :id, 1

      private

      def set_field_bytes(tag, bytes, wire_type = nil)
        super(tag, wire_type == ::Protobuf::WireType::VARINT ? bytes + 1 : bytes, wire_type)
      end
    end

    class CustomField < ::Protobuf::Field::MessageField
      def decode(bytes)
        msg = super
        msg.id = 77
        msg
      end
    end

    class HoldsCustom < ::Protobuf::Message
      optional ::IterativeDecodeSpec::CustomDecode, :custom, 1
      optional ::IterativeDecodeSpec::CustomSetFieldBytes, :custom_bytes, 2
      optional ::IterativeDecodeSpec::Leaf, :leaf, 3
    end
  end

  # The decode before Decoder.decode_message: a nested message recurses.
  module RecursiveDecode
    def self.decode(klass, bytes)
      decode_into(klass.new, ::StringIO.new(bytes))
    end

    def self.decode_into(message, stream)
      ::Protobuf::Decoder.decode_each_field(stream) do |tag, bytes, wire_type|
        field = message._protobuf_message_field[tag]
        next unless field

        if field.iterative_decode? && wire_type == ::Protobuf::WireType::LENGTH_DELIMITED
          field.store_decoded(message, decode_into(field.type_class.new, ::StringIO.new(bytes)))
        else
          field.set(message, bytes, wire_type)
        end
      end
      message
    end
  end

  let(:node) { ::IterativeDecodeSpec::Node }

  def tag(field, wire_type)
    ::Protobuf::Varint.encode((field << 3) | wire_type)
  end

  def varint(field, value)
    tag(field, ::Protobuf::WireType::VARINT) + ::Protobuf::Varint.encode(value)
  end

  def len(field, bytes)
    tag(field, ::Protobuf::WireType::LENGTH_DELIMITED) + ::Protobuf::Varint.encode(bytes.bytesize) + bytes
  end

  def chain(depth)
    bytes = varint(1, depth)
    depth.times { bytes = len(2, bytes) }
    bytes
  end

  def outcome(&block)
    [:ok, block.call]
  rescue StandardError => e
    [:error, e.class]
  end

  let(:sample) do
    node.new(
      :v => 1, :s => "café", :blob => "\x00\xFF".b, :color => ::IterativeDecodeSpec::Color::GREEN,
      :child => { :v => 2, :child => { :v => 3, :leaf => { :id => 9, :nums => [1, 2] } } },
      :children => [{ :v => 4 }, { :v => 5, :children => [{ :v => 6 }] }],
      :leaf => { :id => 7, :name => "leaf" },
      :leaves => [{ :id => 1 }, { :id => 2, :nums => [3] }],
      :nodes => { "a" => { :v => 10, :nodes => { "b" => { :v => 11 } } } },
      :colors => { "x" => ::IterativeDecodeSpec::Color::GREEN }
    )
  end

  it 'round trips singular, repeated, and map message values' do
    expect(node.decode(sample.encode)).to eq(sample)
  end

  it 'gives the same message as a recursive decode' do
    bytes = sample.encode
    expect(node.decode(bytes).to_hash).to eq(RecursiveDecode.decode(node, bytes).to_hash)
  end

  it 'keeps the last record of a singular message field' do
    bytes = len(2, varint(1, 1)) + len(2, varint(1, 2))
    expect(node.decode(bytes).child.v).to eq(2)
  end

  it 'adds each record of a repeated message field in order' do
    bytes = len(3, varint(1, 1)) + varint(1, 9) + len(3, varint(1, 2))
    decoded = node.decode(bytes)
    expect(decoded.children.map(&:v)).to eq([1, 2])
    expect(decoded.v).to eq(9)
  end

  it 'gives an empty message for a 0-length record' do
    decoded = node.decode(len(2, ''))
    expect(decoded.field?(:child)).to be(true)
    expect(decoded.child).to eq(node.new)
  end

  it 'gives an empty message for a map entry without a value' do
    decoded = node.decode(len(6, len(1, 'k')))
    expect(decoded.nodes['k']).to eq(node.new)
  end

  it 'skips a map entry whose enum value the enum does not define' do
    decoded = node.decode(len(7, len(1, 'k') + varint(2, 99)))
    expect(decoded.colors).to be_empty
  end

  it 'skips a record with a wire type that does not match a message field' do
    expect(node.decode(varint(2, 5)).field?(:child)).to be(false)
  end

  it 'skips a group inside a nested message' do
    group = tag(7, ::Protobuf::WireType::START_GROUP) + varint(1, 1) + tag(7, ::Protobuf::WireType::END_GROUP)
    expect(node.decode(len(2, group + varint(1, 3))).child.v).to eq(3)
  end

  it 'skips unknown fields in a nested message' do
    expect(node.decode(len(2, varint(99, 1) + varint(1, 3))).child.v).to eq(3)
  end

  it 'counts a required field that a nested message does not have as missing' do
    decoded = ::IterativeDecodeSpec::Parent.decode(len(1, '') + len(2, varint(1, 5)))
    expect { decoded.req.encode }.to raise_error(::Protobuf::SerializationError)
    expect(decoded.reqs.first.id).to eq(5)
    expect { decoded.reqs.first.encode }.not_to raise_error
  end

  context 'with a class or field that changes how it decodes' do
    let(:holder) { ::IterativeDecodeSpec::HoldsCustom }

    it 'calls decode_from of the nested class' do
      expect(holder.decode(len(1, varint(1, 1))).custom.id).to eq(1001)
    end

    it 'calls set_field_bytes of the nested class' do
      expect(holder.decode(len(2, varint(1, 1))).custom_bytes.id).to eq(2)
    end

    it 'calls set_field_bytes of the top class' do
      expect(::IterativeDecodeSpec::CustomSetFieldBytes.decode(varint(1, 1)).id).to eq(2)
    end

    it 'calls decode of a custom field class' do
      field = ::IterativeDecodeSpec::CustomField.new(holder, :optional, ::IterativeDecodeSpec::Leaf, :leaf, 3, :leaf, {})
      expect(field.iterative_decode?).to be(false)
      message = holder.new
      field.set(message, varint(1, 1), ::Protobuf::WireType::LENGTH_DELIMITED)
      expect(message.leaf.id).to eq(77)
    end
  end

  context 'with malformed nested input' do
    it 'gives the same result or error class as a recursive decode' do
      inputs = [
        len(2, "\x08".b),                                 # varint that the record cuts off
        len(2, "\x12\x05\x08".b),                         # length past the end of the child
        len(2, len(2, "\x0b".b)),                         # group without its end
        len(2, "\x0f".b),                                 # wire type 7
        len(2, "\x0d\x01\x02".b),                         # truncated fixed32
        "\x12\x05\x08\x01".b,                             # length past the end of the top message
        len(2, len(4, "\x1a\x02\x01".b)),                 # truncated packed run in a leaf
        len(6, len(1, 'k') + len(2, "\x08".b)),           # map value cut off
      ]
      inputs.each do |bytes|
        expect(outcome { node.decode(bytes).to_hash }).to eq(outcome { RecursiveDecode.decode(node, bytes).to_hash }), bytes.unpack1('H*')
      end
    end

    it 'gives the same result or error class as a recursive decode for random changes' do
      rng = Random.new(20_261_110)
      base = sample.encode.bytes
      300.times do
        bytes = base.dup
        rng.rand(1..4).times do
          case rng.rand(3)
          when 0 then bytes[rng.rand(bytes.size)] = rng.rand(256)
          when 1 then bytes.delete_at(rng.rand(bytes.size)) if bytes.size > 1
          else bytes.insert(rng.rand(bytes.size + 1), rng.rand(256))
          end
        end
        input = bytes.pack('C*')
        expect(outcome { node.decode(input).to_hash }).to eq(outcome { RecursiveDecode.decode(node, input).to_hash }), input.unpack1('H*')
      end
    end
  end

  context 'with deep input' do
    it 'decodes 100,000 levels on the current thread' do
      depth = 100_000
      decoded = node.decode(chain(depth))
      levels = 0
      levels += 1 while (decoded = decoded.child!)
      expect(levels).to eq(depth)
    end

    it 'decodes 5,000 levels in a fiber, which has a small stack' do
      bytes = chain(5_000)
      expect(Fiber.new { node.decode(bytes).field?(:child) }.resume).to be(true)
    end
  end

  describe 'Protobuf.max_decode_depth' do
    after { ::Protobuf.max_decode_depth = nil }

    it 'has no limit by default' do
      expect(::Protobuf.max_decode_depth).to be_nil
    end

    it 'decodes input at the limit' do
      ::Protobuf.max_decode_depth = 3
      expect { node.decode(chain(3)) }.not_to raise_error
    end

    it 'raises DecodeDepthError for input deeper than the limit' do
      ::Protobuf.max_decode_depth = 3
      expect { node.decode(chain(4)) }.to raise_error(::Protobuf::DecodeDepthError, /3 levels/)
    end

    it 'counts repeated and map values as one level each' do
      ::Protobuf.max_decode_depth = 2
      expect { node.decode(len(3, len(6, len(1, 'k')))) }.not_to raise_error
      expect { node.decode(len(3, len(6, len(1, 'k') + len(2, len(2, ''))))) }.to raise_error(::Protobuf::DecodeDepthError)
    end

    it 'is a Protobuf::Error, so code that rescues StandardError gets it' do
      expect(::Protobuf::DecodeDepthError.ancestors).to include(::Protobuf::Error, ::StandardError)
    end

    it 'rejects a value that is not nil or a positive Integer' do
      expect { ::Protobuf.max_decode_depth = 0 }.to raise_error(ArgumentError)
      expect { ::Protobuf.max_decode_depth = '5' }.to raise_error(ArgumentError)
    end
  end
end
