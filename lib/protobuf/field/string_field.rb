require 'protobuf/field/bytes_field'

module Protobuf
  module Field
    class StringField < BytesField
      ENCODING = 'UTF-8'.freeze

      def decode(bytes)
        bytes.force_encoding(::Protobuf::Field::StringField::ENCODING) if bytes.respond_to?(:force_encoding)
        bytes
      end
    end
  end
end
