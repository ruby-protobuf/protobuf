require 'protobuf/enum_value'

module Protobuf
  class Enum

    def self.define(name, value)
      enum_value = ::Protobuf::EnumValue.new(self, name, value)
      const_set(name, enum_value)
      @values ||= {}
      @names ||= []
      @values[name] = enum_value
      @names[value] = name
    end

    # Fetch the given enum by a variety of type-checking
    # mechanisms. This is useful for the enum field setters
    # as well as repeated enum field construction.
    def self.fetch(value)
      case value
      when ::Protobuf::EnumValue then
        value
      when Numeric then
        enum_by_value(value.to_i)
      when String, Symbol then
        value_by_name(value.to_sym)
      else
        nil
      end
    end

    def self.enum_by_value(value)
      value_by_name(name_by_value(value))
    end

    def self.name_by_value(value)
      value.nil? ? nil : @names[value]
    end

    def self.valid_tag?(tag)
      !! name_by_value(tag)
    end

    def self.value_by_name(name)
      @values[name]
    end

    def self.values
      @values
    end

    ##
    # Class Aliases
    #
    class << self
      alias_method :get_name_by_tag, :name_by_value
    end
  end
end
