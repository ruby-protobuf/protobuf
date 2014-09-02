##
# This file is auto-generated. DO NOT EDIT!
#
require 'protobuf/message'

module Test

  ##
  # Enum Classes
  #
  class DeprecatedEnum < ::Protobuf::Enum
    def self.deprecated?
      true
    end

    define :A_DEPRECATED_VALUE, 1, :deprecated => true
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

