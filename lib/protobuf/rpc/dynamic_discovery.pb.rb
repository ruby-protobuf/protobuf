##
# This file is auto-generated. DO NOT EDIT!
#
require 'protobuf/message'

module Protobuf

  module Rpc
  
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
      class Server < ::Protobuf::Message; end
      class Beacon < ::Protobuf::Message; end
      
      ##
      # Message Fields
      #
      class Server
        optional ::Protobuf::Field::StringField, :uuid, 1
        optional ::Protobuf::Field::StringField, :address, 2
        optional ::Protobuf::Field::StringField, :port, 3
        optional ::Protobuf::Field::Int32Field, :ttl, 4
        repeated ::Protobuf::Field::StringField, :services, 5
      end
      
      class Beacon
        optional ::Protobuf::Rpc::DynamicDiscovery::BeaconType, :beacon_type, 1
        optional ::Protobuf::Rpc::DynamicDiscovery::Server, :server, 2
      end
      
      
    end
    
  end
  
end

