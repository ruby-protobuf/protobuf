module Protobuf
  class Decoder

    # Read bytes from +stream+ and yield (tag, bytes, wire_type) for each field.
    # A block that takes only (tag, bytes) still works: blocks drop extra arguments.
    def self.decode_each_field(stream)
      until stream.eof?
        bits = Varint.decode(stream)
        wire_type = bits & 0x07
        tag = bits >> 3

        bytes = if wire_type == ::Protobuf::WireType::VARINT
                  Varint.decode(stream)
                elsif wire_type == ::Protobuf::WireType::LENGTH_DELIMITED
                  value_length = Varint.decode(stream)
                  stream.read(value_length)
                elsif wire_type == ::Protobuf::WireType::FIXED64
                  stream.read(8)
                elsif wire_type == ::Protobuf::WireType::FIXED32
                  stream.read(4)
                elsif wire_type == ::Protobuf::WireType::START_GROUP
                  skip_group(stream, tag)
                  next
                else
                  fail InvalidWireType, wire_type
                end

        yield(tag, bytes, wire_type)
      end
    end

    # Skip a group (wire types 3 and 4), with any groups inside it. This gem
    # has no group fields, so the rule for an unknown field applies, as in the
    # reference parsers: skip it. A group without its end raises InvalidWireType.
    def self.skip_group(stream, group_tag)
      open_tags = [group_tag]
      until open_tags.empty?
        fail InvalidWireType, ::Protobuf::WireType::START_GROUP if stream.eof?

        bits = Varint.decode(stream)
        wire_type = bits & 0x07
        tag = bits >> 3

        case wire_type
        when ::Protobuf::WireType::VARINT then Varint.decode(stream)
        when ::Protobuf::WireType::LENGTH_DELIMITED then stream.read(Varint.decode(stream))
        when ::Protobuf::WireType::FIXED64 then stream.read(8)
        when ::Protobuf::WireType::FIXED32 then stream.read(4)
        when ::Protobuf::WireType::START_GROUP then open_tags.push(tag)
        when ::Protobuf::WireType::END_GROUP
          fail InvalidWireType, wire_type unless open_tags.pop == tag
        else
          fail InvalidWireType, wire_type
        end
      end
    end
    private_class_method :skip_group
  end
end
