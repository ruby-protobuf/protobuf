require 'delegate'
require 'protobuf/optionable'
require 'protobuf/deprecator'

##
# Adding extension to Numeric until
# we can get people to stop calling #value
# on Enum instances.
#
class Numeric
  unless method_defined?(:value)
    def value
      $stderr.puts <<-DEPRECATION
[DEPRECATED] Enum#value is deprecated and will be removed in the next release.
              Use Enum#to_i instead.
DEPRECATION
      self
    end
  end
end

module Protobuf
  class Enum < SimpleDelegator

    ##
    # Deprecations
    #

    extend ::Protobuf::Deprecator

    # Public: Allows setting Options on the Enum class.
    include ::Protobuf::Optionable

    def self.aliases_allowed?
      get_option(:allow_alias)
    end

    # Public: Get all integer tags defined by this enum.
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
      @all_tags ||= enums.map(&:to_i).uniq
    end

    # Internal: DSL method to create a new Enum. The given name will
    # become a constant for this Enum pointing to the new instance.
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
    def self.define(name, tag)
      enum = new(self, name, tag)
      @enums ||= []
      @enums << enum
      const_set(name, enum)
    end

    # Public: All defined enums.
    #
    class << self
      attr_reader :enums
    end

    # Public: Get an array of Enum objects with the given tag.
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
    # Returns an array with zero or more Enum objects or nil.
    #
    def self.enums_for_tag(tag)
      enums.select do |enum|
        enum.to_i == tag.to_i
      end
    end

    # Public: Get the Enum associated with the given name.
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
    # Returns the Enum object with the given name or nil.
    #
    def self.enum_for_name(name)
      const_get(name)
    rescue ::NameError
      nil
    end

    # Public: Get the Enum object corresponding to the given tag.
    #
    # tag - An object that responds to to_i.
    #
    # Returns an Enum object or nil. If the tag corresponds to multiple
    #   Enums, the first enum defined will be returned.
    #
    def self.enum_for_tag(tag)
      enums_for_tag(tag).first
    end

    # Public: Get an Enum by a variety of type-checking mechanisms.
    #
    # candidate - An Enum, Numeric, String, or Symbol object.
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
    # Returns an Enum object or nil.
    #
    def self.fetch(candidate)
      case candidate
      when self then
        candidate
      when ::Numeric then
        enum_for_tag(candidate.to_i)
      when ::String, ::Symbol then
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
    # Returns the symbol name of the enum constant given it's associated tag or nil.
    #   If the given tag has multiple names associated (due to allow_alias)
    #   the first defined name will be returned.
    #
    def self.name_for_tag(tag)
      enum_for_tag(tag).try(:name)
    end

    # Public: Check if the given tag is defined by this Enum.
    #
    # number - An object that responds to to_i.
    #
    # Returns a boolean.
    #
    def self.valid_tag?(tag)
      tag.respond_to?(:to_i) && all_tags.include?(tag.to_i)
    end

    # Public: [DEPRECATED] Return a hash of Enum objects keyed
    # by their :name.
    #
    def self.values
      warn_deprecated(:values, :enums)

      @values ||= begin
                    enums.each_with_object({}) do |enum, hash|
                      hash[enum.name] = enum
                    end
                  end
    end

    ##
    # Class Deprecations
    #

    deprecate_class_method :enum_by_value,   :enum_for_tag
    deprecate_class_method :name_by_value,   :name_for_tag
    deprecate_class_method :get_name_by_tag, :name_for_tag
    deprecate_class_method :value_by_name,   :enum_for_name

    ##
    # Attributes
    #

    attr_reader :parent_class, :name, :tag

    ##
    # Instance Methods
    #

    def initialize(parent_class, name, tag)
      @parent_class = parent_class
      @name = name
      @tag = tag
      super(@tag)
    end

    # Overriding the class so ActiveRecord/Arel visitor will visit the enum as a Fixnum
    #
    def class
      Fixnum
    end

    def inspect
      "\#<Protobuf::Enum(#{parent_class})::#{name}=#{tag}>"
    end

    def to_i
      tag
    end

    def to_int
      tag.to_int
    end

    def to_s(format = :tag)
      case format
      when :tag then
        to_i.to_s
      when :name then
        name.to_s
      else
        to_i.to_s
      end
    end

    # Re-implement `try` in order to fix the problem where
    # the underlying fixnum doesn't respond to all methods (e.g. name or tag).
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
        @tag.try(*args, &block)
      end
    end

    def value
      parent_class.warn_deprecated(:value, :to_i)
      to_i
    end

    ##
    # Instance Aliases
    #
    alias_method :to_hash_value, :to_i
  end
end
