# encoding: utf-8
# frozen_string_literal: true

##
# This file is auto-generated. DO NOT EDIT!
#
require 'base64'
require 'set'
require 'protobuf'

module Protobuf
  module Rpc
    module DynamicDiscovery
      FULLY_QUALIFIED_NAME = 'protobuf.rpc.dynamicDiscovery' unless defined?(self::FULLY_QUALIFIED_NAME)

      @descriptors = [] unless instance_variable_defined?(:@descriptors)
      @descriptors << lambda do
        bytes = File.read(__FILE__, mode: 'rb').split(/^__END__$/, 2).last
        ::Google::Protobuf::FileDescriptorProto.decode(Base64.decode64(bytes))
      end

      @descriptor_dependencies = Set.new unless instance_variable_defined?(:@descriptor_dependencies)
      @descriptor_dependencies |= []

      unless respond_to?(:descriptor_set)
        def self.descriptor_set
          ::Google::Protobuf::FileDescriptorSet.new(:file => @descriptors.map(&:call))
        end
      end

      unless respond_to?(:descriptor_dependencies)
        def self.descriptor_dependencies
          @descriptor_dependencies
        end
      end
      ::Protobuf::Optionable.inject(self) { ::Google::Protobuf::FileOptions }

      ##
      # Enum Classes
      #
      class BeaconType < ::Protobuf::Enum
        FULLY_QUALIFIED_NAME = FULLY_QUALIFIED_NAME + '.BeaconType'

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
        FULLY_QUALIFIED_NAME = FULLY_QUALIFIED_NAME + '.Server'
        optional :string, :uuid, 1
        optional :string, :address, 2
        optional :string, :port, 3
        optional :int32, :ttl, 4
        repeated :string, :services, 5
      end

      class Beacon
        FULLY_QUALIFIED_NAME = FULLY_QUALIFIED_NAME + '.Beacon'
        optional ::Protobuf::Rpc::DynamicDiscovery::BeaconType, :beacon_type, 1
        optional ::Protobuf::Rpc::DynamicDiscovery::Server, :server, 2
      end

    end

  end

end


