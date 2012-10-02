require 'delegate'

module Protobuf
  class Enum

    def self.name_by_value(value)
      @names[value]
    end

    def self.valid_tag?(tag)
      !! name_by_value(tag)
    end

    def self.define(name, value)
      enum_value = EnumValue.new(self, name, value)
      const_set(name, enum_value)
      @values ||= {}
      @names ||= []
      @values[name] = enum_value
      @names[value] = name
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

  class EnumValue < SimpleDelegator

    attr_reader :parent_class, :name, :value

    def initialize(parent_class, name, value)
      @parent_class = parent_class
      @name = name
      @value = value
      super(@value)
    end

    def to_s
      @name.to_s
    end

    def inspect
      "\#<#{self.class} #{@parent_class}::#{@name}=#{@value}>"
    end
  end

end
