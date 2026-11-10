module Protobuf
  module Field
    module BaseFieldObjectDefinitions

      class ToHashValueToMessageHashWithStringKey
        def initialize(selph)
          @selph = selph
          @name = selph.name.to_s
        end

        def call(values, result)
          result[@name] = @selph.value_from_values(values).to_hash_value
        end
      end

      class BaseToMessageHashWithStringKey
        def initialize(selph)
          @selph = selph
          @name = selph.name.to_s
        end

        def call(values, result)
          result[@name] = @selph.value_from_values(values)
        end
      end

      class ToHashValueToMessageHash
        def initialize(selph)
          @selph = selph
          @name = selph.name.to_sym
        end

        def call(values, result)
          result[@name] = @selph.value_from_values(values).to_hash_value
        end
      end

      class BaseToMessageHash
        def initialize(selph)
          @selph = selph
          @name = selph.name.to_sym
        end

        def call(values, result)
          result[@name] = @selph.value_from_values(values)
        end
      end

      class RepeatedPackedEncodeToStream
        def initialize(selph)
          @selph = selph
          @tag_encoded = selph.tag_encoded
        end

        # An empty field has no record. Reading a repeated field (#[], inspect)
        # stores an empty FieldArray, and without this check the encode would
        # add a 0-length record for it.
        def call(value, stream)
          return if value.empty?

          packed_value = value.map { |val| @selph.encode(val) }.join
          stream << @tag_encoded << "#{::Protobuf::Field::VarintField.encode(packed_value.bytesize)}#{packed_value}"
        end
      end

      class BytesEncodeToStream
        def initialize(selph)
          @selph = selph
          @tag_encoded = selph.tag_encoded
        end

        def call(value, stream)
          value = value.encode if value.is_a?(::Protobuf::Message)
          byte_size = ::Protobuf::Field::VarintField.encode(value.bytesize)

          stream << @tag_encoded << byte_size << value
        end
      end

      class StringEncodeToStream
        def initialize(selph)
          @selph = selph
          @tag_encoded = selph.tag_encoded
        end

        def call(value, stream)
          new_value = ::Protobuf::Field::StringField.to_utf8(value)

          stream << @tag_encoded << ::Protobuf::Field::VarintField.encode(new_value.bytesize) << new_value
        end
      end

      class BaseEncodeToStream
        def initialize(selph)
          @selph = selph
          @tag_encoded = selph.tag_encoded
        end

        def call(value, stream)
          stream << @tag_encoded << @selph.encode(value)
        end
      end

      class RepeatedNotPackedEncodeToStream
        def initialize(selph)
          @selph = selph
          @tag_encoded = selph.tag_encoded
        end

        def call(value, stream)
          value.each do |val|
            stream << @tag_encoded << @selph.encode(val)
          end
        end
      end

      # The decode set methods below write a decoded value to the values hash
      # of the message. They do not call coerce! or FieldArray#normalize,
      # because a decoded value already has the type of the field, with two
      # exceptions that DecodedValue handles. Adapted from #297 (abrandoned).
      module DecodedValue
        # Values that the field type cannot hold go through coerce! or
        # normalize, which raise TypeError as before.
        OUT_OF_RANGE = ::Object.new.freeze

        private

        def setup_decoded_value(selph)
          @selph = selph
          @name = selph.name
          @wire_type = selph.wire_type
          @fully_qualified_name = selph.fully_qualified_name
          # EnumField#decode returns the tag as an Integer, or nil for a tag
          # that the enum does not define. The values hash holds Enum objects.
          @enum_class = selph.type_class if selph.enum?
          # A varint can hold more than 64 bits. The 64-bit fields (int64,
          # uint64, sint64) decode such a value to a number out of their range.
          # The fixed-width fields are subclasses of these classes, but they
          # cannot decode to a number out of range, so they do not check.
          if selph.wire_type == ::Protobuf::WireType::VARINT && selph.class.respond_to?(:max)
            @min = selph.class.min
            @max = selph.class.max
          end
        end

        # The value to store, nil for no value, or OUT_OF_RANGE.
        def decoded_value(value)
          if @enum_class
            value && @enum_class.fetch(value)
          elsif @max && (value > @max || value < @min)
            OUT_OF_RANGE
          else
            value
          end
        end

        def values_array(message_instance)
          message_instance._protobuf_message_values[@fully_qualified_name] ||= ::Protobuf::Field::FieldArray.new(@selph)
        end

        def push_decoded(array, raw_value)
          value = decoded_value(raw_value)
          if value.equal?(OUT_OF_RANGE)
            array << raw_value
          elsif !value.nil?
            array.push_decoded(value)
          end
        end
      end

      # Singular fields.
      class BaseSetMethod
        include DecodedValue

        def initialize(selph)
          setup_decoded_value(selph)
          @tag = selph.tag
          @required = selph.required?
        end

        # A record whose wire type differs from the field's is skipped, as the
        # protobuf spec and the reference parsers do.
        def call(message_instance, bytes, wire_type = nil)
          return if wire_type && wire_type != @wire_type

          raw_value = @selph.decode(bytes)
          value = decoded_value(raw_value)
          return message_instance.set_field(@name, raw_value, true, @selph) if value.equal?(OUT_OF_RANGE)

          # A tag that the enum does not define (or a truncated fixed-width
          # value) leaves the field as it is: the proto2 spec keeps the value
          # from an earlier record.
          return if value.nil?

          message_instance._protobuf_message_values[@fully_qualified_name] = value
          message_instance._protobuf_message_unset_required_field_tags.delete(@tag) if @required
        end
      end

      class MapSetMethod
        VALUE_TAG = 2

        def initialize(selph)
          @selph = selph
          @name = selph.name
          @wire_type = selph.wire_type
          @value_field = selph.type_class.get_field(:value)
          @enum_value = @value_field.enum?
          @message_value_class = @value_field.type_class if @value_field.message?
        end

        # An entry without a key or a value gets the default, as in the
        # reference parsers: a message value is an empty message. An entry
        # whose value the enum does not define is skipped (proto2 closed enum).
        def call(message_instance, bytes, wire_type = nil)
          return if wire_type && wire_type != @wire_type

          entry = @selph.decode(bytes)
          unless entry.field?(:value)
            # Rare: the value is absent, or the enum does not define it.
            return if @enum_value && unknown_enum_value?(bytes)
            entry.value = @message_value_class.new if @message_value_class
          end
          message_instance[@name][entry.key] = entry.value
        end

        private

        # The last value record wins, so only the last one counts.
        def unknown_enum_value?(bytes)
          last = nil
          ::Protobuf::Decoder.decode_each_field(::StringIO.new(bytes)) do |tag, value, record_wire_type|
            last = value if tag == VALUE_TAG && record_wire_type == ::Protobuf::WireType::VARINT
          end
          !last.nil? && @value_field.decode(last).nil?
        end
      end

      # Repeated string, bytes, and message fields. These are never packed.
      class RepeatedNotPackedSetMethod
        include DecodedValue

        def initialize(selph)
          setup_decoded_value(selph)
        end

        def call(message_instance, bytes, wire_type = nil)
          return if wire_type && wire_type != @wire_type
          values_array(message_instance).push_decoded(@selph.decode(bytes))
        end
      end

      # Repeated scalar numeric fields (varint, fixed32, fixed64). The protobuf
      # spec requires a parser to accept both the packed and the unpacked
      # encoding, whatever the field declares. The wire type of each record
      # selects the decoding: LENGTH_DELIMITED is a packed run, and the field's
      # own wire type is one value. A record without a wire type (an old
      # caller of BaseField#set) falls back to the declaration.
      class RepeatedPackableSetMethod
        include DecodedValue

        LENGTH_DELIMITED = ::Protobuf::WireType::LENGTH_DELIMITED

        def initialize(selph)
          setup_decoded_value(selph)
          @packed = selph.packed?
        end

        def call(message_instance, bytes, wire_type = nil)
          # Most common first: one unpacked value, as this gem encodes by default.
          if wire_type == @wire_type
            push_decoded(values_array(message_instance), @selph.decode(bytes))
          elsif wire_type == LENGTH_DELIMITED
            decode_packed(values_array(message_instance), bytes)
          elsif wire_type.nil?
            if @packed
              decode_packed(values_array(message_instance), bytes)
            else
              push_decoded(values_array(message_instance), @selph.decode(bytes))
            end
          end
        end

        private

        def decode_packed(array, bytes)
          stream = ::StringIO.new(bytes)

          if @wire_type == ::Protobuf::WireType::VARINT
            push_decoded(array, @selph.decode(Varint.decode(stream))) until stream.eof?
          elsif @wire_type == ::Protobuf::WireType::FIXED64
            push_decoded(array, @selph.decode(stream.read(8))) until stream.eof?
          elsif @wire_type == ::Protobuf::WireType::FIXED32
            push_decoded(array, @selph.decode(stream.read(4))) until stream.eof?
          end
        end
      end

      class RequiredMapSetField
        def initialize(selph)
          @selph = selph
          @tag = selph.tag
          @fully_qualified_name = selph.fully_qualified_name
        end

        def call(values, value, _ignore_nil_for_repeated, message_instance)
          unless value.is_a?(Hash)
            fail TypeError, <<-TYPE_ERROR
                    Expected map value
                    Got '#{value.class}' for map protobuf field #{@selph.name}
            TYPE_ERROR
          end

          if value.empty?
            values.delete(@fully_qualified_name)
            message_instance._protobuf_message_unset_required_field_tags << @tag
          else
            message_instance._protobuf_message_unset_required_field_tags.delete(@tag)
            values[@fully_qualified_name] ||= ::Protobuf::Field::FieldHash.new(@selph)
            values[@fully_qualified_name].replace(value)
          end
        end
      end

      class MapSetField
        def initialize(selph)
          @selph = selph
          @tag = selph.tag
          @fully_qualified_name = selph.fully_qualified_name
        end

        def call(values, value, _ignore_nil_for_repeated, _message_instance)
          unless value.is_a?(Hash)
            fail TypeError, <<-TYPE_ERROR
                    Expected map value
                    Got '#{value.class}' for map protobuf field #{@selph.name}
            TYPE_ERROR
          end

          if value.empty?
            values.delete(@fully_qualified_name)
          else
            values[@fully_qualified_name] ||= ::Protobuf::Field::FieldHash.new(@selph)
            values[@fully_qualified_name].replace(value)
          end
        end
      end

      class RequiredRepeatedSetField
        def initialize(selph)
          @selph = selph
          @tag = selph.tag
          @fully_qualified_name = selph.fully_qualified_name
        end

        def call(values, value, ignore_nil_for_repeated, message_instance)
          if value.nil? && ignore_nil_for_repeated
            ::Protobuf.deprecator.deprecation_warning("['#{@fully_qualified_name}']=nil", "use an empty array instead of nil")
            return
          end

          unless value.is_a?(Array)
            fail TypeError, <<-TYPE_ERROR
                  Expected repeated value of type '#{@selph.type_class}'
                  Got '#{value.class}' for repeated protobuf field #{@selph.name}
            TYPE_ERROR
          end

          value = value.compact

          if value.empty?
            values.delete(@fully_qualified_name)
            message_instance._protobuf_message_unset_required_field_tags << @tag
          else
            message_instance._protobuf_message_unset_required_field_tags.delete(@tag)
            values[@fully_qualified_name] ||= ::Protobuf::Field::FieldArray.new(@selph)
            values[@fully_qualified_name].replace(value)
          end
        end
      end

      class RepeatedSetField
        def initialize(selph)
          @selph = selph
          @tag = selph.tag
          @fully_qualified_name = selph.fully_qualified_name
        end

        def call(values, value, ignore_nil_for_repeated, _message_instance)
          if value.nil? && ignore_nil_for_repeated
            ::Protobuf.deprecator.deprecation_warning("['#{@fully_qualified_name}']=nil", "use an empty array instead of nil")
            return
          end

          unless value.is_a?(Array)
            fail TypeError, <<-TYPE_ERROR
                  Expected repeated value of type '#{@selph.type_class}'
                  Got '#{value.class}' for repeated protobuf field #{@selph.name}
            TYPE_ERROR
          end

          value = value.compact

          if value.empty?
            values.delete(@fully_qualified_name)
          else
            values[@fully_qualified_name] ||= ::Protobuf::Field::FieldArray.new(@selph)
            values[@fully_qualified_name].replace(value)
          end
        end
      end

      class RequiredStringSetField
        def initialize(selph)
          @selph = selph
          @tag = selph.tag
          @fully_qualified_name = selph.fully_qualified_name
        end

        def call(values, value, _ignore_nil_for_repeated, message_instance)
          if value
            message_instance._protobuf_message_unset_required_field_tags.delete(@tag)
            values[@fully_qualified_name] = if value.is_a?(String)
                                              value
                                            else
                                              @selph.coerce!(value)
                                            end
          else
            values.delete(@fully_qualified_name)
            message_instance._protobuf_message_unset_required_field_tags << @tag
          end
        end
      end

      class StringSetField
        def initialize(selph)
          @selph = selph
          @tag = selph.tag
          @fully_qualified_name = selph.fully_qualified_name
        end

        def call(values, value, _ignore_nil_for_repeated, _message_instance)
          if value
            values[@fully_qualified_name] = if value.is_a?(String)
                                              value
                                            else
                                              @selph.coerce!(value)
                                            end
          else
            values.delete(@fully_qualified_name)
          end
        end
      end

      class RequiredBaseSetField
        def initialize(selph)
          @selph = selph
          @tag = selph.tag
          @fully_qualified_name = selph.fully_qualified_name
        end

        def call(values, value, _ignore_nil_for_repeated, message_instance)
          if value.nil?
            values.delete(@fully_qualified_name)
            message_instance._protobuf_message_unset_required_field_tags << @tag
          else
            message_instance._protobuf_message_unset_required_field_tags.delete(@tag)
            values[@fully_qualified_name] = @selph.coerce!(value)
          end
        end
      end

      class BaseSetField
        def initialize(selph)
          @selph = selph
          @tag = selph.tag
          @fully_qualified_name = selph.fully_qualified_name
        end

        def call(values, value, _ignore_nil_for_repeated, _message_instance)
          if value.nil?
            values.delete(@fully_qualified_name)
          else
            values[@fully_qualified_name] = @selph.coerce!(value)
          end
        end
      end

      class BaseFieldAndPresentPredicate
        def initialize(selph)
          @fully_qualified_name = selph.fully_qualified_name
        end

        def call(values)
          values[@fully_qualified_name].present?
        end
      end

      class BoolFieldAndPresentPredicate
        BOOL_VALUES = [true, false].freeze

        def initialize(selph)
          @fully_qualified_name = selph.fully_qualified_name
        end

        def call(values)
          BOOL_VALUES.include?(values[@fully_qualified_name])
        end
      end

      class BaseFieldPredicate
        def initialize(selph)
          @fully_qualified_name = selph.fully_qualified_name
        end

        def call(values)
          values.key?(@fully_qualified_name)
        end
      end

      class RepeatedFieldPredicate
        def initialize(selph)
          @fully_qualified_name = selph.fully_qualified_name
        end

        def call(values)
          values.key?(@fully_qualified_name) &&
            values[@fully_qualified_name].present?
        end
      end

      class BoolFieldValueFromValues
        def initialize(selph)
          @selph = selph
          @fully_qualified_name = selph.fully_qualified_name
        end

        def call(values)
          values.fetch(@fully_qualified_name) { @selph.default_value }
        end
      end

      class BoolFieldValueFromValuesForSerialization
        def initialize(selph)
          @selph = selph
          @fully_qualified_name = selph.fully_qualified_name
        end

        def call(values)
          values.fetch(@fully_qualified_name) { @selph.default_value }
        end
      end

      class BaseFieldValueFromValues
        def initialize(selph)
          @selph = selph
          @fully_qualified_name = selph.fully_qualified_name
        end

        def call(values)
          values[@fully_qualified_name] || @selph.default_value
        end
      end

      class BaseFieldValueFromValuesForSerialization
        def initialize(selph)
          @selph = selph
          @fully_qualified_name = selph.fully_qualified_name
        end

        def call(values)
          values[@fully_qualified_name] || @selph.default_value
        end
      end

      class MapValueFromValues
        def initialize(selph)
          @selph = selph
          @fully_qualified_name = selph.fully_qualified_name
        end

        def call(values)
          values[@fully_qualified_name] ||= ::Protobuf::Field::FieldHash.new(@selph)
        end
      end

      class MapValueFromValuesForSerialization
        def initialize(selph)
          @selph = selph
          @fully_qualified_name = selph.fully_qualified_name
          @type_class = selph.type_class
        end

        def call(values)
          value = values[@fully_qualified_name] ||= ::Protobuf::Field::FieldHash.new(@selph)

          array = []
          value.each do |k, v|
            array << @type_class.new(:key => k, :value => v)
          end

          array
        end
      end

      class RepeatedFieldValueFromValues
        def initialize(selph)
          @selph = selph
          @fully_qualified_name = selph.fully_qualified_name
        end

        def call(values)
          values[@fully_qualified_name] ||= ::Protobuf::Field::FieldArray.new(@selph)
        end
      end

      class RepeatedFieldValueFromValuesForSerialization
        def initialize(selph)
          @selph = selph
          @fully_qualified_name = selph.fully_qualified_name
        end

        def call(values)
          values[@fully_qualified_name] ||= ::Protobuf::Field::FieldArray.new(@selph)
        end
      end
    end
  end
end
