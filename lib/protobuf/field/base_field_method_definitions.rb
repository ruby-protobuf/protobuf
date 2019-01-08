module Protobuf
  module Field
    class BaseFieldMethodDefinitions

      def self.fully_qualified_name_string(selph)
        fully_qualified_name = ":"
        fully_qualified_name << '"' if selph.fully_qualified_name.to_s.start_with?(".")
        fully_qualified_name << selph.fully_qualified_name.to_s
        fully_qualified_name << '"' if selph.fully_qualified_name.to_s.start_with?(".")
        fully_qualified_name
      end

      def self.define_to_hash_value_to_message_hash!(selph)
        selph.instance_eval <<-RUBY, __FILE__, __LINE__ + 1
          def to_message_hash(values, result)
            result[#{selph.name.inspect}] = value_from_values(values).to_hash_value
          end
        RUBY
      end

      def self.define_base_to_message_hash!(selph)
        selph.instance_eval <<-RUBY, __FILE__, __LINE__ + 1
          def to_message_hash(values, result)
            result[#{selph.name.inspect}] = value_from_values(values)
          end
        RUBY
      end

      def self.define_repeated_packed_encode_to_stream_method!(selph)
        selph.instance_eval <<-RUBY, __FILE__, __LINE__ + 1
          def encode_to_stream(value, stream)
            packed_value = value.map { |val| encode(val) }.join
            stream << #{selph.tag_encoded.dump} << "\#{::Protobuf::Field::VarintField.encode(packed_value.size)}\#{packed_value}"
          end
        RUBY
      end

      def self.define_bytes_encode_to_stream_method!(selph)
        selph.instance_eval <<-RUBY, __FILE__, __LINE__ + 1
          def encode_to_stream(value, stream)
            value = value.encode if value.is_a?(::Protobuf::Message)
            byte_size = ::Protobuf::Field::VarintField.encode(value.bytesize)

            stream << #{selph.tag_encoded.dump} << byte_size << value
          end
        RUBY
      end

      def self.define_string_encode_to_stream_method!(selph)
        selph.instance_eval <<-RUBY, __FILE__, __LINE__ + 1
          def encode_to_stream(value, stream)
            new_value = "" + value
            if new_value.encoding != ::Protobuf::Field::StringField::ENCODING
              new_value.encode!(::Protobuf::Field::StringField::ENCODING, :invalid => :replace, :undef => :replace, :replace => "")
            end

            stream << #{selph.tag_encoded.dump} << ::Protobuf::Field::VarintField.encode(new_value.bytesize) << new_value
          end
        RUBY
      end

      def self.define_base_encode_to_stream_method!(selph)
        selph.instance_eval <<-RUBY, __FILE__, __LINE__ + 1
          def encode_to_stream(value, stream)
            stream << #{selph.tag_encoded.dump} << encode(value)
          end
        RUBY
      end

      def self.define_repeated_not_packed_encode_to_stream_method!(selph)
        selph.instance_eval <<-RUBY, __FILE__, __LINE__ + 1
          def encode_to_stream(value, stream)
            value.each do |val|
              stream << #{selph.tag_encoded.dump} << encode(val)
            end
          end
        RUBY
      end

      def self.define_base_set_method!(selph)
        selph.instance_eval <<-RUBY, __FILE__, __LINE__ + 1
          def set(message_instance, bytes)
            message_instance.set_field("#{selph.name}", decode(bytes), true, self)
          end
        RUBY
      end

      def self.define_map_set_method!(selph)
        selph.instance_eval <<-RUBY, __FILE__, __LINE__ + 1
          def set(message_instance, bytes)
            hash = message_instance["#{selph.name}"]
            entry = decode(bytes)
            # decoded value could be nil for an
            # enum value that is not recognized
            hash[entry.key] = entry.value unless entry.value.nil?
            hash[entry.key]
          end
        RUBY
      end

      def self.define_repeated_not_packed_set_method!(selph)
        selph.instance_eval <<-RUBY, __FILE__, __LINE__ + 1
          def set(message_instance, bytes)
            message_instance["#{selph.name}"] << decode(bytes)
          end
        RUBY
      end

      def self.define_repeated_packed_set_method!(selph)
        selph.instance_eval <<-RUBY, __FILE__, __LINE__ + 1
          def set(message_instance, bytes)
            array = message_instance["#{selph.name}"]
            stream = ::StringIO.new(bytes)

            if wire_type == ::Protobuf::WireType::VARINT
              array << decode(Varint.decode(stream)) until stream.eof?
            elsif wire_type == ::Protobuf::WireType::FIXED64
              array << decode(stream.read(8)) until stream.eof?
            elsif wire_type == ::Protobuf::WireType::FIXED32
              array << decode(stream.read(4)) until stream.eof?
            end
          end
        RUBY
      end

      def self.define_map_set_field!(selph)
        if selph.required?
          selph.instance_eval <<-RUBY, __FILE__, __LINE__ + 1
            def set_field(values, value, ignore_nil_for_repeated, message_instance)
              unless value.is_a?(Hash)
                fail TypeError, <<-TYPE_ERROR
                    Expected map value
                    Got '\#{value.class}' for map protobuf field #{selph.name}
                TYPE_ERROR
              end

              if value.empty?
                values.delete(#{fully_qualified_name_string(selph)})
                message_instance._protobuf_message_unset_required_field_tags << #{selph.tag}
              else
                message_instance._protobuf_message_unset_required_field_tags.delete(#{selph.tag})
                values[#{fully_qualified_name_string(selph)}] ||= ::Protobuf::Field::FieldHash.new(self)
                values[#{fully_qualified_name_string(selph)}].replace(value)
              end
            end
          RUBY
        else
          selph.instance_eval <<-RUBY, __FILE__, __LINE__ + 1
            def set_field(values, value, ignore_nil_for_repeated, message_instance)
              unless value.is_a?(Hash)
                fail TypeError, <<-TYPE_ERROR
                    Expected map value
                    Got '\#{value.class}' for map protobuf field #{selph.name}
                TYPE_ERROR
              end

              if value.empty?
                values.delete(#{fully_qualified_name_string(selph)})
              else
                values[#{fully_qualified_name_string(selph)}] ||= ::Protobuf::Field::FieldHash.new(self)
                values[#{fully_qualified_name_string(selph)}].replace(value)
              end
            end
          RUBY
        end
      end

      def self.define_required_repeated_set_field!(selph)
        selph.instance_eval <<-RUBY, __FILE__, __LINE__ + 1
          def set_field(values, value, ignore_nil_for_repeated, message_instance)
            if value.nil? && ignore_nil_for_repeated
              ::Protobuf.deprecator.deprecation_warning("['#{fully_qualified_name_string(selph)}']=nil", "use an empty array instead of nil")
              return
            end

            unless value.is_a?(Array)
              fail TypeError, <<-TYPE_ERROR
                  Expected repeated value of type '#{selph.type_class}'
                  Got '\#{value.class}' for repeated protobuf field #{selph.name}
              TYPE_ERROR
            end

            value = value.compact

            if value.empty?
              values.delete(#{fully_qualified_name_string(selph)})
              message_instance._protobuf_message_unset_required_field_tags << #{selph.tag}
            else
              message_instance._protobuf_message_unset_required_field_tags.delete(#{selph.tag})
              values[#{fully_qualified_name_string(selph)}] ||= ::Protobuf::Field::FieldArray.new(self)
              values[#{fully_qualified_name_string(selph)}].replace(value)
            end
          end
        RUBY
      end

      def self.define_repeated_set_field!(selph)
        if selph.required?
          define_required_repeated_set_field!(selph)
        else
          selph.instance_eval <<-RUBY, __FILE__, __LINE__ + 1
            def set_field(values, value, ignore_nil_for_repeated, message_instance)
              if value.nil? && ignore_nil_for_repeated
                ::Protobuf.deprecator.deprecation_warning("['#{fully_qualified_name_string(selph)}']=nil", "use an empty array instead of nil")
                return
              end

              unless value.is_a?(Array)
                fail TypeError, <<-TYPE_ERROR
                    Expected repeated value of type '#{selph.type_class}'
                    Got '\#{value.class}' for repeated protobuf field #{selph.name}
                TYPE_ERROR
              end

              value = value.compact

              if value.empty?
                values.delete(#{fully_qualified_name_string(selph)})
              else
                values[#{fully_qualified_name_string(selph)}] ||= ::Protobuf::Field::FieldArray.new(self)
                values[#{fully_qualified_name_string(selph)}].replace(value)
              end
            end
          RUBY
        end
      end

      def self.define_string_set_field!(selph)
        if selph.required?
          selph.instance_eval <<-RUBY, __FILE__, __LINE__ + 1
            def set_field(values, value, ignore_nil_for_repeated, message_instance)
              if value.nil?
                values.delete(#{fully_qualified_name_string(selph)})
                message_instance._protobuf_message_unset_required_field_tags << #{selph.tag}
              else
                message_instance._protobuf_message_unset_required_field_tags.delete(#{selph.tag})
                values[#{fully_qualified_name_string(selph)}] = if value.is_a?(String)
                                                                  value
                                                                else
                                                                  coerce!(value)
                                                                end
              end
            end
          RUBY
        else
          selph.instance_eval <<-RUBY, __FILE__, __LINE__ + 1
            def set_field(values, value, ignore_nil_for_repeated, message_instance)
              if value.nil?
                values.delete(#{fully_qualified_name_string(selph)})
              else
                values[#{fully_qualified_name_string(selph)}] = if value.is_a?(String)
                                                                  value
                                                                else
                                                                  coerce!(value)
                                                                end
              end
            end
          RUBY
        end
      end

      def self.define_base_set_field!(selph)
        if selph.required?
          selph.instance_eval <<-RUBY, __FILE__, __LINE__ + 1
            def set_field(values, value, ignore_nil_for_repeated, message_instance)
              if value.nil?
                values.delete(#{fully_qualified_name_string(selph)})
                message_instance._protobuf_message_unset_required_field_tags << #{selph.tag}
              else
                message_instance._protobuf_message_unset_required_field_tags.delete(#{selph.tag})
                values[#{fully_qualified_name_string(selph)}] = coerce!(value)
              end
            end
          RUBY
        else
          selph.instance_eval <<-RUBY, __FILE__, __LINE__ + 1
            def set_field(values, value, ignore_nil_for_repeated, message_instance)
              if value.nil?
                values.delete(#{fully_qualified_name_string(selph)})
              else
                values[#{fully_qualified_name_string(selph)}] = coerce!(value)
              end
            end
          RUBY
        end
      end

      def self.define_base_field_and_present_p!(selph)
        selph.instance_eval <<-RUBY, __FILE__, __LINE__ + 1
          def field_and_present?(values)
            values[#{fully_qualified_name_string(selph)}].present?
          end
        RUBY
      end

      def self.define_bool_field_and_present_p!(selph)
        selph.instance_eval <<-RUBY, __FILE__, __LINE__ + 1
          BOOL_VALUES = [true, false].freeze unless defined?(BOOL_VALUES)

          def field_and_present?(values)
            BOOL_VALUES.include?(values[#{fully_qualified_name_string(selph)}])
          end
        RUBY
      end

      def self.define_base_field_p!(selph)
        selph.instance_eval <<-RUBY, __FILE__, __LINE__ + 1
          def field?(values)
            values.key?(#{fully_qualified_name_string(selph)})
          end
        RUBY
      end

      def self.define_repeated_field_p!(selph)
        selph.instance_eval <<-RUBY, __FILE__, __LINE__ + 1
          def field?(values)
            values.key?(#{fully_qualified_name_string(selph)}) && values[#{fully_qualified_name_string(selph)}].present?
          end
        RUBY
      end

      def self.define_bool_field_value_from_values!(selph)
        selph.instance_eval <<-RUBY, __FILE__, __LINE__ + 1
          def value_from_values(values)
            values.fetch(#{fully_qualified_name_string(selph)}) {  default_value }
          end
          alias :value_from_values_for_serialization value_from_values
        RUBY
      end

      def self.define_field_value_from_values!(selph)
        selph.instance_eval <<-RUBY, __FILE__, __LINE__ + 1
          def value_from_values(values)
            values[#{fully_qualified_name_string(selph)}] || default_value
          end
          alias :value_from_values_for_serialization value_from_values
        RUBY
      end

      def self.define_map_value_from_values!(selph)
        selph.instance_eval <<-RUBY, __FILE__, __LINE__ + 1
          def value_from_values(values)
            values[#{fully_qualified_name_string(selph)}] ||= ::Protobuf::Field::FieldHash.new(self)
          end

          def value_from_values_for_serialization(values)
            value = value_from_values(values)

            array = []
            value.each do |k, v|
              array << type_class.new(:key => k, :value => v)
            end

            array
          end
        RUBY
      end

      def self.define_repeated_value_from_values!(selph)
        selph.instance_eval <<-RUBY, __FILE__, __LINE__ + 1
          def value_from_values(values)
            values[#{fully_qualified_name_string(selph)}] ||= ::Protobuf::Field::FieldArray.new(self)
          end
          alias :value_from_values_for_serialization value_from_values
        RUBY
      end

    end
  end
end
