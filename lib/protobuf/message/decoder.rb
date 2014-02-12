require 'protobuf/wire_type'
require 'protobuf/exceptions'

module Protobuf

  module Decoder

    module_function

    # Read bytes from +stream+ and pass to +message+ object.
    def decode(stream, message)
      until stream.eof?
        tag, wire_type = read_key(stream)
        bytes =
          case wire_type
          when ::Protobuf::WireType::VARINT then
            read_varint(stream)
          when ::Protobuf::WireType::FIXED64 then
            read_fixed64(stream)
          when ::Protobuf::WireType::LENGTH_DELIMITED then
            read_length_delimited(stream)
          when ::Protobuf::WireType::FIXED32 then
            read_fixed32(stream)
          when ::Protobuf::WireType::START_GROUP then
            read_group(tag, stream)
          when ::Protobuf::WireType::END_GROUP then
            raise InvalidWireType, wire_type
          else
            raise InvalidWireType, wire_type
          end
        message.set_field(tag, bytes)
      end
      message
    end

    # Read key pair (tag and wire-type) from +stream+.
    def read_key(stream)
      bits = read_varint(stream)
      wire_type = bits & 0x07
      tag = bits >> 3
      [tag, wire_type]
    end

    # Read varint integer value from +stream+.
    def read_varint(stream)
      value = index = 0
      begin
        byte = stream.readbyte
        value |= (byte & 0x7f) << (7 * index)
        index += 1
      end while (byte & 0x80).nonzero?
      value
    end

    # Read 32-bit string value from +stream+.
    def read_fixed32(stream)
      stream.read(4)
    end

    # Read 64-bit string value from +stream+.
    def read_fixed64(stream)
      stream.read(8)
    end

    # Read length-delimited string value from +stream+.
    def read_length_delimited(stream)
      value_length = read_varint(stream)
      stream.read(value_length)
    end

    def read_group(group_tag, stream)
      # Very inefficient (hey, groups are deprecated), but works as expected.

      start_pos = stream.pos
      until stream.eof?
        last_pos = stream.pos
        tag, wire_type = read_key(stream)
        case wire_type
        when ::Protobuf::WireType::VARINT then
          read_varint(stream)
        when ::Protobuf::WireType::FIXED64 then
          read_fixed64(stream)
        when ::Protobuf::WireType::LENGTH_DELIMITED then
          read_length_delimited(stream)
        when ::Protobuf::WireType::FIXED32 then
          read_fixed32(stream)
        when ::Protobuf::WireType::START_GROUP then
          read_group(tag, stream)
        when ::Protobuf::WireType::END_GROUP then
          if group_tag == tag
            stream.pos = start_pos
            bytes = stream.read(last_pos - start_pos)
            read_key(stream) # drop the end group tag
            return bytes
          end
        end
      end

      raise InvalidWireType, "No matching end group tag"
    end
  end
end
