module Protobuf
  class Message
    module DSL
      module Fields

        ##
        # Field Definition Methods
        #

        # Define an optional field.
        #
        def optional(type, name, tag, options = {})
          define_field(:optional, type, name, tag, options)
        end

        # Define a repeated field.
        #
        def repeated(type, name, tag, options = {})
          define_field(:repeated, type, name, tag, options)
        end

        # Define a required field.
        #
        def required(type, name, tag, options = {})
          define_field(:required, type, name, tag, options)
        end

        # Define an extension range.
        #
        def extensions(range)
          extension_fields.add_range(range)
        end

        ##
        # Field Access Methods
        #

        def all_fields
          @all_fields ||= begin
                            all_fields_array = []
                            max_fields = fields.size > extension_fields.size ? fields.size : extension_fields.size
                            max_fields.times do |field_number|
                              all_fields_array << (fields[field_number] || extension_fields[field_number])
                            end
                            all_fields_array.compact!
                            all_fields_array
                          end
        end

        def extension_fields
          @extension_fields ||= ::Protobuf::Field::ExtensionFields.new
        end

        def extension_field_name_to_tag
          @extension_fields_by_name ||= {}
        end

        def extension_tag?(tag)
          extension_fields.include_tag?(tag)
        end

        def fields
          @fields ||= []
        end

        def field_name_to_tag
          @field_name_to_tag ||= {}
        end

        def get_ext_field_by_name(name)
          tag = extension_field_name_to_tag[name.to_sym]
          extension_fields[tag] unless tag.nil?
        end

        def get_ext_field_by_tag(tag)
          extension_fields[tag]
        end

        def get_field_by_name(name)
          name = name.to_sym if name.respond_to?(:to_sym)
          tag = field_name_to_tag[name]
          fields[tag] unless tag.nil?
        end

        def get_field_by_tag(tag)
          fields[tag]
        rescue TypeError
          tag = tag.try(:to_s) || 'nil'
          raise FieldNotDefinedError.new("Tag '#{tag}' does not reference a message field for '#{self.name}'")
        end

        private

        # Define a field. Don't use this method directly.
        def define_field(rule, type, fname, tag, options)
          field_array = options[:extension] ? extension_fields : fields
          field_name_hash = options[:extension] ? extension_field_name_to_tag : field_name_to_tag

          previous_tag_field = get_field_by_tag(tag) || get_ext_field_by_tag(tag)
          if previous_tag_field
            raise TagCollisionError, %!Field number #{tag} has already been used in "#{name}" by field "#{fname}".!
          end

          previous_name_field = get_field_by_name(fname) || get_ext_field_by_name(fname)
          if previous_name_field
            raise DuplicateFieldNameError, %!Field name #{fname} has already been used in "#{name}".!
          end

          field_definition = ::Protobuf::Field.build(self, rule, type, fname, tag, options)
          field_name_hash[fname] = tag
          field_array[tag] = field_definition

          class_eval(<<-RAW_GETTER, __FILE__, __LINE__ + 1)
            define_method("#{fname}!") do
              @values[:#{fname}]
            end
          RAW_GETTER
        end

      end
    end
  end
end

