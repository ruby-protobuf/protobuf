require 'protobuf/message/fields'
require 'protobuf/message/serialization'

# Under MRI, this optimizes proto decoding by around 15% in tests.
# When unavailable, we fall to pure Ruby.
# rubocop:disable Lint/HandleExceptions
begin
  require 'varint/varint'
rescue LoadError
end
# rubocop:enable Lint/HandleExceptions

require 'protobuf/varint'

module Protobuf
  class Message

    ##
    # Includes & Extends
    #

    extend ::Protobuf::Message::Fields
    include ::Protobuf::Message::Serialization
    ::Protobuf::Optionable.inject(self) { ::Google::Protobuf::MessageOptions }

    def self.inherited(subclass)
      subclass.const_set("PROTOBUF_MESSAGE_GET_FIELD", subclass.field_store)
      subclass.class_eval <<~RUBY, __FILE__, __LINE__
        def _protobuf_message_field
          PROTOBUF_MESSAGE_GET_FIELD
        end
      RUBY
    end

    ##
    # Class Methods
    #

    def self.to_json
      name
    end

    ##
    # Constructor
    #

    def initialize(fields = {})
      @values = {}
      fields.to_hash.each do |name, value|
        set_field(name, value, true)
      end

      yield self if block_given?
    end

    ##
    # Public Instance Methods
    #

    def clear!
      @values.delete_if do |_, value|
        if value.is_a?(::Protobuf::Field::FieldArray) || value.is_a?(::Protobuf::Field::FieldHash)
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

    # Iterate over every field, invoking the given block
    #
    def each_field
      return to_enum(:each_field) unless block_given?

      self.class.all_fields.each do |field|
        value = self[field.name]
        yield(field, value)
      end
    end

    def each_field_for_serialization
      self.class.all_fields.each do |field|
        value = @values[field.fully_qualified_name]
        if value.nil?
          fail ::Protobuf::SerializationError, "Required field #{self.class.name}##{field.name} does not have a value." if field.required?
          next
        end
        if field.map?
          # on-the-wire, maps are represented like an array of entries where
          # each entry is a message of two fields, key and value.
          array = Array.new(value.size)
          i = 0
          value.each do |k, v|
            array[i] = field.type_class.new(:key => k, :value => v)
            i += 1
          end
          value = array
        end

        yield(field, value)
      end
    end

    def field?(name)
      field = _protobuf_message_field[name]
      field && field.field?(@values)
    end
    alias :respond_to_has? field?
    ::Protobuf.deprecator.define_deprecated_methods(self, :has_field? => :field?)

    def inspect
      attrs = self.class.fields.map do |field|
        [field.name, self[field.name].inspect].join('=')
      end.join(' ')

      "#<#{self.class} #{attrs}>"
    end

    def respond_to_has_and_present?(key)
      field = _protobuf_message_field[key]
      field && field.field_and_present?(@values)
    end

    # Return a hash-representation of the given fields for this message type.
    def to_hash
      result = {}

      @values.each_key do |field_name|
        field = _protobuf_message_field[field_name]
        value = field.value_from_values(@values)
        hashed_value = value.respond_to?(:to_hash_value) ? value.to_hash_value : value
        result[field.name] = hashed_value
      end

      result
    end

    def to_json(options = {})
      to_json_hash.to_json(options)
    end

    # Return a hash-representation of the given fields for this message type that
    # is safe to convert to JSON.
    def to_json_hash
      result = {}

      @values.each_key do |field_name|
        value = self[field_name]
        field = self.class.get_field(field_name, true)

        # NB: to_json_hash_value should come before json_encode so as to handle
        # repeated fields without extra logic.
        hashed_value = if value.respond_to?(:to_json_hash_value)
                         value.to_json_hash_value
                       elsif field.respond_to?(:json_encode)
                         field.json_encode(value)
                       else
                         value
                       end

        result[field.name] = hashed_value
      end

      result
    end

    def to_proto
      self
    end

    def ==(other)
      return false unless other.is_a?(self.class)
      each_field do |field, value|
        return false unless value == other[field.name]
      end
      true
    end

    def [](name)
      field = _protobuf_message_field[name]
      field.value_from_values(@values)
    rescue # not having a field should be the exceptional state
      raise if field
      fail ArgumentError, "invalid field name=#{name.inspect}"
    end

    def []=(name, value)
      set_field(name, value, true)
    end

    def set_field(name, value, ignore_nil_for_repeated, field = nil)
      if (field || field = _protobuf_message_field[name])
        field.set_field(@values, value, ignore_nil_for_repeated)
      else
        fail(::Protobuf::FieldNotDefinedError, name) unless ::Protobuf.ignore_unknown_fields?
      end
    end

    ##
    # Instance Aliases
    #
    alias :to_hash_value to_hash
    alias :to_json_hash_value to_json_hash
    alias :to_proto_hash to_hash
    alias :responds_to_has? respond_to_has?
    alias :respond_to_and_has? respond_to_has?
    alias :responds_to_and_has? respond_to_has?
    alias :respond_to_has_present? respond_to_has_and_present?
    alias :respond_to_and_has_present? respond_to_has_and_present?
    alias :respond_to_and_has_and_present? respond_to_has_and_present?
    alias :responds_to_has_present? respond_to_has_and_present?
    alias :responds_to_and_has_present? respond_to_has_and_present?
    alias :responds_to_and_has_and_present? respond_to_has_and_present?

    ##
    # Private Instance Methods
    #

    private

    def copy_to(object, method)
      duplicate = proc do |obj|
        case obj
        when Message, String then obj.__send__(method)
        else                      obj
        end
      end

      object.__send__(:initialize)
      @values.each do |name, value|
        if value.is_a?(::Protobuf::Field::FieldArray)
          object[name].replace(value.map { |v| duplicate.call(v) })
        else
          object[name] = duplicate.call(value)
        end
      end
      object
    end

  end
end
