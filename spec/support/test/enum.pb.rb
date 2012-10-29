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
  class EnumTestType
    define :ONE, 1
    define :TWO, 2
  end
  
  ##
  # Message Fields
  #
  class EnumTestMessage
    optional ::Test::EnumTestType, :non_default_enum, 1
    optional ::Test::EnumTestType, :default_enum, 2, :default => ::Test::EnumTestType::ONE
    repeated ::Test::EnumTestType, :repeated_enums, 3
  end
  
end
