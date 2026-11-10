require 'protobuf/field/bytes_field'

module Protobuf
  module Field
    class StringField < BytesField

      ##
      # Constants
      #

      ENCODING = Encoding::UTF_8

      # Return +value+ (a new String) with UTF-8 encoding, for the wire.
      # A BINARY (ASCII-8BIT) String that holds valid UTF-8 keeps its bytes:
      # sockets, files, Base64.decode64, and Array#pack return BINARY Strings.
      # Other encodings are transcoded to UTF-8. Characters that cannot be
      # transcoded, and invalid bytes, are dropped, as before.
      def self.to_utf8(value)
        new_value = "" + value # dup is slower
        return new_value if new_value.encoding == ENCODING

        if new_value.encoding == ::Encoding::BINARY
          new_value.force_encoding(ENCODING)
          return new_value if new_value.valid_encoding?
          new_value.force_encoding(::Encoding::BINARY)
        end

        new_value.encode!(ENCODING, :invalid => :replace, :undef => :replace, :replace => "")
      end

      ##
      # Public Instance Methods
      #

      def acceptable?(val)
        val.is_a?(String) || val.nil? || val.is_a?(Symbol)
      end

      def coerce!(value)
        if value.nil?
          nil
        elsif acceptable?(value)
          value.to_s
        else
          fail TypeError, "Unacceptable value #{value} for field #{name} of type #{type_class}"
        end
      end

      def decode(bytes)
        bytes.force_encoding(::Protobuf::Field::StringField::ENCODING)
        bytes
      end

      def encode(value)
        value_to_encode = self.class.to_utf8(value)
        value_to_encode.force_encoding(::Protobuf::Field::BytesField::BYTES_ENCODING)

        "#{::Protobuf::Field::VarintField.encode(value_to_encode.bytesize)}#{value_to_encode}"
      end

      def json_encode(value)
        value
      end
    end
  end
end
