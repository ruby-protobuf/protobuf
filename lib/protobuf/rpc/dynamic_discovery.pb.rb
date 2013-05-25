##
# This file is auto-generated. DO NOT EDIT!
#
require 'protobuf/message'

module Protobuf

  module DynamicDiscovery
  
    ##
    # Enum Classes
    #
    class BeaconType < ::Protobuf::Enum
      define :HEARTBEAT, 0
      define :FLATLINE, 1
    end
    
    
    ##
    # Message Classes
    #
    class Beacon < ::Protobuf::Message; end
    
    ##
    # Message Fields
    #
    class Beacon
      optional ::Protobuf::DynamicDiscovery::BeaconType, :beacon_type, 1
      optional ::Protobuf::Field::StringField, :uuid, 2
      optional ::Protobuf::Field::StringField, :address, 3
      optional ::Protobuf::Field::StringField, :port, 4
      optional ::Protobuf::Field::Int32Field, :ttl, 5
      repeated ::Protobuf::Field::StringField, :service_classes, 6
    end
    
    
  end
  
end

