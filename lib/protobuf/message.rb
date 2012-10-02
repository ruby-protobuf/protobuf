require 'set'
require 'protobuf/field'
require 'protobuf/enum'
require 'protobuf/message/decoder'
require 'protobuf/message/encoder'

module Protobuf
  class Message
    STRING_ENCODING = "ASCII-8BIT".freeze

    def self.all_fields
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

    # Reserve field numbers for extensions. Don't use this method directly.
    def self.extensions(range)
      @extension_fields = ::Protobuf::Field::ExtensionFields.new(range)
    end

    # Define a required field. Don't use this method directly.
    def self.required(type, name, tag, options={})
      define_field(:required, type, name, tag, options)
    end

    # Define a optional field. Don't use this method directly.
    def self.optional(type, name, tag, options={})
      define_field(:optional, type, name, tag, options)
    end

    # Define a repeated field. Don't use this method directly.
    def self.repeated(type, name, tag, options={})
      define_field(:repeated, type, name, tag, options)
    end

    # Define a field. Don't use this method directly.
    def self.define_field(rule, type, fname, tag, options)
      field_array = options[:extension] ? extension_fields : fields
      field_name_hash = options[:extension] ? extension_field_name_to_tag : field_name_to_tag

      if field_array[tag]
        raise TagCollisionError, %!{Field number #{tag} has already been used in "#{self.name}" by field "#{fname}".!
      end

      field_definition = Field.build(self, rule, type, fname, tag, options)
      field_name_hash[fname] = tag
      field_array[tag] = field_definition
    end

    def self.extension_tag?(tag)
      extension_fields.include_tag?(tag)
    end

    # An extension field object.
    def self.extension_fields
      @extension_fields ||= ::Protobuf::Field::ExtensionFields.new
    end

    def self.extension_field_name_to_tag
      @extension_fields_by_name ||= {}
    end

    # A collection of field object.
    def self.fields
      @fields ||= []
    end

    def self.field_name_to_tag
      @field_name_to_tag ||= {}
    end

    # Find a field object by +name+.
    def self.get_field_by_name(name)
      # Check if the name has been used before, if not then set it to the sym value
      fields[field_name_to_tag[name]]
    end

    # Find a field object by +tag+ number.
    def self.get_field_by_tag(tag)
      fields[tag]
    end

    def self.get_ext_field_by_name(name)
      # Check if the name has been used before, if not then set it to the sym value
      extension_fields[extension_field_name_to_tag[name]]
    end

    def self.get_ext_field_by_tag(tag)
      extension_fields[tag]
    end

    ##
    # Constructor
    #
    def initialize(values={})
      @values = {}

      values.each { |name, val| self[name] = val}
    end

    def initialized?
      all_fields.all? { |field| field.initialized?(self) }
    end

    def has_field?(name)
      @values.has_key?(name)
    end

    def ==(obj)
      return false unless obj.is_a?(self.class)
      each_field do |field, value|
        return false unless value == obj.__send__(field.name)
      end
      true
    end

    def clear!
      @values.delete_if do |_, value|
        if value.is_a?(Field::FieldArray)
          value.clear
          false
        else
          true
        end
      end
      self
    end

    def dup
      copy_to(super, :dup)
    end

    def clone
      copy_to(super, :clone)
    end

    def copy_to(object, method)
      duplicate = proc { |obj|
        case obj
        when Message, String then obj.__send__(method)
        else                      obj
        end
      }

      object.__send__(:initialize)
      @values.each do |name, value|
        if value.is_a?(Field::FieldArray)
          object.__send__(name).replace(value.map {|v| duplicate.call(v)})
        else
          object.__send__("#{name}=", duplicate.call(value))
        end
      end
      object
    end
    private :copy_to

    def inspect(indent=0)
      result = []
      i = '  ' * indent
      field_value_to_string = lambda { |field, value|
        result << \
          if field.optional? && ! has_field?(field.name)
            ''
          else
            case field
            when Field::MessageField then
              if value.nil?
                "#{i}#{field.name} {}\n"
              else
                "#{i}#{field.name} {\n#{value.inspect(indent + 1)}#{i}}\n"
              end
            when Field::EnumField then
              if value.is_a?(EnumValue)
                "#{i}#{field.name}: #{value.name}\n"
              else
                "#{i}#{field.name}: #{field.type.name_by_value(value)}\n"
              end
            else
              "#{i}#{field.name}: #{value.inspect}\n"
            end
          end
      }
      each_field do |field, value|
        if field.repeated?
          value.each do |v|
            field_value_to_string.call(field, v)
          end
        else
          field_value_to_string.call(field, value)
        end
      end
      result.join
    end

    def parse_from_string(string)
      parse_from(StringIO.new(string))
    end

    def parse_from(stream)
      Decoder.decode(stream, self)
    end

    def serialize_to_string(string='')
      io = StringIO.new(string)
      serialize_to(io)
      result = io.string
      result.force_encoding(::Protobuf::Message::STRING_ENCODING) if result.respond_to?(:force_encoding)
      result
    end
    alias to_s serialize_to_string

    def serialize_to(stream)
      Encoder.encode(stream, self)
    end

    def set_field(tag, bytes)
      field = (get_field_by_tag(tag) || get_ext_field_by_tag(tag))
      field.set(self, bytes) if field
    end

    def [](name)
      if field = get_field_by_name(name) || get_ext_field_by_name(name)
        __send__(field.name)
      else
        raise NoMethodError, "No such field: #{name.inspect}"
      end
    end

    def []=(name, value)
      if field = get_field_by_name(name) || get_ext_field_by_name(name)
        __send__(field.setter_method_name, value)
      else
        raise NoMethodError, "No such field: #{name.inspect}"
      end
    end

    # Returns a hash; which key is a tag number, and value is a field object.
    def all_fields
      self.class.all_fields
    end

    def fields
      self.class.fields
    end

    # Returns field object or +nil+.
    def get_field_by_name(name)
      self.class.get_field_by_name(name)
    end

    # Returns field object or +nil+.
    def get_field_by_tag(tag)
      self.class.get_field_by_tag(tag)
    end

    # Returns extension fields. See Message#fields method.
    def extension_fields
      self.class.extension_fields
    end

    def get_ext_field_by_name(name) # :nodoc:
      self.class.get_ext_field_by_name(name)
    end

    def get_ext_field_by_tag(tag) # :nodoc:
      self.class.get_ext_field_by_tag(tag)
    end

    # Iterate over a field collection.
    #   message.each_field do |field_object, value|
    #     # do something
    #   end
    def each_field
      all_fields.each do |field|
        value = __send__(field.name)
        yield(field, value)
      end
    end

    def to_hash
      result = {}
      build_value = lambda { |field, value|
        if !field.optional? || (field.optional? && has_field?(field.name))
          case field
          when Field::MessageField then
            value.to_hash
          when Field::EnumField then
            if value.is_a?(EnumValue)
              value.to_i
            elsif value.is_a?(Symbol)
              field.type[value].to_i
            else
              value
            end
          else
            value
          end
        end
      }
      each_field do |field, value|
        if field.repeated?
          result[field.name] = value.map do |v|
            build_value.call(field, v)
          end
        else
          result[field.name] = build_value.call(field, value)
        end
      end
      result
    end

    def to_json
      to_hash.to_json
    end
  end
end
