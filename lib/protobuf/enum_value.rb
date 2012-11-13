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
  class EnumValue
    include Comparable

    attr_reader :parent_class, :name

    ##
    # Constructor
    #
    def initialize(parent_class, name, value)
      @parent_class = parent_class
      @name = name
      @value = value
    end

    ## 
    # Public Instance Methods
    #
    def <=>(compared_value)
      case compared_value
      when ::Protobuf::EnumValue then
        value <=> compared_value.to_i
      when Numeric then
        value <=> compared_value.to_i
      end
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

    def value
      if ::Protobuf.print_deprecation_warnings?
        $stderr.puts("[WARNING] Calling #value on an EnumValue is deprecated and no longer needed.")
      end

      @value
    end

    ##
    # Instance Aliases
    #
    alias_method :to_hash_value, :to_i
  end
end

