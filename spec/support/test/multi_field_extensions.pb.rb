##
# This file is auto-generated. DO NOT EDIT!
#
require 'protobuf/message'

module Test

  ##
  # Message Classes
  #
  class Header < ::Protobuf::Message
    class Type < ::Protobuf::Enum
      define :PayloadTypeA, 1
      define :PayloadTypeB, 2
    end
    
  end
  class PayloadA < ::Protobuf::Message; end
  class PayloadB < ::Protobuf::Message; end
  
  ##
  # Message Fields
  #
  class Header
    required ::Test::Header::Type, :type, 1
    
    # Extension Fields
    extensions 100...536870912
    optional ::Test::PayloadA, :payload, 100, :extension => true
  end
  
  
end

