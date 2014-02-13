require 'protobuf/field'
require 'protobuf/enum'
require 'protobuf/exceptions'
require 'protobuf/message/dsl/fields'
require 'protobuf/message/encoding'

module Protobuf
  class Message

    ##
    # Includes & Extends
    #

    extend ::Protobuf::Message::DSL::Fields
    include ::Protobuf::Message::Encoding

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
        if value.is_a?(::Protobuf::Field::FieldArray)
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
        next unless field_must_be_serialized?(field)

        value = @values[field.name]

        if value.nil?
          raise ::Protobuf::SerializationError, "Required field #{self.name}##{field.name} does not have a value."
        else
          yield(field, value)
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

    def get_ext_field_by_name(name)
      self.class.get_ext_field_by_name(name)
    end

    def get_ext_field_by_tag(tag)
      self.class.get_ext_field_by_tag(tag)
    end

    def get_field_by_name(name)
      self.class.get_field_by_name(name)
    end

    def get_field_by_tag(tag)
      self.class.get_field_by_tag(tag)
    end

    def has_field?(name)
      @values.has_key?(name)
    end

    def inspect
      to_hash.inspect
    end

    def respond_to_has?(key)
      self.respond_to?(key) && self.has_field?(key)
    end

    def respond_to_has_and_present?(key)
      self.respond_to_has?(key) &&
        (self.__send__(key).present? || [true, false].include?(self.__send__(key)))
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

    def to_json(options = {})
      to_hash.to_json(options)
    end

    def to_proto
      self
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
      end
    end

    def []=(name, value)
      if field = get_field_by_name(name) || get_ext_field_by_name(name)
        __send__(field.setter_method_name, value)
      end
    end

    ##
    # Instance Aliases
    #
    alias_method :to_hash_value, :to_hash
    alias_method :to_proto_hash, :to_hash
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
        if value.is_a?(::Protobuf::Field::FieldArray)
          object.__send__(name).replace(value.map {|v| duplicate.call(v)})
        else
          object.__send__("#{name}=", duplicate.call(value))
        end
      end
      object
    end

  end
end
