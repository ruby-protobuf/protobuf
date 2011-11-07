require 'protobuf/common/wire_type'
require 'protobuf/common/exceptions'

module Protobuf

  module Encoder

    module_function

    # Encode +message+ and write to +stream+.
    def encode(stream, message)
      # FIXME make this not as ghetto
      raise NotInitializedError, "Message %s is not initialized (one or more fields is improperly set): %s" % [message.class.name, JSON.parse(message.to_json)] unless message.initialized?
      
      message.each_field do |field, value|
        next unless message.has_field?(field.name)

        if field.repeated?
          if field.packed?
            key = (field.tag << 3) | WireType::LENGTH_DELIMITED
            packed_value = value.map {|val| field.encode(val) }.join
            stream.write(Field::VarintField.encode(key))
            stream.write(Field::VarintField.encode(packed_value.size))
            stream.write(packed_value)
          else
            value.each do |val|
              write_pair(stream, field, val)
            end
          end
        else
          write_pair(stream, field, value)
        end
      end
    end

    # Encode key and value, and write to +stream+.
    def write_pair(stream, field, value)
      key = (field.tag << 3) | field.wire_type
      key_bytes = Field::VarintField.encode(key)
      stream.write(key_bytes)
      bytes = field.encode(value)
      stream.write(bytes)
    end

  end
end
