##
# This file is auto-generated. DO NOT EDIT!
#
require 'protobuf/message'

##
# Imports
#
require 'test/resource.pb'

module Test
  ##
  # Enum Classes
  #
  class EnumTestType < ::Protobuf::Enum
    define :ONE, 1
    define :TWO, 2
  end
  
  
  ##
  # Message Classes
  #
  class EnumTestMessage < ::Protobuf::Message; end
  
  ##
  # Message Fields
  #
  class EnumTestMessage
    optional ::Test::EnumTestType, :non_default_enum, 1
    optional ::Test::EnumTestType, :default_enum, 2, :default => ::Test::EnumTestType::ONE
    repeated ::Test::EnumTestType, :repeated_enums, 3
  end
  
  ##
  # Extended Messages
  #
  class ::Test::Resource
    optional ::Protobuf::Field::Int32Field, :ext_other_file_defined_field, 200, :extension => true
  end
  
end
