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

        yield(field, value)
      end
    end

    def field?(name)
      field = self.class.get_field(name, true)
      return false if field.nil?
      if field.repeated?
        @values.key?(field.fully_qualified_name) && @values[field.fully_qualified_name].present?
      else
        @values.key?(field.fully_qualified_name)
      end
    end
    ::Protobuf.deprecator.define_deprecated_methods(self, :has_field? => :field?)

    def inspect
      attrs = self.class.fields.map do |field|
        [field.name, self[field.name].inspect].join('=')
      end.join(' ')

      "#<#{self.class} #{attrs}>"
    end

    def respond_to_has?(key)
      respond_to?(key) && field?(key)
    end

    def respond_to_has_and_present?(key)
      respond_to_has?(key) &&
        (self[key].present? || [true, false].include?(self[key]))
    end

    # Return a hash-representation of the given fields for this message type.
    def to_hash
      result = {}

      @values.each_key do |field_name|
        value = self[field_name]
        field = self.class.get_field(field_name, true)
        hashed_value = value.respond_to?(:to_hash_value) ? value.to_hash_value : value
        result[field.name] = hashed_value
      end

      result
    end

    def to_json(options = {})
      to_hash.to_json(options)
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
      if (field = self.class.get_field(name, true))
        if field.repeated?
          @values[field.fully_qualified_name] ||= ::Protobuf::Field::FieldArray.new(field)
        elsif @values.key?(field.fully_qualified_name)
          @values[field.fully_qualified_name]
        else
          field.default_value
        end
      else
        fail ArgumentError, "invalid field name=#{name.inspect}"
      end
    end

    def []=(name, value)
      set_field(name, value, true)
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

    def set_field(name, value, ignore_nil_for_repeated)
      if (field = self.class.get_field(name, true))
        if field.repeated?
          if value.nil? && ignore_nil_for_repeated
            ::Protobuf.deprecator.deprecation_warning("#{self.class}#[#{name}]=nil", "use an empty array instead of nil")
            return
          end
          if value.is_a?(Array)
            value = value.compact
          else
            fail TypeError, <<-TYPE_ERROR
                Expected repeated value of type '#{field.type_class}'
                Got '#{value.class}' for repeated protobuf field #{field.name}
            TYPE_ERROR
          end

          if value.empty?
            @values.delete(field.fully_qualified_name)
          else
            @values[field.fully_qualified_name] ||= ::Protobuf::Field::FieldArray.new(field)
            @values[field.fully_qualified_name].replace(value)
          end
        else
          if value.nil?
            @values.delete(field.fully_qualified_name)
          elsif field.acceptable?(value)
            @values[field.fully_qualified_name] = field.coerce!(value)
          else
            fail TypeError, "Unacceptable value #{value} for field #{field.name} of type #{field.type_class}"
          end
        end
      else
        unless ::Protobuf.ignore_unknown_fields?
          fail ::Protobuf::FieldNotDefinedError, name
        end
      end
    end

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
