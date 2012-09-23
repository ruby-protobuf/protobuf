require 'protobuf/field/bytes_field'

module Protobuf
  module Field
    class StringField < BytesField
      def decode(bytes)
        bytes.force_encoding('UTF-8') if bytes.respond_to?(:force_encoding)
        bytes
      end
    end
  end
end