# Raw descriptor bytes below
__END__
ChdkeW5hbWljX2Rpc2NvdmVyeS5wcm90bxIdcHJvdG9idWYucnBjLmR5bmFt
aWNEaXNjb3ZlcnkieAoGU2VydmVyEhIKBHV1aWQYASABKAlSBHV1aWQSGAoH
YWRkcmVzcxgCIAEoCVIHYWRkcmVzcxISCgRwb3J0GAMgASgJUgRwb3J0EhAK
A3R0bBgEIAEoBVIDdHRsEhoKCHNlcnZpY2VzGAUgAygJUghzZXJ2aWNlcyKT
AQoGQmVhY29uEkoKC2JlYWNvbl90eXBlGAEgASgOMikucHJvdG9idWYucnBj
LmR5bmFtaWNEaXNjb3ZlcnkuQmVhY29uVHlwZVIKYmVhY29uVHlwZRI9CgZz
ZXJ2ZXIYAiABKAsyJS5wcm90b2J1Zi5ycGMuZHluYW1pY0Rpc2NvdmVyeS5T
ZXJ2ZXJSBnNlcnZlciopCgpCZWFjb25UeXBlEg0KCUhFQVJUQkVBVBAAEgwK
CEZMQVRMSU5FEAFKpw4KBhIEGAAqAQqfCQoBAhIDGAAmMrYIIENvcHlyaWdo
dCAoYykgMjAxMyBNb25leURlc2t0b3AsIEluYy4KCiBQZXJtaXNzaW9uIGlz
IGhlcmVieSBncmFudGVkLCBmcmVlIG9mIGNoYXJnZSwgdG8gYW55IHBlcnNv
biBvYnRhaW5pbmcgYSBjb3B5CiBvZiB0aGlzIHNvZnR3YXJlIGFuZCBhc3Nv
Y2lhdGVkIGRvY3VtZW50YXRpb24gZmlsZXMgKHRoZSAiU29mdHdhcmUiKSwg
dG8gZGVhbAogaW4gdGhlIFNvZnR3YXJlIHdpdGhvdXQgcmVzdHJpY3Rpb24s
IGluY2x1ZGluZyB3aXRob3V0IGxpbWl0YXRpb24gdGhlIHJpZ2h0cwogdG8g
dXNlLCBjb3B5LCBtb2RpZnksIG1lcmdlLCBwdWJsaXNoLCBkaXN0cmlidXRl
LCBzdWJsaWNlbnNlLCBhbmQvb3Igc2VsbAogY29waWVzIG9mIHRoZSBTb2Z0
d2FyZSwgYW5kIHRvIHBlcm1pdCBwZXJzb25zIHRvIHdob20gdGhlIFNvZnR3
YXJlIGlzCiBmdXJuaXNoZWQgdG8gZG8gc28sIHN1YmplY3QgdG8gdGhlIGZv
bGxvd2luZyBjb25kaXRpb25zOgoKIFRoZSBhYm92ZSBjb3B5cmlnaHQgbm90
aWNlIGFuZCB0aGlzIHBlcm1pc3Npb24gbm90aWNlIHNoYWxsIGJlIGluY2x1
ZGVkIGluCiBhbGwgY29waWVzIG9yIHN1YnN0YW50aWFsIHBvcnRpb25zIG9m
IHRoZSBTb2Z0d2FyZS4KCiBUSEUgU09GVFdBUkUgSVMgUFJPVklERUQgIkFT
IElTIiwgV0lUSE9VVCBXQVJSQU5UWSBPRiBBTlkgS0lORCwgRVhQUkVTUyBP
UgogSU1QTElFRCwgSU5DTFVESU5HIEJVVCBOT1QgTElNSVRFRCBUTyBUSEUg
V0FSUkFOVElFUyBPRiBNRVJDSEFOVEFCSUxJVFksCiBGSVRORVNTIEZPUiBB
IFBBUlRJQ1VMQVIgUFVSUE9TRSBBTkQgTk9OSU5GUklOR0VNRU5ULiBJTiBO
TyBFVkVOVCBTSEFMTCBUSEUKIEFVVEhPUlMgT1IgQ09QWVJJR0hUIEhPTERF
UlMgQkUgTElBQkxFIEZPUiBBTlkgQ0xBSU0sIERBTUFHRVMgT1IgT1RIRVIK
IExJQUJJTElUWSwgV0hFVEhFUiBJTiBBTiBBQ1RJT04gT0YgQ09OVFJBQ1Qs
IFRPUlQgT1IgT1RIRVJXSVNFLCBBUklTSU5HIEZST00sCiBPVVQgT0YgT1Ig
SU4gQ09OTkVDVElPTiBXSVRIIFRIRSBTT0ZUV0FSRSBPUiBUSEUgVVNFIE9S
IE9USEVSIERFQUxJTkdTIElOCiBUSEUgU09GVFdBUkUuCjJcIEF1dGhvcnM6
IERldmluIENocmlzdGVuc2VuCgogUHJvdG9idWZzIG5lZWRlZCBmb3IgZHlu
YW1pYyBkaXNjb3Zlcnkgem1xIHNlcnZlciBhbmQgY2xpZW50LgoKCgoCBQAS
BBoAHQEKCgoDBQABEgMaBQ8KCwoEBQACABIDGwIQCgwKBQUAAgABEgMbAgsK
DAoFBQACAAISAxsODwoLCgQFAAIBEgMcAg8KDAoFBQACAQESAxwCCgoMCgUF
AAIBAhIDHA0OCgoKAgQAEgQfACUBCgoKAwQAARIDHwgOCgsKBAQAAgASAyAC
GwoMCgUEAAIABBIDIAIKCgwKBQQAAgAFEgMgCxEKDAoFBAACAAESAyASFgoM
CgUEAAIAAxIDIBkaCgsKBAQAAgESAyECHgoMCgUEAAIBBBIDIQIKCgwKBQQA
AgEFEgMhCxEKDAoFBAACAQESAyESGQoMCgUEAAIBAxIDIRwdCgsKBAQAAgIS
AyICGwoMCgUEAAICBBIDIgIKCgwKBQQAAgIFEgMiCxEKDAoFBAACAgESAyIS
FgoMCgUEAAICAxIDIhkaCgsKBAQAAgMSAyMCGQoMCgUEAAIDBBIDIwIKCgwK
BQQAAgMFEgMjCxAKDAoFBAACAwESAyMRFAoMCgUEAAIDAxIDIxcYCgsKBAQA
AgQSAyQCHwoMCgUEAAIEBBIDJAIKCgwKBQQAAgQFEgMkCxEKDAoFBAACBAES
AyQSGgoMCgUEAAIEAxIDJB0eCgoKAgQBEgQnACoBCgoKAwQBARIDJwgOCgsK
BAQBAgASAygCJgoMCgUEAQIABBIDKAIKCgwKBQQBAgAGEgMoCxUKDAoFBAEC
AAESAygWIQoMCgUEAQIAAxIDKCQlCgsKBAQBAgESAykCHQoMCgUEAQIBBBID
KQIKCgwKBQQBAgEGEgMpCxEKDAoFBAECAQESAykSGAoMCgUEAQIBAxIDKRsc
