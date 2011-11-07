require 'protobuf/common/wire_type'
require 'protobuf/common/exceptions'

module Protobuf

  module Decoder

    module_function

    # Read bytes from +stream+ and pass to +message+ object.
    def decode(stream, message)
      until stream.eof?
        tag, wire_type = read_key(stream)
        bytes =
          case wire_type
          when WireType::VARINT
            read_varint(stream)
          when WireType::FIXED64
            read_fixed64(stream)
          when WireType::LENGTH_DELIMITED
            read_length_delimited(stream)
          when WireType::START_GROUP
            read_start_group(stream)
          when WireType::END_GROUP
            read_end_group(stream)
          when WireType::FIXED32
            read_fixed32(stream)
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
      read_method = stream.respond_to?(:readbyte) ? :readbyte : :readchar
      value = index = 0
      begin
        byte = stream.__send__(read_method)
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

    # Not implemented.
    def read_start_group(stream)
      raise NotImplementedError, 'Group is deprecated.'
    end

    # Not implemented.
    def read_end_group(stream)
      raise NotImplementedError, 'Group is deprecated.'
    end

  end
end
