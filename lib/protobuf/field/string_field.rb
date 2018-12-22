require 'protobuf/field/bytes_field'

module Protobuf
  module Field
    class StringField < BytesField

      ##
      # Constants
      #

      ENCODING = Encoding::UTF_8

      ##
      # Class Methods
      #

      def self.decode(bytes)
        bytes_to_decode = bytes.dup
        bytes_to_decode.force_encoding(::PROTOBUF_FIELD_STRING_FIELD::ENCODING)
        bytes_to_decode
      end

      def self.encode(value)
        value_to_encode = value.encode(::PROTOBUF_FIELD_STRING_FIELD::ENCODING, :invalid => :replace, :undef => :replace, :replace => "")
        value_to_encode.force_encoding(::PROTOBUF_FIELD_BYTES_FIELD::BYTES_ENCODING)

        "#{::PROTOBUF_FIELD_VARINT_FIELD.encode(value_to_encode.size)}#{value_to_encode}"
      end

      ##
      # Public Instance Methods
      #

      def decode(bytes)
        bytes_to_decode = bytes.dup
        bytes_to_decode.force_encoding(::PROTOBUF_FIELD_STRING_FIELD::ENCODING)
        bytes_to_decode
      end

      def encode(value)
        value_to_encode = value.encode(::PROTOBUF_FIELD_STRING_FIELD::ENCODING, :invalid => :replace, :undef => :replace, :replace => "")
        value_to_encode.force_encoding(::PROTOBUF_FIELD_BYTES_FIELD::BYTES_ENCODING)

        "#{::PROTOBUF_FIELD_VARINT_FIELD.encode(value_to_encode.size)}#{value_to_encode}"
      end

      def encode_to_stream(value, stream)
        if value.encoding != ::PROTOBUF_FIELD_STRING_FIELD::ENCODING
          value = value.encode(::PROTOBUF_FIELD_STRING_FIELD::ENCODING, :invalid => :replace, :undef => :replace, :replace => "")
        end

        stream << tag_encoded << ::PROTOBUF_FIELD_VARINT_FIELD.encode(value.bytesize) << value
      end

      def json_encode(value)
        value
      end
    end
  end
end

PROTOBUF_FIELD_STRING_FIELD = ::Protobuf::Field::StringField
