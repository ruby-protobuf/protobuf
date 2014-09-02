##
# This file is auto-generated. DO NOT EDIT!
#
require 'protobuf/message'

module Test

  ##
  # Enum Classes
  #
  class NonDeprecatedEnum < ::Protobuf::Enum
    define :A_DEPRECATED_VALUE, 1, :deprecated => true
    define :NOT_DEPRECATED_VALUE, 2
  end

  class DeprecatedEnum < ::Protobuf::Enum
    def self.deprecated?
      true
    end

    define :EXPLICIT, 1, :deprecated => true
    define :IMPLICIT, 2, :deprecated => true
  end


  ##
  # Message Classes
  #
  class DeprecatedMessage < ::Protobuf::Message; end


  ##
  # Message Fields
  #
  class DeprecatedMessage
    def self.deprecated?
      true
    end

  end

end

