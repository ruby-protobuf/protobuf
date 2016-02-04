module Protobuf
  class Message
    module Fields

      def self.extended(other)
        other.extend(ClassMethods)
        ::Protobuf.deprecator.define_deprecated_methods(
          other.singleton_class,
          :get_ext_field_by_name => :get_extension_field,
          :get_ext_field_by_tag => :get_extension_field,
          :get_field_by_name => :get_field,
          :get_field_by_tag => :get_field,
        )
      end

      module ClassMethods
        def inherited(subclass)
          inherit_fields!(subclass)
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
          field = field_store[name_or_tag]
          field if field.try(:extension?) { false }
        end

        def get_field(name_or_tag, allow_extension = false)
          field = field_store[name_or_tag]

          if field && (allow_extension || !field.extension?)
            field
          else
            nil
          end
        end

        def define_field(rule, type_class, field_name, tag, options)
          raise_if_tag_collision(tag, field_name)
          raise_if_name_collision(field_name)

          field = ::Protobuf::Field.build(self, rule, type_class, field_name, tag, options)
          field_store[tag] = field
          field_store[field_name] = field
          field_store[field_name.to_s] = field
          # defining a new field for the message will cause cached @all_fields, @extension_fields,
          # and @fields to be incorrect; reset them
          @all_fields = @extension_fields = @fields = nil

          define_method("#{field_name}!") do
            @values[field_name]
          end
        end

        def raise_if_tag_collision(tag, field_name)
          if get_field(tag, true)
            fail TagCollisionError, %(Field number #{tag} has already been used in "#{name}" by field "#{field_name}".)
          end
        end

        def raise_if_name_collision(field_name)
          if get_field(field_name, true)
            fail DuplicateFieldNameError, %(Field name #{field_name} has already been used in "#{name}".)
          end
        end

        def inherit_fields!(subclass)
          instance_variables.each do |iv|
            subclass.instance_variable_set(iv, instance_variable_get(iv))
          end
        end
        private :inherit_fields!

      end
    end
  end
end
