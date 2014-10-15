require 'protobuf/field'
require 'protobuf/enum'
require 'protobuf/exceptions'
require 'protobuf/message/fields'
require 'protobuf/message/serialization'

module Protobuf
  class Message

    ##
    # Includes & Extends
    #

    extend ::Protobuf::Message::Fields
    include ::Protobuf::Message::Serialization

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

      fields.to_hash.each_pair do |name, value|
        self[name] = value
      end
    end

    ##
    # Public Instance Methods
    #

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

    # Iterate over every field, invoking the given block
    #
    def each_field
      self.class.all_fields.each do |field|
        value = __send__(field.getter)
        yield(field, value)
      end
    end

    def each_field_for_serialization
      self.class.all_fields.each do |field|
        next unless field_must_be_serialized?(field)

        value = @values[field.getter]

        if value.nil?
          raise ::Protobuf::SerializationError, "Required field #{self.class.name}##{field.name} does not have a value."
        else
          yield(field, value)
        end
      end
    end

    def has_field?(name)
      @values.key?(name)
    end

    def inspect
      to_hash.inspect
    end

    def respond_to_has?(key)
      respond_to?(key) && has_field?(key)
    end

    def respond_to_has_and_present?(key)
      respond_to_has?(key) &&
        (__send__(key).present? || [true, false].include?(__send__(key)))
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
      if (field = self.class.get_field(name, true))
        __send__(field.getter)
      end
    end

    def []=(name, value)
      if (field = self.class.get_field(name, true))
        __send__(field.setter, value) unless value.nil?
      else
        unless ::Protobuf.ignore_unknown_fields?
          raise ::Protobuf::FieldNotDefinedError, name
        end
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
      duplicate = proc do |obj|
        case obj
        when Message, String then obj.__send__(method)
        else                      obj
        end
      end

      object.__send__(:initialize)
      @values.each do |name, value|
        if value.is_a?(::Protobuf::Field::FieldArray)
          object.__send__(name).replace(value.map { |v| duplicate.call(v) })
        else
          object.__send__("#{name}=", duplicate.call(value))
        end
      end
      object
    end

  end
end
