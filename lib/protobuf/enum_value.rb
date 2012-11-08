require 'delegate'
require 'protobuf/enum'

module Protobuf
  class EnumValue < SimpleDelegator

    attr_reader :parent_class, :name, :value

    # Overriding the class so ActiveRecord/Arel visitor will visit the enum as a Fixnum
    def class
      Fixnum
    end

    def initialize(parent_class, name, value)
      @parent_class = parent_class
      @name = name
      @value = value
      super(@value)
    end

    def inspect
      "\#<Protobuf::EnumValue #{@parent_class}::#{@name}=#{@value}>"
    end

    def to_hash_value
      self.to_i
    end

    def to_s
      to_hash_value.to_s
    end
  end
end

