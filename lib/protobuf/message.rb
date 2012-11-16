require 'set'
require 'protobuf/field'
require 'protobuf/enum'
require 'protobuf/exceptions'
require 'protobuf/message/decoder'

module Protobuf
  class Message
    ##
    # Constants
    #
    STRING_ENCODING = "ASCII-8BIT".freeze

    ##
    # Class Methods
    #
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

    # Define a field. Don't use this method directly.
    def self.define_field(rule, type, fname, tag, options)
      field_array = options[:extension] ? extension_fields : fields
      field_name_hash = options[:extension] ? extension_field_name_to_tag : field_name_to_tag

      if field_array[tag]
        raise TagCollisionError, %!{Field number #{tag} has already been used in "#{self.name}" by field "#{fname}".!
      end

      field_definition = ::Protobuf::Field.build(self, rule, type, fname, tag, options)
      field_name_hash[fname] = tag
      field_array[tag] = field_definition
    end

    # Reserve field numbers for extensions. Don't use this method directly.
    def self.extensions(range)
      extension_fields.add_range(range)
    end
    
    def self.extension_field_name_to_tag
      @extension_fields_by_name ||= {}
    end

    # An extension field object.
    def self.extension_fields
      @extension_fields ||= ::Protobuf::Field::ExtensionFields.new
    end

    def self.extension_tag?(tag)
      extension_fields.include_tag?(tag)
    end

    # A collection of field object.
    def self.fields
      @fields ||= []
    end

    def self.field_name_to_tag
      @field_name_to_tag ||= {}
    end

    def self.get_ext_field_by_name(name)
      # Check if the name has been used before, if not then set it to the sym value
      extension_fields[extension_field_name_to_tag[name.to_sym]]
    rescue TypeError, NoMethodError => e
      name = 'nil' if name.nil?
      raise FieldNotDefinedError.new("Field '#{name}' is not defined on message '#{self.name}'")
    end

    def self.get_ext_field_by_tag(tag)
      extension_fields[tag]
    end

    # Find a field object by +name+.
    def self.get_field_by_name(name)
      # Check if the name has been used before, if not then set it to the sym value
      fields[field_name_to_tag[name.to_sym]]
    rescue TypeError, NoMethodError => e
      name = 'nil' if name.nil?
      raise FieldNotDefinedError.new("Field '#{name}' is not defined on message '#{self.name}'")
    end

    # Find a field object by +tag+ number.
    def self.get_field_by_tag(tag)
      fields[tag]
    rescue TypeError => e
      tag = tag.nil? ? 'nil' : tag.to_s
      raise FieldNotDefinedError.new("Tag '#{tag}' does not reference a message field for '#{self.name}'")
    end

    # Define a optional field. Don't use this method directly.
    def self.optional(type, name, tag, options = {})
      define_field(:optional, type, name, tag, options)
    end

    # Define a repeated field. Don't use this method directly.
    def self.repeated(type, name, tag, options = {})
      define_field(:repeated, type, name, tag, options)
    end

    # Define a required field. Don't use this method directly.
    def self.required(type, name, tag, options = {})
      define_field(:required, type, name, tag, options)
    end

    ##
    # Constructor
    #
    def initialize(values = {})
      @values = {}
      values = values.to_hash
      values.each { |name, val| self[name] = val unless val.nil? }
    end

    ##
    # Public Instance Methods
    #
    def all_fields
      self.class.all_fields
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

    def clone
      copy_to(super, :clone)
    end

    def dup
      copy_to(super, :dup)
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

    def each_field_for_serialization
      all_fields.each do |field|
        next unless _field_must_be_serialized?(field)

        value = @values[field.name]

        if value.present? || [true, false].include?(value)
          yield(field, value) 
        else
          # Only way you can get here is if you are required and not present
          raise ::Protobuf::SerializationError, "#{field.name} is required on #{field.message_class}"
        end
      end
    end

    # Returns extension fields. See Message#fields method.
    def extension_fields
      self.class.extension_fields
    end

    def fields
      self.class.fields
    end

    def get_ext_field_by_name(name) # :nodoc:
      self.class.get_ext_field_by_name(name)
    end

    def get_ext_field_by_tag(tag) # :nodoc:
      self.class.get_ext_field_by_tag(tag)
    end

    # Returns field object or +nil+.
    def get_field_by_name(name)
      self.class.get_field_by_name(name)
    end

    # Returns field object or +nil+.
    def get_field_by_tag(tag)
      self.class.get_field_by_tag(tag)
    end

    def has_field?(name)
      @values.has_key?(name)
    end

    def inspect
      to_hash.inspect
    end

    def parse_from(stream)
      Decoder.decode(stream, self)
    end

    def parse_from_string(string)
      parse_from(StringIO.new(string))
    end

    def respond_to_has?(key)
      self.respond_to?(key) && self.has_field?(key)
    end

    def respond_to_has_and_present?(key)
      self.respond_to_has?(key) && 
        (self.__send__(key).present? || [true, false].include?(self.__send__(key)))
    end

    def serialize_to(stream)
      each_field_for_serialization do |field, value|
        if field.repeated?
          if field.packed?
            key = (field.tag << 3) | ::Protobuf::WireType::LENGTH_DELIMITED
            packed_value = value.map { |val| field.encode(val) }.join
            stream.write(::Protobuf::Field::VarintField.encode(key))
            stream.write(::Protobuf::Field::VarintField.encode(packed_value.size))
            stream.write(packed_value)
          else
            value.each { |val| write_pair(stream, field, val) }
          end
        else
          write_pair(stream, field, value)
        end
      end
    end

    def serialize_to_string(string = '')
      io = StringIO.new(string)
      serialize_to(io)
      result = io.string
      result.force_encoding(::Protobuf::Message::STRING_ENCODING) if result.respond_to?(:force_encoding)
      result
    end

    def set_field(tag, bytes)
      field = (get_field_by_tag(tag) || get_ext_field_by_tag(tag))
      field.set(self, bytes) if field
    end

    # Return a hash-representation of the given fields for this message type.
    def to_hash
      result = Hash.new

      @values.keys.each do |field_name|
        value = __send__(field_name)
        hashed_value = value.respond_to?(:to_hash_value) ? value.to_hash_value : value
        result.merge!(field_name => hashed_value)
      end

      return result
    end

    def to_json
      to_hash.to_json
    end

    def ==(obj)
      return false unless obj.is_a?(self.class)
      each_field do |field, value|
        return false unless value == obj.__send__(field.name)
      end
      true
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

    ##
    # Instance Aliases
    #
    alias_method :to_hash_value, :to_hash
    alias_method :to_s, :serialize_to_string
    alias_method :bytes, :serialize_to_string
    alias_method :serialize, :serialize_to_string
    alias_method :responds_to_has?, :respond_to_has?
    alias_method :respond_to_and_has?, :respond_to_has?
    alias_method :responds_to_and_has?, :respond_to_has?
    alias_method :respond_to_has_present?, :respond_to_has_and_present?
    alias_method :respond_to_and_has_present?, :respond_to_has_and_present?
    alias_method :respond_to_and_has_and_present?, :respond_to_has_and_present?
    alias_method :responds_to_has_present?, :respond_to_has_and_present?
    alias_method :responds_to_and_has_present?, :respond_to_has_and_present?
    alias_method :responds_to_and_has_and_present?, :respond_to_has_and_present?

    ##
    # Private Instance Methods
    #
    private

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

    def _field_must_be_serialized?(field)
      return true if field.required?

      if field.repeated? && has_field?(field.name)
        @values[field.name].compact!
        @values.delete(field.name) if @values[field.name].empty?
      end

      return has_field?(field.name)
    end

    # Encode key and value, and write to +stream+.
    def write_pair(stream, field, value)
      key = (field.tag << 3) | field.wire_type
      key_bytes = ::Protobuf::Field::VarintField.encode(key)
      stream.write(key_bytes)
      bytes = field.encode(value)
      stream.write(bytes)
    end

  end
end
