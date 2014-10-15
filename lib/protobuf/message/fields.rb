require 'protobuf/deprecator'

module Protobuf
  class Message
    module Fields

      def self.extended(other)
        other.extend(::Protobuf::Deprecator)
        other.deprecate_class_method(:get_ext_field_by_name, :get_extension_field)
        other.deprecate_class_method(:get_ext_field_by_tag, :get_extension_field)
        other.deprecate_class_method(:get_field_by_name, :get_field)
        other.deprecate_class_method(:get_field_by_tag, :get_field)
      end

      ##
      # Field Definition Methods
      #

      # Define an optional field.
      #
      def optional(type_class, name, tag, options = {})
        define_field(:optional, type_class, name, tag, options)
      end

      # Define a repeated field.
      #
      def repeated(type_class, name, tag, options = {})
        define_field(:repeated, type_class, name, tag, options)
      end

      # Define a required field.
      #
      def required(type_class, name, tag, options = {})
        define_field(:required, type_class, name, tag, options)
      end

      # Define an extension range.
      #
      def extensions(range)
        extension_ranges << range
      end

      ##
      # Field Access Methods
      #

      def all_fields
        @all_fields ||= field_store.values.uniq.sort_by(&:tag)
      end

      def extension_fields
        @extension_fields ||= all_fields.select(&:extension?)
      end

      def extension_ranges
        @extension_ranges ||= []
      end

      def extension_tag?(tag)
        tag.respond_to?(:to_i) && get_extension_field(tag).present?
      end

      def field_store
        @field_store ||= {}
      end

      def fields
        @fields ||= all_fields.reject(&:extension?)
      end

      def field_tag?(tag, allow_extension = false)
        tag.respond_to?(:to_i) && get_field(tag, allow_extension).present?
      end

      def get_extension_field(name_or_tag)
        name_or_tag = name_or_tag.to_sym if name_or_tag.respond_to?(:to_sym)
        field = field_store[name_or_tag]
        field if field.try(:extension?) { false }
      end

      def get_field(name_or_tag, allow_extension = false)
        name_or_tag = name_or_tag.to_sym if name_or_tag.respond_to?(:to_sym)
        field = field_store[name_or_tag]

        if field && (allow_extension || ! field.extension?)
          field
        else
          nil
        end
      end

      def define_field(rule, type_class, field_name, tag, options)
        raise_if_tag_collision(tag, field_name)
        raise_if_name_collision(field_name)

        field = ::Protobuf::Field.build(self, rule, type_class, field_name, tag, options)
        field_store[field_name] = field
        field_store[tag] = field

        class_eval(<<-RAW_GETTER, __FILE__, __LINE__ + 1)
          define_method("#{field_name}!") do
            @values[:#{field_name}]
          end
        RAW_GETTER
      end

      def raise_if_tag_collision(tag, field_name)
        if get_field(tag, true)
          raise TagCollisionError, %(Field number #{tag} has already been used in "#{name}" by field "#{field_name}".)
        end
      end

      def raise_if_name_collision(field_name)
        if get_field(field_name, true)
          raise DuplicateFieldNameError, %(Field name #{field_name} has already been used in "#{name}".)
        end
      end

    end
  end
end
