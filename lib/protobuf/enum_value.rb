require 'delegate'
require 'protobuf/enum'

##
# Adding extension to Numeric until
# we can get people to stop calling #value
# on EnumValue
class Numeric
  unless method_defined?(:value)
    def value
      self
    end
  end
end

module Protobuf
  class EnumValue < SimpleDelegator

    attr_reader :parent_class, :name

    ##
    # Constructor
    #
    def initialize(parent_class, name, value)
      @parent_class = parent_class
      @name = name
      @value = value
      super(@value)
    end

    # Overriding the class so ActiveRecord/Arel visitor will visit the enum as a Fixnum
    def class
      Fixnum
    end

    def inspect
      "\#<Protobuf::EnumValue #{@parent_class}::#{@name}=#{@value}>"
    end

    def to_i
      @value
    end

    def to_int
      @value.to_int
    end

    def to_s(format = :value_string)
      case format
      when :value_string then
        self.to_i.to_s
      when :name then
        name.to_s
      else
        self.to_i.to_s
      end
    end

    # Re-implement `try` in order to fix the problem where
    # the underlying fixnum doesn't respond to all methods (e.g. name or value).
    # If we respond to the first argument, `__send__` the args. Otherwise,
    # delegate the `try` call to the underlying vlaue fixnum.
    #
    def try(*args, &block)
      case
      when args.empty? && block_given?
        yield self
      when respond_to?(args.first)
        __send__(*args, &block)
      else
        @value.try(*args, &block)
      end
    end

    def value
      @value
    end

    ##
    # Instance Aliases
    #
    alias_method :to_hash_value, :to_i
  end
end

