##
# This file is auto-generated. DO NOT EDIT!
#
require 'protobuf/message'

module Test
  ##
  # Enum Classes
  #
  class EnumTestType < ::Protobuf::Enum; end
  
  ##
  # Message Classes
  #
  class EnumTestMessage < ::Protobuf::Message; end
  
  ##
  # Enum Values
  #
  ::Test::EnumTestType.define :ONE, 1
  ::Test::EnumTestType.define :TWO, 2
  
  
  ##
  # Message Fields
  #
  ::Test::EnumTestMessage.optional(::Test::EnumTestType, :non_default_enum, 1)
  ::Test::EnumTestMessage.optional(::Test::EnumTestType, :default_enum, 2, :default => ::Test::EnumTestType::ONE)
  ::Test::EnumTestMessage.repeated(::Test::EnumTestType, :repeated_enums, 3)
  
  
end
