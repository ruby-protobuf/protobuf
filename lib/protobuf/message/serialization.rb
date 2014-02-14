require 'stringio'
require 'protobuf/message/decoder'
require 'protobuf/message/encoder'

module Protobuf
  class Message
    module Serialization

      module ClassMethods
        def decode(bytes)
          self.new.decode(bytes)
        end

        # Create a new object with the given values and return the encoded bytes.
        def encode(fields = {})
          self.new(fields).encode
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
        ::Protobuf::Message::Decoder.decode_each_field(stream) do |tag, bytes|
          set_field_bytes(tag, bytes)
        end

        self
      end

      # Encode this message
      #
      def encode
        encode_to(::StringIO.new).string
      end

      # Encode this message to the given stream.
      #
      def encode_to(stream)
        ::Protobuf::Message::Encoder.encode(stream, self)
      end

      ##
      # Instance Aliases
      #
      alias_method :parse_from_string, :decode
      alias_method :deserialize, :decode
      alias_method :parse_from, :decode_from
      alias_method :deserialize_from, :decode_from
      alias_method :to_s, :encode
      alias_method :bytes, :encode
      alias_method :serialize, :encode
      alias_method :serialize_to_string, :encode
      alias_method :serialize_to, :encode_to

      private

      def field_must_be_serialized?(field)
        field.required? || ! @values[field.name].nil?
      end

      def set_field_bytes(tag, bytes)
        field = self.class.get_field(tag, true)
        field.set(self, bytes) if field
      end

    end
  end
end

