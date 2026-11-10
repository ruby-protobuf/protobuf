module Protobuf
  class Decoder
    VARINT = ::Protobuf::WireType::VARINT
    FIXED64 = ::Protobuf::WireType::FIXED64
    LENGTH_DELIMITED = ::Protobuf::WireType::LENGTH_DELIMITED
    START_GROUP = ::Protobuf::WireType::START_GROUP
    FIXED32 = ::Protobuf::WireType::FIXED32

    # Decode +stream+ into +message+ and return +message+.
    #
    # A nested message does not make a recursive call. The message that each
    # level decodes into goes on a stack in the heap, so the depth of the input
    # does not depend on the thread stack. On JRuby a stack overflow in the main
    # thread stops the process before Ruby can rescue it.
    #
    # Each nested message reads its own StringIO, as before, and it goes into
    # its parent only after it is complete. Thus the result and the errors are
    # the same as a recursive decode.
    #
    # A field or a message class that changes how its messages decode (see
    # MessageField#iterative_decode?) decodes with BaseField#set, which recurses.
    def self.decode_message(message, stream)
      return decode_with_set_field_bytes(message, stream) unless message.class._protobuf_standard_decode?

      max_depth = ::Protobuf.max_decode_depth
      root = message
      # The field of the parent message that gets +message+ when it is complete.
      owner = nil
      # The message, stream, and owner of each parent, flat. Made at the first
      # nested message.
      stack = nil

      loop do
        field = decode_fields(message, stream)
        if field
          stack ||= []
          check_depth!(stack.size / 3 + 1, max_depth) if max_depth
          stack.push(message, stream, owner)
          owner = field
          message = field.type_class.new
          stream = ::StringIO.new(stream.read(Varint.decode(stream)))
          next
        end

        return root if stack.nil? || stack.empty?

        child = message
        child_field = owner
        owner = stack.pop
        stream = stack.pop
        message = stack.pop
        child_field.store_decoded(message, child)
      end
    end

    # Decode records from +stream+ into +message+ until the end of +stream+,
    # and return nil. At a record for a nested message that decode_message
    # decodes, stop and return its field. The length of the record is the
    # next thing in +stream+.
    #
    # The wire types are inline, not in a method: with YJIT on Ruby 3.4, a
    # method call for each record made a 262-byte message decode 10% slower.
    def self.decode_fields(message, stream)
      fields = message._protobuf_message_field
      until stream.eof?
        bits = Varint.decode(stream)
        wire_type = bits & 0x07
        tag = bits >> 3
        field = fields[tag]

        if wire_type == LENGTH_DELIMITED
          return field if field&.iterative_decode?

          bytes = stream.read(Varint.decode(stream))
        elsif wire_type == VARINT
          bytes = Varint.decode(stream)
        elsif wire_type == FIXED64
          bytes = stream.read(8)
        elsif wire_type == FIXED32
          bytes = stream.read(4)
        elsif wire_type == START_GROUP
          skip_group(stream, tag)
          next
        else
          fail InvalidWireType, wire_type
        end

        field&.set(message, bytes, wire_type)
      end
      nil
    end
    private_class_method :decode_fields

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

    # +depth+ is the level of the nested message below the top message.
    def self.check_depth!(depth, max_depth)
      return if depth <= max_depth

      fail DecodeDepthError, "Messages nest more than #{max_depth} levels deep (Protobuf.max_decode_depth)"
    end
    private_class_method :check_depth!

    # Whether +klass+ decodes with the methods in Message::Serialization. A
    # class that changes one of them decodes with its own methods.
    def self.standard_decode?(klass)
      serialization = ::Protobuf::Message::Serialization
      klass.method(:decode).owner == serialization::ClassMethods &&
        klass.instance_method(:decode).owner == serialization &&
        klass.instance_method(:decode_from).owner == serialization &&
        klass.instance_method(:set_field_bytes).owner == serialization
    end

    # The decode before decode_message: a nested message recurses. For a
    # message class that changes set_field_bytes or another decode method.
    def self.decode_with_set_field_bytes(message, stream)
      decode_each_field(stream) do |tag, bytes, wire_type|
        message.__send__(:set_field_bytes, tag, bytes, wire_type)
      end
      message
    end
    private_class_method :decode_with_set_field_bytes
  end
end
