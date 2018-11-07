require 'protobuf/generators/base'

module Protobuf
  module Generators
    class FieldGenerator < Base

      ##
      # Constants
      #
      PROTO_INFINITY_DEFAULT          = /^inf$/i
      PROTO_NEGATIVE_INFINITY_DEFAULT = /^-inf$/i
      PROTO_NAN_DEFAULT               = /^nan$/i
      RUBY_INFINITY_DEFAULT           = '::Float::INFINITY'.freeze
      RUBY_NEGATIVE_INFINITY_DEFAULT  = '-::Float::INFINITY'.freeze
      RUBY_NAN_DEFAULT                = '::Float::NAN'.freeze

      ##
      # Attributes
      #
      attr_reader :field_options

      def initialize(field_descriptor, enclosing_msg_descriptor, indent_level)
        super(field_descriptor, indent_level)
        @enclosing_msg_descriptor = enclosing_msg_descriptor
      end

      def applicable_options
        # Note on the strange use of `#inspect`:
        #   :boom.inspect #=> ":boom"
        #   :".boom.foo".inspect #=> ":\".boom.foo\""
        # An alternative to `#inspect` would be always adding double quotes,
        # but the generatated code looks un-idiomatic:
        #   ":\"#{:boom}\"" #=> ":\"boom\"" <-- Note the unnecessary double quotes
        @applicable_options ||= field_options.map { |k, v| "#{k.inspect} => #{v}" }
      end

      def default_value
        @default_value ||= begin
                             if defaulted?
                               case descriptor.type.name
                               when :TYPE_ENUM
                                 enum_default_value
                               when :TYPE_STRING, :TYPE_BYTES
                                 string_default_value
                               when :TYPE_FLOAT, :TYPE_DOUBLE
                                 float_double_default_value
                               else
                                 verbatim_default_value
                               end
                             end
                           end
      end

      def defaulted?
        descriptor.respond_to_has_and_present?(:default_value)
      end

      def deprecated?
        descriptor.options.try(:deprecated?) { false }
      end

      def extension?
        descriptor.respond_to_has_and_present?(:extendee)
      end

      def compile
        run_once(:compile) do
          field_definition = if map?
                               ["map #{map_key_type_name}", map_value_type_name, name, number, applicable_options]
                             else
                               ["#{label} #{type_name}", name, number, applicable_options]
                             end
          puts field_definition.flatten.compact.join(', ')

          access_methods_for_serialization
        end
      end

      def label
        @label ||= descriptor.label.name.to_s.downcase.sub(/label_/, '') # required, optional, repeated
      end

      def name
        @name ||= descriptor.name.to_sym.inspect
      end

      def number
        @number ||= descriptor.number
      end

      def number_tag_encoded
        value = if repeated? && packed?
                  ((number << 3) | ::Protobuf::WireType::LENGTH_DELIMITED)
                else
                  ((number << 3) | wire_type)
                end

        bytes = []
        until value < 128
          bytes << (0x80 | (value & 0x7f))
          value >>= 7
        end
        (bytes << value).pack('C*')
      end

      def field_options
        @field_options ||= begin
                             opts = {}
                             opts[:default] = default_value if defaulted?
                             opts[:packed] = 'true' if packed?
                             opts[:deprecated] = 'true' if deprecated?
                             opts[:extension] = 'true' if extension?
                             if descriptor.options
                               descriptor.options.each_field do |field_option|
                                 next unless descriptor.options.field?(field_option.name)
                                 option_value = descriptor.options[field_option.name]
                                 opts[field_option.fully_qualified_name] = serialize_value(option_value)
                               end
                             end
                             opts
                           end
      end

      def packed?
        descriptor.options.try(:packed?) { false }
      end

      # Determine the field type
      def type_name
        @type_name ||= determine_type_name(descriptor)
      end

      # If this field is a map field, this returns a message descriptor that
      # represents the entries in the map. Returns nil if this field is not
      # a map field.
      def map_entry
        @map_entry ||= determine_map_entry
      end

      def map?
        !map_entry.nil?
      end

      def map_key_type_name
        return nil if map_entry.nil?
        determine_type_name(map_entry.field.find { |v| v.name == 'key' && v.number == 1 })
      end

      def map_value_type_name
        return nil if map_entry.nil?
        determine_type_name(map_entry.field.find { |v| v.name == 'value' && v.number == 2 })
      end

      def repeated?
        label =~ /repeated/i
      end

      private

      def access_methods_for_serialization
        method_def = case
                     when map?
                       <<~RUBY

                         def _protobuf_message_set_field_#{number}_bytes(bytes)
                           _protobuf_message_set_field_#{number}(#{field_type_decoder}, true)
                         end
                         alias_method :_protobuf_message_set_field_#{descriptor.name}_bytes, :_protobuf_message_set_field_#{number}_bytes

                          def _protobuf_message_set_field_#{number}(field, value, ignore_nil_for_repeated)
                            unless value.is_a?(Hash)
                              fail TypeError, <<-TYPE_ERROR
                                  Expected map value
                                  Got '\#{value.class}' for map protobuf field \#{field.name}
                              TYPE_ERROR
                            end

                            if value.empty?
                              @values.delete(#{name})
                            else
                              @values[#{name}] ||= ::Protobuf::Field::FieldHash.new(field)
                              @values[#{name}].replace(value)
                            end
                          end
                          alias_method :_protobuf_message_set_field_#{descriptor.name}, :_protobuf_message_set_field_#{number}

                      RUBY
                     when repeated?
                       method_defs = <<~RUBY

                          def _protobuf_message_set_field_#{number}_bytes(bytes)
                            _protobuf_message_set_field_#{number}(#{field_type_decoder}, true)
                          end
                          alias_method :_protobuf_message_set_field_#{descriptor.name}_bytes, :_protobuf_message_set_field_#{number}_bytes

                          def _protobuf_message_set_field_#{number}(field, value, ignore_nil_for_repeated)
                            if value.nil? && ignore_nil_for_repeated
                              ::Protobuf.deprecator.deprecation_warning("[#{name}]=nil", "use an empty array instead of nil")
                              return
                            end
                            unless value.is_a?(Array)
                              fail TypeError, <<-TYPE_ERROR
                                  Expected repeated value of type #{type_name}
                                  Got \#{value.class} for repeated protobuf field #{name}
                              TYPE_ERROR
                            end
 
                            value = value.compact
 
                            if value.empty?
                              @values.delete(#{name})
                            else
                              @values[#{name}] ||= ::Protobuf::Field::FieldArray.new(field)
                              @values[#{name}].replace(value)
                            end
                          end
                          alias_method :_protobuf_message_set_field_#{descriptor.name}, :_protobuf_message_set_field_#{number}

                      RUBY

                      if packed?
                        method_defs << <<~RUBY


                        RUBY
                      else
                        method_defs << <<~RUBY
                        

                        RUBY
                      end

                      method_defs
                     else
                       <<~RUBY

                          def _protobuf_message_set_field_#{number}_bytes(bytes)
                            _protobuf_message_set_field_#{number}(#{field_type_decoder}, true)
                          end
                          alias_method :_protobuf_message_set_field_#{descriptor.name}_bytes, :_protobuf_message_set_field_#{number}_bytes

                          def _protobuf_message_set_field_#{number}(value, ignore_nil_for_repeated)
                            if value.nil? # rubocop:disable Style/IfInsideElse
                              @values.delete(#{name})
                            else
                              @values[#{name}] = #{value_coercion}
                            end
                          end
                          alias_method :_protobuf_message_set_field_#{descriptor.name}, :_protobuf_message_set_field_#{number}

                       RUBY
                     end

        method_def.each_line do |line|
          puts line
        end
      end

      def enum_default_value
        optionally_upcased_default =
          if ENV.key?('PB_UPCASE_ENUMS')
            verbatim_default_value.upcase
          else
            verbatim_default_value
          end
        "#{type_name}::#{optionally_upcased_default}"
      end

      def float_double_default_value
        case verbatim_default_value
        when PROTO_INFINITY_DEFAULT then
          RUBY_INFINITY_DEFAULT
        when PROTO_NEGATIVE_INFINITY_DEFAULT then
          RUBY_NEGATIVE_INFINITY_DEFAULT
        when PROTO_NAN_DEFAULT then
          RUBY_NAN_DEFAULT
        else
          verbatim_default_value
        end
      end

      def string_default_value
        %("#{verbatim_default_value.gsub(/'/, '\\\\\'')}")
      end

      def verbatim_default_value
        descriptor.default_value
      end

      def determine_type_name(descriptor)
        case descriptor.type.name
        when :TYPE_MESSAGE, :TYPE_ENUM, :TYPE_GROUP then
          modulize(descriptor.type_name)
        else
          type_name = descriptor.type.name.to_s.downcase.sub(/^type_/, '')
          ":#{type_name}"
        end
      end

      def determine_map_entry
        return nil if @enclosing_msg_descriptor.nil?
        return nil unless descriptor.label.name == :LABEL_REPEATED && descriptor.type.name == :TYPE_MESSAGE
        # find nested message type
        name_parts = descriptor.type_name.split(".")
        return nil if name_parts.size < 2 || name_parts[-2] != @enclosing_msg_descriptor.name
        nested = @enclosing_msg_descriptor.nested_type.find { |e| e.name == name_parts[-1] }
        return nested if !nested.nil? && nested.options.try(:map_entry?)
        nil
      end

      def field_type_encoder
        case descriptor.type.name
        when :TYPE_ENUM
          "::Protobuf::Field::IntegerField::encode(value.to_i)"
        when :TYPE_STRING
          "::Protobuf::Field::StringField.encode(value)"
        when :TYPE_BYTES
          "::Protobuf::Field::BytesField.encode(value)"
        when :TYPE_FLOAT
          "::Protobuf::Field::FloatField.encode(value)"
        when :TYPE_DOUBLE
          "::Protobuf::Field::DoubleField.encode(value)"
        when :TYPE_INT64
          "::Protobuf::Field::Int64Field.encode(value)"
        when :TYPE_UINT64
          "::Protobuf::Field::Uint64.encode(value)"
        when :TYPE_INT32
          "::Protobuf::Field::Int32Field.encode(value)"
        when :TYPE_FIXED64
          "::Protobuf::Field::Fixed64.encode(value)"
        when :TYPE_FIXED32
          "::Protobuf::Field::Fixed32.encode(value)"
        when :TYPE_BOOL
          "::Protobuf::Field::BoolField.encode(value)"
        when :TYPE_MESSAGE
          "#{type_name}.encode(value)" # TODO: verify this
        when :TYPE_UINT32
          "::Protobuf::Field::Uint32.encode(value)"
        when :TYPE_SFIXED32
          "::Protobuf::Field::Sfixed32.encode(value)"
        when :TYPE_SFIXED64
          "::Protobuf::Field::Sfixed64.encode(value)"
        when :TYPE_SINT32
          "::Protobuf::Field::Sint32Field.encode(value)"
        when :TYPE_SINT64
          "::Protobuf::Field::Sint64Field.encode(value)"
        end
      end

      def field_type_decoder
        case descriptor.type.name
        when :TYPE_ENUM
          "#{type_name}.fetch(::Protobuf::Field::IntegerField::decode(bytes))"
        when :TYPE_STRING
          "::Protobuf::Field::StringField.decode(bytes)"
        when :TYPE_BYTES
          "::Protobuf::Field::BytesField.decode(bytes)"
        when :TYPE_FLOAT
          "::Protobuf::Field::FloatField.decode(bytes)"
        when :TYPE_DOUBLE
          "::Protobuf::Field::DoubleField.decode(bytes)"
        when :TYPE_INT64
          "::Protobuf::Field::Int64Field.decode(bytes)"
        when :TYPE_UINT64
          "::Protobuf::Field::Uint64.decode(bytes)"
        when :TYPE_INT32
          "::Protobuf::Field::Int32Field.decode(bytes)"
        when :TYPE_FIXED64
          "::Protobuf::Field::Fixed64.decode(bytes)"
        when :TYPE_FIXED32
          "::Protobuf::Field::Fixed32.decode(bytes)"
        when :TYPE_BOOL
          "::Protobuf::Field::BoolField.decode(bytes)"
        when :TYPE_MESSAGE
          "#{type_name}.decode(bytes)"
        when :TYPE_UINT32
          "::Protobuf::Field::Uint32.decode(bytes)"
        when :TYPE_SFIXED32
          "::Protobuf::Field::Sfixed32.decode(bytes)"
        when :TYPE_SFIXED64
          "::Protobuf::Field::Sfixed64.decode(bytes)"
        when :TYPE_SINT32
          "::Protobuf::Field::Sint32Field.decode(bytes)"
        when :TYPE_SINT64
          "::Protobuf::Field::Sint64Field.decode(bytes)"
        end
      end

      def value_coercion
        case descriptor.type.name
        when :TYPE_ENUM
          "value"
        when :TYPE_STRING
          "::Protobuf::Field::BytesField.coerce!(value)"
        when :TYPE_BYTES
          "::Protobuf::Field::BytesField.coerce!(value)"
        when :TYPE_FLOAT
          "::Protobuf::Field::FloatField.coerce!(value)"
        when :TYPE_DOUBLE
          "::Protobuf::Field::FloatField.coerce!(value)"
        when :TYPE_INT64
          "::Protobuf::Field::Int64Field.coerce!(value)"
        when :TYPE_UINT64
          "::Protobuf::Field::Uint64Field.coerce!(value)"
        when :TYPE_INT32
          "::Protobuf::Field::Int32Field.coerce!(value)"
        when :TYPE_FIXED64
          "::Protobuf::Field::Uint64Field.coerce!(value)"
        when :TYPE_FIXED32
          "::Protobuf::Field::Uint32Field.coerce!(value)"
        when :TYPE_BOOL
          "::Protobuf::Field::BoolField.coerce!(value)"
        when :TYPE_MESSAGE
          "value"
        when :TYPE_UINT32
          "::Protobuf::Field::Uint32Field.coerce!(value)"
        when :TYPE_SFIXED32
          "::Protobuf::Field::Int32Field.coerce!(value)"
        when :TYPE_SFIXED64
          "::Protobuf::Field::Int64Field.coerce!(value)"
        when :TYPE_SINT32
          "::Protobuf::Field::Sint32Field.coerce!(value)"
        when :TYPE_SINT64
          "::Protobuf::Field::Sint64Field.coerce!(value)"
        end
      end

      def wire_type
        case descriptor.type.name
        when :TYPE_ENUM
          ::Protobuf::WireType::VARINT
        when :TYPE_STRING
          ::Protobuf::WireType::LENGTH_DELIMITED
        when :TYPE_BYTES
          ::Protobuf::WireType::LENGTH_DELIMITED
        when :TYPE_FLOAT
          ::Protobuf::WireType::FIXED32
        when :TYPE_DOUBLE
          ::Protobuf::WireType::FIXED64
        when :TYPE_INT64
          ::Protobuf::WireType::VARINT
        when :TYPE_UINT64
          ::Protobuf::WireType::VARINT
        when :TYPE_INT32
          ::Protobuf::WireType::VARINT
        when :TYPE_FIXED64
          ::Protobuf::WireType::FIXED64
        when :TYPE_FIXED32
          ::Protobuf::WireType::FIXED32
        when :TYPE_BOOL
          ::Protobuf::WireType::VARINT
        when :TYPE_MESSAGE
          ::Protobuf::WireType::LENGTH_DELIMITED
        when :TYPE_UINT32
          ::Protobuf::WireType::VARINT
        when :TYPE_SFIXED32
          ::Protobuf::WireType::FIXED32
        when :TYPE_SFIXED64
          ::Protobuf::WireType::FIXED64
        when :TYPE_SINT32
          ::Protobuf::WireType::VARINT
        when :TYPE_SINT64
          ::Protobuf::WireType::VARINT
        end
      end

    end
  end
end
