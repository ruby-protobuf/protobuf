require 'pp'
require 'stringio'

require 'active_support/core_ext/object/blank'
require 'active_support/core_ext/object/try'
require 'active_support/inflector'
require 'active_support/json'
require 'active_support/notifications'

require 'protobuf/deprecation'

module Protobuf
  def self.deprecator
    @deprecator ||= Deprecation.new('4.0', to_s).tap do |deprecation|
      deprecation.silenced = ENV.key?('PB_IGNORE_DEPRECATIONS')
      deprecation.behavior = :stderr
    end
  end

  def self.field_deprecator
    @field_deprecator ||= FieldDeprecation.new.tap do |deprecation|
      deprecation.silenced = ENV.key?('PB_IGNORE_DEPRECATIONS')
      deprecation.behavior = :stderr
    end
  end

  # Print Deprecation Warnings
  #
  # Default: true
  #
  # Simple boolean to define whether we want field deprecation warnings to
  # be printed to stderr or not. You can turn this option off by setting
  # ENV['PB_IGNORE_DEPRECATIONS'] to a non-empty value.
  #
  def self.print_deprecation_warnings?
    !field_deprecator.silenced
  end

  def self.print_deprecation_warnings=(value)
    field_deprecator.silenced = !value
  end

  # Permit unknown field on Message initialization
  #
  # Default: true
  #
  # Simple boolean to define whether we want to permit unknown fields
  # on Message intialization; otherwise a ::Protobuf::FieldNotDefinedError is thrown.
  def self.ignore_unknown_fields?
    !defined?(@ignore_unknown_fields) || @ignore_unknown_fields
  end

  def self.ignore_unknown_fields=(value)
    @ignore_unknown_fields = !!value
  end
end
