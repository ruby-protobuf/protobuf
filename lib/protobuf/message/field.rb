require 'protobuf/common/wire_type'
require 'protobuf/descriptor/field_descriptor'

module Protobuf
  module Field

    PREDEFINED_TYPES = [
      :double,   :float,
      :int32,    :int64,
      :uint32,   :uint64,
      :sint32,   :sint64,
      :fixed32,  :fixed64,
      :sfixed32, :sfixed64,
      :string,   :bytes,
      :bool,
    ].freeze

    def self.build(message_class, rule, type, name, tag, options={})
      field_class = \
        if PREDEFINED_TYPES.include?(type)
          "#{type.to_s.capitalize}Field".constantize
        else
          FieldProxy
        end
      field_class.new(message_class, rule, type, name, tag, options)
    end

  end
end
