require 'stringio'
require 'protobuf/decoder'
require 'protobuf/encoder'

module Protobuf
  class Message
    module Serialization

      module ClassMethods
        def decode(bytes)
          new.decode(bytes)
        end

        def decode_from(stream)
          new.decode_from(stream)
        end

        # Whether this class decodes with the methods in this module. See
        # Decoder.decode_message.
        def _protobuf_standard_decode?
          return @_protobuf_standard_decode unless @_protobuf_standard_decode.nil?

          @_protobuf_standard_decode = ::Protobuf::Decoder.standard_decode?(self)
        end

        # Create a new object with the given values and return the encoded bytes.
        def encode(fields = {})
          new(fields).encode
        end
      end

      def self.included(other)
        other.extend(ClassMethods)
      end

      ##
      # Instance Methods
      #

      # Decode the given non-stream bytes into this message.
      #
      def decode(bytes)
        decode_from(::StringIO.new(bytes))
      end

      # Decode the given stream into this message.
      #
      def decode_from(stream)
        ::Protobuf::Decoder.decode_message(self, stream)
      end

      # Encode this message
      #
      def encode
        stream = ::StringIO.new
        stream.set_encoding(::Protobuf::Field::BytesField::BYTES_ENCODING)
        encode_to(stream)
        stream.string
      end

      # Encode this message to the given stream.
      #
      def encode_to(stream)
        ::Protobuf::Encoder.encode(self, stream)
      end

      ##
      # Instance Aliases
      #
      alias :parse_from_string decode
      alias :deserialize decode
      alias :parse_from decode_from
      alias :deserialize_from decode_from
      alias :to_s encode
      alias :bytes encode
      alias :serialize encode
      alias :serialize_to_string encode
      alias :serialize_to encode_to

      private

      def set_field_bytes(tag, bytes, wire_type = nil)
        field = _protobuf_message_field[tag]
        field.set(self, bytes, wire_type) if field
      end

    end
  end
end
