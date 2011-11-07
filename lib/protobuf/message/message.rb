require 'pp'
require 'stringio'
require 'protobuf/descriptor/descriptor'
require 'protobuf/message/decoder'
require 'protobuf/message/encoder'
require 'protobuf/message/field'
require 'protobuf/message/protoable'
require 'json'

module Protobuf
  OPTIONS = {}

  class Message

    class ExtensionFields < Hash
      def initialize(key_range=0..-1)
        @key_range = key_range
      end

      def []=(key, value)
        raise RangeError, "#{key} is not in #{@key_range}" unless @key_range.include?(key)
        super
      end

      def include_tag?(tag)
        @key_range.include?(tag)
      end
    end

    class <<self
      include Protoable

      # Reserve field numbers for extensions. Don't use this method directly.
      def extensions(range)
        @extension_fields = ExtensionFields.new(range)
      end

      # Define a required field. Don't use this method directly.
      def required(type, name, tag, options={})
        define_field(:required, type, name, tag, options)
      end

      # Define a optional field. Don't use this method directly.
      def optional(type, name, tag, options={})
        define_field(:optional, type, name, tag, options)
      end

      # Define a repeated field. Don't use this method directly.
      def repeated(type, name, tag, options={})
        define_field(:repeated, type, name, tag, options)
      end

      # Define a field. Don't use this method directly.
      def define_field(rule, type, fname, tag, options)
        field_hash = options[:extension] ? extension_fields : fields
        if field_hash.keys.include?(tag)
          raise TagCollisionError, %!{Field number #{tag} has already been used in "#{self.name}" by field "#{fname}".!
        end
        field_hash[tag] = Field.build(self, rule, type, fname, tag, options)
      end

      def extension_tag?(tag)
        extension_fields.include_tag?(tag)
      end

      # A collection of field object.
      def fields
        @fields ||= {}
      end

      # An extension field object.
      def extension_fields
        @extension_fields ||= ExtensionFields.new
      end

      # Find a field object by +name+.
      def get_field_by_name(name)
        name = name.to_sym
        fields.values.find {|field| field.name == name}
      end

      # Find a field object by +tag+ number.
      def get_field_by_tag(tag)
        fields[tag]
      end

      # Find a field object by +tag_or_name+.
      def get_field(tag_or_name)
        case tag_or_name
        when Integer        then get_field_by_tag(tag_or_name)
        when String, Symbol then get_field_by_name(tag_or_name)
        else                     raise TypeError, tag_or_name.class
        end
      end

      #TODO merge to get_field_by_name
      def get_ext_field_by_name(name)
        name = name.to_sym
        extension_fields.values.find {|field| field.name == name}
      end

      #TODO merge to get_field_by_tag
      def get_ext_field_by_tag(tag)
        extension_fields[tag]
      end

      #TODO merge to get_field
      def get_ext_field(tag_or_name)
        case tag_or_name
        when Integer        then get_ext_field_by_tag(tag_or_name)
        when String, Symbol then get_ext_field_by_name(tag_or_name)
        else                     raise TypeError, tag_or_name.class
        end
      end

      def descriptor
        @descriptor ||= Descriptor::Descriptor.new(self)
      end
    end

    def initialize(values={})
      @values = {}

      self.class.fields.each do |tag, field|
        unless field.ready?
          field = field.setup
          self.class.class_eval {@fields[tag] = field}
        end
        if field.repeated?
          @values[field.name] = Field::FieldArray.new(field)
        end
      end

      # TODO
      self.class.extension_fields.each do |tag, field|
        unless field.ready?
          field = field.setup
          self.class.class_eval {@extension_fields[tag] = field}
        end
        if field.repeated?
          @values[field.name] = Field::FieldArray.new(field)
        end
      end

      values.each {|tag, val| self[tag] = val}
    end

    def initialized?
      fields.all? {|tag, field| field.initialized?(self) } && \
        extension_fields.all? {|tag, field| field.initialized?(self) }
    end

    def has_field?(tag_or_name)
      field = get_field(tag_or_name) || get_ext_field(tag_or_name)
      raise ArgumentError, "unknown field: #{tag_or_name.inspect}" unless field
      @values.has_key?(field.name)
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
      duplicate = proc {|obj|
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
      field_value_to_string = lambda {|field, value|
        result << \
          if field.optional? && ! has_field?(field.name)
            ''
          else
            case field
            when Field::MessageField
              if value.nil?
                "#{i}#{field.name} {}\n"
              else
                "#{i}#{field.name} {\n#{value.inspect(indent + 1)}#{i}}\n"
              end
            when Field::EnumField
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

    def parse_from_file(filename)
      if filename.is_a?(File)
        parse_from(filename)
      else
        File.open(filename, 'rb') do |f|
          parse_from(f)
        end
      end
    end

    def parse_from(stream)
      Decoder.decode(stream, self)
    end

    def serialize_to_string(string='')
      io = StringIO.new(string)
      serialize_to(io)
      result = io.string
      result.force_encoding('ASCII-8BIT') if result.respond_to?(:force_encoding)
      result
    end
    alias to_s serialize_to_string

    def serialize_to_file(filename)
      if filename.is_a?(File)
        serialize_to(filename)
      else
        File.open(filename, 'wb') do |f|
          serialize_to(f)
        end
      end
    end

    def serialize_to(stream)
      Encoder.encode(stream, self)
    end

    def merge_from(message)
      # TODO
      fields.each {|tag, field| merge_field(tag, message.__send__(field.name))}
      extension_fields.each {|tag, field| merge_field(tag, message.__send__(field.name))}
    end

    def set_field(tag, bytes)
      field = (get_field_by_tag(tag) || get_ext_field_by_tag(tag))
      field.set(self, bytes) if field
    end

    def merge_field(tag, value)
      #get_field_by_tag(tag).merge self, bytes #TODO
      (get_field_by_tag(tag) || get_ext_field_by_tag(tag)).merge(self, value)
    end

    def [](tag_or_name)
      if field = get_field(tag_or_name) || get_ext_field(tag_or_name)
        __send__(field.name)
      else
        raise NoMethodError, "No such field: #{tag_or_name.inspect}"
      end
    end

    def []=(tag_or_name, value)
      if field = get_field(tag_or_name) || get_ext_field(tag_or_name)
        __send__("#{field.name}=", value)
      else
        raise NoMethodError, "No such field: #{tag_or_name.inspect}"
      end
    end

    # Returns a hash; which key is a tag number, and value is a field object.
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

    # Returns field object or +nil+.
    def get_field(tag_or_name)
      self.class.get_field(tag_or_name)
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

    def get_ext_field(tag_or_name) # :nodoc:
      self.class.get_ext_field(tag_or_name)
    end

    # Iterate over a field collection.
    #   message.each_field do |field_object, value|
    #     # do something
    #   end
    def each_field
      fields.merge(extension_fields).sort_by {|tag, _| tag}.each do |_, field|
        value = __send__(field.name)
        yield(field, value)
      end
    end
    
    def to_hash
      result = {}
      build_value = lambda {|field, value|
        if !field.optional? || (field.optional? && has_field?(field.name))
          case field
          when Field::MessageField
            value.to_hash
          when Field::EnumField
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
