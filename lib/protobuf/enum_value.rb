require 'delegate'
require 'protobuf/enum'

module Protobuf
  class EnumValue < SimpleDelegator

    attr_reader :parent_class, :name, :value

    def initialize(parent_class, name, value)
      @parent_class = parent_class
      @name = name
      @value = value
      super(@value)
    end

    def inspect
      "\#<#{self.class} #{@parent_class}::#{@name}=#{@value}>"
    end

    def to_hash_value
      self.to_i
    end

    def to_s
      @name.to_s
    end
  end
end

