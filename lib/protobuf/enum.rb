require 'protobuf/enum_value'
require 'protobuf/optionable'

module Protobuf
  class Enum
    # Public: Allows setting Options on the Enum class.
    include ::Protobuf::Optionable

    def self.aliases_allowed?
      self.get_option(:allow_alias)
    end

    # Public: Get an array of EnumValue objects with the given number.
    #
    # number - An object that responds to to_i.
    #
    # Returns an array with zero or more EnumValue objects or nil.
    #
    def self.all_enum_values_by_number(number)
      self.enum_values.values.select do |enum_value|
        enum_value.to_i == number.to_i
      end
    end

    # Public: Get all integer tag values defined by this enum.
    #
    # Examples
    #
    #   class StateMachine < ::Protobuf::Enum
    #     set_option :allow_alias
    #     define :ON, 1
    #     define :STARTED, 1
    #     define :OFF, 2
    #   end
    #
    #   StateMachine.all_numbers #=> [ 1, 2 ]
    #
    # Returns an array of unique integers.
    #
    def self.all_numbers
      @all_numbers ||= self.enum_values.values.map(&:to_i).uniq
    end

    # Internal: DSL method to define a protobuf EnumValue. The given name will
    # become a constant for this Enum which points to an EnumValue object.
    #
    # Examples
    #
    #   class StateMachine < ::Protobuf::Enum
    #     define :ON, 1
    #     define :OFF, 2
    #   end
    #   StateMachine::ON  #=> #<StateMachine::ON=1>
    #   StateMachine::OFF #=> #<StateMachine::OFF=2>
    #
    # Returns nothing.
    #
    def self.define(name, value)
      enum_value = ::Protobuf::EnumValue.new(self, name, value)
      @enum_values ||= {}
      @enum_values[name] = enum_value
      const_set(name, enum_value)
    end

    # Public: Get the EnumValue associated with the given name.
    #
    # name - A string-like object. Case-sensitive.
    #
    # Example
    #
    #   class StateMachine < ::Protobuf::Enum
    #     define :ON, 1
    #     define :OFF, 2
    #   end
    #
    #   StateMachine.enum_value_by_name(:ON)  # => #<StateMachine::ON=1>
    #   StateMachine.enum_value_by_name("ON") # => #<StateMachine::ON=1>
    #   StateMachine.enum_value_by_name(:on)  # => nil
    #   StateMachine.enum_value_by_name(:FOO) # => nil
    #
    # Returns the EnumValue object with the given name. `nil` will be returned
    # if the given name does not have a correlating value.
    #
    def self.enum_value_by_name(name)
      self.const_get(name)
    rescue NameError, NoMethodError
      nil
    end

    # Public: Get the EnumValue object corresponding to the given number.
    #
    # number - An object that responds to to_i.
    #
    # Returns an EnumValue object or nil. If the number corresponds to multiple
    #   EnumValue objects an array of EnumValue objects will be returned.
    #
    def self.enum_value_by_value(number)
      enum_value_by_name(name_by_value(number))
    end

    # Public: The internal values hash.
    #
    def self.enum_values
      @enum_values
    end

    # Public: Get an EnumValue by a variety of type-checking mechanisms.
    #
    # value - An EnumValue, Numeric, String, or Symbol object.
    #
    # Example
    #
    #   class StateMachine < ::Protobuf::Enum
    #     set_option :allow_alias
    #     define :ON, 1
    #     define :STARTED, 1
    #     define :OFF, 2
    #   end
    #
    #   StateMachine.fetch(StateMachine::ON)  # => #<StateMachine::ON=1>
    #   StateMachine.fetch(:ON)               # => #<StateMachine::ON=1>
    #   StateMachine.fetch("STARTED")         # => #<StateMachine::STARTED=1>
    #   StateMachine.fetch(1)                 # => [ #<StateMachine::ON=1>, #<StateMachine::STARTED=1> ]
    #
    # Returns an EnumValue object or nil.
    #
    def self.fetch(value)
      case value
      when ::Protobuf::EnumValue then
        value
      when Numeric then
        enum_value_by_value(value.to_i)
      when String, Symbol then
        enum_value_by_name(value)
      else
        nil
      end
    end

    # Public: Get the Symbol name associated with the given number.
    #
    # number - An object that responds to to_i.
    #
    # Examples
    #
    #   # Without aliases
    #   class StateMachine < ::Protobuf::Enum
    #     define :ON, 1
    #     define :OFF, 2
    #   end
    #
    #   StateMachine.name_by_value(1) # => :ON
    #   StateMachine.name_by_value(2) # => :OFF
    #   StateMachine.name_by_value(3) # => nil
    #
    #   # With aliases
    #   class StateMachine < ::Protobuf::Enum
    #     set_option :allow_alias
    #     define :STARTED, 1
    #     define :ON, 1
    #     define :OFF, 2
    #   end
    #
    #   StateMachine.name_by_value(1) # => :STARTED
    #   StateMachine.name_by_value(2) # => :OFF
    #
    # Returns the symbol name of the enum constant given it's associated value.
    #   If the given value has multiple names associated (due to allow_alias)
    #   the first defined name will be returned. `nil` will be returned when
    #   the given value does not have a correlating name.
    #
    def self.name_by_value(number)
      self.enum_values.values.detect { |enum_value|
        enum_value.to_i == number.to_i
      }.try(:name)
    end

    # Public: Check if the given tag value is defined by this Enum.
    # See name_by_value.
    #
    # number - An object that responds to to_i.
    #
    # Returns a boolean.
    #
    def self.valid_value?(number)
      !! name_by_value(number)
    end

    ##
    # Class Aliases
    #
    class << self
      # Deprecated:
      alias_method :valid_tag?, :valid_value?

      # Deprecated:
      alias_method :values, :enum_values

      # Deprecated: Alias of name_by_value.
      alias_method :get_name_by_tag, :name_by_value

      # Deprecated: Alias of enum_value_by_value.
      alias_method :value_by_name, :enum_value_by_value
    end

  end
end
