require 'protobuf/enum_value'
require 'protobuf/optionable'
require 'protobuf/deprecator'

module Protobuf
  class Enum

    ##
    # Deprecations
    #

    extend ::Protobuf::Deprecator

    # Public: Allows setting Options on the Enum class.
    include ::Protobuf::Optionable

    def self.aliases_allowed?
      self.get_option(:allow_alias)
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
    #   StateMachine.all_tags #=> [ 1, 2 ]
    #
    # Returns an array of unique integers.
    #
    def self.all_tags
      @all_tags ||= self.enums.map(&:to_i).uniq
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
    #
    #   StateMachine::ON  #=> #<StateMachine::ON=1>
    #   StateMachine::OFF #=> #<StateMachine::OFF=2>
    #
    # Returns nothing.
    #
    def self.define(name, value)
      enum = ::Protobuf::EnumValue.new(self, name, value)
      @enums ||= []
      @enums << enum
      const_set(name, enum)
    end

    # Public: The internal values hash.
    #
    def self.enums
      @enums
    end

    # Public: Get an array of EnumValue objects with the given tag.
    #
    # tag - An object that responds to to_i.
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
    #   StateMachine.enums_for_tag(1) #=> [ #<StateMachine::ON=1>, #<StateMachine::STARTED=1> ]
    #   StateMachine.enums_for_tag(2) #=> [ #<StateMachine::OFF=2> ]
    #
    # Returns an array with zero or more EnumValue objects or nil.
    #
    def self.enums_for_tag(tag)
      self.enums.select { |enum|
        enum.to_i == tag.to_i
      }
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
    #   StateMachine.enum_for_name(:ON)  # => #<StateMachine::ON=1>
    #   StateMachine.enum_for_name("ON") # => #<StateMachine::ON=1>
    #   StateMachine.enum_for_name(:on)  # => nil
    #   StateMachine.enum_for_name(:FOO) # => nil
    #
    # Returns the EnumValue object with the given name. `nil` will be returned
    # if the given name does not have a correlating value.
    #
    def self.enum_for_name(name)
      self.const_get(name)
    rescue ::NameError
      nil
    end

    # Public: Get the EnumValue object corresponding to the given tag.
    #
    # tag - An object that responds to to_i.
    #
    # Returns an EnumValue object or nil. If the tag corresponds to multiple
    #   EnumValue objects an array of EnumValue objects will be returned.
    #
    def self.enum_for_tag(tag)
      self.enums_for_tag(tag).first
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
    def self.fetch(candidate)
      case candidate
      when ::Protobuf::EnumValue then
        candidate
      when Numeric then
        enum_for_tag(candidate.to_i)
      when String, Symbol then
        enum_for_name(candidate)
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
    #   StateMachine.name_for_tag(1) # => :ON
    #   StateMachine.name_for_tag(2) # => :OFF
    #   StateMachine.name_for_tag(3) # => nil
    #
    #   # With aliases
    #   class StateMachine < ::Protobuf::Enum
    #     set_option :allow_alias
    #     define :STARTED, 1
    #     define :ON, 1
    #     define :OFF, 2
    #   end
    #
    #   StateMachine.name_for_tag(1) # => :STARTED
    #   StateMachine.name_for_tag(2) # => :OFF
    #
    # Returns the symbol name of the enum constant given it's associated value.
    #   If the given value has multiple names associated (due to allow_alias)
    #   the first defined name will be returned. `nil` will be returned when
    #   the given value does not have a correlating name.
    #
    def self.name_for_tag(tag)
      self.enum_for_tag(tag).try(:name)
    end

    # Public: Check if the given tag value is defined by this Enum.
    #
    # number - An object that responds to to_i.
    #
    # Returns a boolean.
    #
    def self.valid_tag?(tag)
      tag.respond_to?(:to_i) && self.all_tags.include?(tag.to_i)
    end

    # Public: [DEPRECATED] Return a hash of EnumValue objects keyed
    # by their :name.
    #
    def self.values
      self.warn_deprecated(:values, :enums)

      @values ||= begin
                    self.enums.inject({}) do |hash, enum|
                      hash[enum.name] = enum
                      hash
                    end
                  end
    end

    ##
    # Deprecations
    #

    deprecate_class_method :enum_by_value,   :enum_for_tag
    deprecate_class_method :name_by_value,   :name_for_tag
    deprecate_class_method :get_name_by_tag, :name_for_tag
    deprecate_class_method :value_by_name,   :enum_for_name

  end
end

