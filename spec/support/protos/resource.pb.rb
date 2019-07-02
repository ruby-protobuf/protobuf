# encoding: utf-8
# frozen_string_literal: true

##
# This file is auto-generated. DO NOT EDIT!
#
require 'base64'
require 'set'
require 'protobuf'
require 'protobuf/rpc/service'


##
# Imports
#
require 'google/protobuf/descriptor.pb'

module Test
  FULLY_QUALIFIED_NAME = 'test' unless defined?(self::FULLY_QUALIFIED_NAME)

  @descriptors = [] unless instance_variable_defined?(:@descriptors)
  @descriptors << lambda do
    bytes = File.read(__FILE__, mode: 'rb').split(/^__END__$/, 2).last
    ::Google::Protobuf::FileDescriptorProto.decode(Base64.decode64(bytes))
  end

  @descriptor_dependencies = Set.new unless instance_variable_defined?(:@descriptor_dependencies)
  @descriptor_dependencies |= [Google::Protobuf]

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
  class StatusType < ::Protobuf::Enum
    FULLY_QUALIFIED_NAME = FULLY_QUALIFIED_NAME + '.StatusType'

    set_option :allow_alias, true
    set_option :".test.enum_option", -789

    define :PENDING, 0
    define :ENABLED, 1
    define :DISABLED, 2
    define :DELETED, 3
    define :ALIASED, 3
  end


  ##
  # Message Classes
  #
  class ResourceFindRequest < ::Protobuf::Message; end
  class ResourceSleepRequest < ::Protobuf::Message; end
  class Resource < ::Protobuf::Message; end
  class ResourceWithRequiredField < ::Protobuf::Message; end
  class Searchable < ::Protobuf::Message
    class SearchType < ::Protobuf::Enum
      FULLY_QUALIFIED_NAME = FULLY_QUALIFIED_NAME + '.SearchType'

      define :FLAT, 1
      define :NESTED, 2
    end

  end

  class MessageParent < ::Protobuf::Message
    class MessageChild < ::Protobuf::Message; end

  end

  class Nested < ::Protobuf::Message
    class NestedLevelOne < ::Protobuf::Message; end

  end



  ##
  # File Options
  #
  set_option :cc_generic_services, true
  set_option :".test.file_option", 9876543210


  ##
  # Message Fields
  #
  class ResourceFindRequest
    FULLY_QUALIFIED_NAME = FULLY_QUALIFIED_NAME + '.ResourceFindRequest'
    required :string, :name, 1
    optional :bool, :active, 2
    repeated :string, :widgets, 3
    repeated :bytes, :widget_bytes, 4
  end

  class ResourceSleepRequest
    FULLY_QUALIFIED_NAME = FULLY_QUALIFIED_NAME + '.ResourceSleepRequest'
    optional :int32, :sleep, 1
  end

  class Resource
    FULLY_QUALIFIED_NAME = FULLY_QUALIFIED_NAME + '.Resource'
    # Message Options
    set_option :map_entry, false
    set_option :".test.message_option", -56

    required :string, :name, 1, :ctype => ::Google::Protobuf::FieldOptions::CType::CORD, :".test.field_option" => 8765432109
    optional :int64, :date_created, 2
    optional ::Test::StatusType, :status, 3
    repeated ::Test::StatusType, :repeated_enum, 4
    # Extension Fields
    extensions 100...536870912
    optional :bool, :".test.Searchable.ext_is_searchable", 100, :extension => true
    optional :bool, :".test.Searchable.ext_is_hidden", 101, :extension => true
    optional ::Test::Searchable::SearchType, :".test.Searchable.ext_search_type", 102, :default => ::Test::Searchable::SearchType::FLAT, :extension => true
    optional :bool, :".test.Nested.NestedLevelOne.ext_nested_in_level_one", 105, :extension => true
    optional :bool, :".test.Nested.NestedLevelOne.ext_dup_field", 106, :extension => true
  end

  class ResourceWithRequiredField
    FULLY_QUALIFIED_NAME = FULLY_QUALIFIED_NAME + '.ResourceWithRequiredField'
    required :string, :foo_is_required, 1
  end

  class MessageParent
    FULLY_QUALIFIED_NAME = FULLY_QUALIFIED_NAME + '.MessageParent'
    class MessageChild
      FULLY_QUALIFIED_NAME = FULLY_QUALIFIED_NAME + '.MessageChild'
      optional :string, :child1, 1
    end

  end

  class Nested
    FULLY_QUALIFIED_NAME = FULLY_QUALIFIED_NAME + '.Nested'
    class NestedLevelOne
      FULLY_QUALIFIED_NAME = FULLY_QUALIFIED_NAME + '.NestedLevelOne'
      optional :bool, :level_one, 1, :default => true
      # Extension Fields
      extensions 100...102
      optional :bool, :".test.ext_nested_level_one_outer", 101, :extension => true
      optional :bool, :".test.Nested.ext_nested_level_one", 100, :extension => true
    end

    optional :string, :name, 1
    optional ::Test::Resource, :resource, 2
    repeated ::Test::Resource, :multiple_resources, 3
    optional ::Test::StatusType, :status, 4
    # Extension Fields
    extensions 100...111
    optional :string, :".test.foo", 100, :extension => true
    optional :int64, :".test.bar", 101, :extension => true
  end


  ##
  # Extended Message Fields
  #
  class ::Google::Protobuf::FileOptions < ::Protobuf::Message
    optional :uint64, :".test.file_option", 9585869, :extension => true
  end

  class ::Google::Protobuf::FieldOptions < ::Protobuf::Message
    optional :uint64, :".test.field_option", 858769, :extension => true
  end

  class ::Google::Protobuf::EnumOptions < ::Protobuf::Message
    optional :int64, :".test.enum_option", 590284, :extension => true
  end

  class ::Google::Protobuf::MessageOptions < ::Protobuf::Message
    optional :int64, :".test.message_option", 485969, :extension => true
  end

  class ::Google::Protobuf::ServiceOptions < ::Protobuf::Message
    optional :int64, :".test.service_option", 5869607, :extension => true
  end

  class ::Google::Protobuf::MethodOptions < ::Protobuf::Message
    optional :int64, :".test.method_option", 7893233, :extension => true
  end


  ##
  # Service Classes
  #
  class ResourceService < ::Protobuf::Rpc::Service
    FULLY_QUALIFIED_NAME = FULLY_QUALIFIED_NAME + '.ResourceService'

    set_option :".test.service_option", -9876543210
    rpc :find, ::Test::ResourceFindRequest, ::Test::Resource do
      set_option :".test.method_option", 2
    end
    rpc :find_with_rpc_failed, ::Test::ResourceFindRequest, ::Test::Resource
    rpc :find_with_sleep, ::Test::ResourceSleepRequest, ::Test::Resource
    rpc :find_not_implemented, ::Test::ResourceFindRequest, ::Test::Resource
  end

end


# Raw descriptor bytes below
__END__
ChVwcm90b3MvcmVzb3VyY2UucHJvdG8SBHRlc3QaIGdvb2dsZS9wcm90b2J1
Zi9kZXNjcmlwdG9yLnByb3RvIn4KE1Jlc291cmNlRmluZFJlcXVlc3QSEgoE
bmFtZRgBIAIoCVIEbmFtZRIWCgZhY3RpdmUYAiABKAhSBmFjdGl2ZRIYCgd3
aWRnZXRzGAMgAygJUgd3aWRnZXRzEiEKDHdpZGdldF9ieXRlcxgEIAMoDFIL
d2lkZ2V0Qnl0ZXMiLAoUUmVzb3VyY2VTbGVlcFJlcXVlc3QSFAoFc2xlZXAY
ASABKAVSBXNsZWVwIssBCghSZXNvdXJjZRIfCgRuYW1lGAEgAigJQgsIAYip
owOtwtfTIFIEbmFtZRIhCgxkYXRlX2NyZWF0ZWQYAiABKANSC2RhdGVDcmVh
dGVkEigKBnN0YXR1cxgDIAEoDjIQLnRlc3QuU3RhdHVzVHlwZVIGc3RhdHVz
EjUKDXJlcGVhdGVkX2VudW0YBCADKA4yEC50ZXN0LlN0YXR1c1R5cGVSDHJl
cGVhdGVkRW51bSoICGQQgICAgAI6EDgAiKXtAcj//////////wEiQwoZUmVz
b3VyY2VXaXRoUmVxdWlyZWRGaWVsZBImCg9mb29faXNfcmVxdWlyZWQYASAC
KAlSDWZvb0lzUmVxdWlyZWQi+wEKClNlYXJjaGFibGUiIgoKU2VhcmNoVHlw
ZRIICgRGTEFUEAESCgoGTkVTVEVEEAIyOgoRZXh0X2lzX3NlYXJjaGFibGUS
Di50ZXN0LlJlc291cmNlGGQgASgIUg9leHRJc1NlYXJjaGFibGUyMgoNZXh0
X2lzX2hpZGRlbhIOLnRlc3QuUmVzb3VyY2UYZSABKAhSC2V4dElzSGlkZGVu
MlkKD2V4dF9zZWFyY2hfdHlwZRIOLnRlc3QuUmVzb3VyY2UYZiABKA4yGy50
ZXN0LlNlYXJjaGFibGUuU2VhcmNoVHlwZToERkxBVFINZXh0U2VhcmNoVHlw
ZSI3Cg1NZXNzYWdlUGFyZW50GiYKDE1lc3NhZ2VDaGlsZBIWCgZjaGlsZDEY
ASABKAlSBmNoaWxkMSK7AwoGTmVzdGVkEhIKBG5hbWUYASABKAlSBG5hbWUS
KgoIcmVzb3VyY2UYAiABKAsyDi50ZXN0LlJlc291cmNlUghyZXNvdXJjZRI9
ChJtdWx0aXBsZV9yZXNvdXJjZXMYAyADKAsyDi50ZXN0LlJlc291cmNlUhFt
dWx0aXBsZVJlc291cmNlcxIoCgZzdGF0dXMYBCABKA4yEC50ZXN0LlN0YXR1
c1R5cGVSBnN0YXR1cxqzAQoOTmVzdGVkTGV2ZWxPbmUSIQoJbGV2ZWxfb25l
GAEgASgIOgR0cnVlUghsZXZlbE9uZSoECGQQZjJEChdleHRfbmVzdGVkX2lu
X2xldmVsX29uZRIOLnRlc3QuUmVzb3VyY2UYaSABKAhSE2V4dE5lc3RlZElu
TGV2ZWxPbmUyMgoNZXh0X2R1cF9maWVsZBIOLnRlc3QuUmVzb3VyY2UYaiAB
KAhSC2V4dER1cEZpZWxkKgQIZBBvMkwKFGV4dF9uZXN0ZWRfbGV2ZWxfb25l
EhsudGVzdC5OZXN0ZWQuTmVzdGVkTGV2ZWxPbmUYZCABKAhSEWV4dE5lc3Rl
ZExldmVsT25lKmAKClN0YXR1c1R5cGUSCwoHUEVORElORxAAEgsKB0VOQUJM
RUQQARIMCghESVNBQkxFRBACEgsKB0RFTEVURUQQAxILCgdBTElBU0VEEAMa
EBAB4JygAuv5/////////wEymQIKD1Jlc291cmNlU2VydmljZRI4CgRGaW5k
EhkudGVzdC5SZXNvdXJjZUZpbmRSZXF1ZXN0Gg4udGVzdC5SZXNvdXJjZSIF
iI+OHgISPgoRRmluZFdpdGhScGNGYWlsZWQSGS50ZXN0LlJlc291cmNlRmlu
ZFJlcXVlc3QaDi50ZXN0LlJlc291cmNlEjsKDUZpbmRXaXRoU2xlZXASGi50
ZXN0LlJlc291cmNlU2xlZXBSZXF1ZXN0Gg4udGVzdC5SZXNvdXJjZRI/ChJG
aW5kTm90SW1wbGVtZW50ZWQSGS50ZXN0LlJlc291cmNlRmluZFJlcXVlc3Qa
Di50ZXN0LlJlc291cmNlGg64grIWltK/mtv/////ATpACgtmaWxlX29wdGlv
bhIcLmdvb2dsZS5wcm90b2J1Zi5GaWxlT3B0aW9ucxjNickEIAEoBFIKZmls
ZU9wdGlvbjpCCgxmaWVsZF9vcHRpb24SHS5nb29nbGUucHJvdG9idWYuRmll
bGRPcHRpb25zGJG1NCABKARSC2ZpZWxkT3B0aW9uOj8KC2VudW1fb3B0aW9u
EhwuZ29vZ2xlLnByb3RvYnVmLkVudW1PcHRpb25zGMyDJCABKANSCmVudW1P
cHRpb246SAoObWVzc2FnZV9vcHRpb24SHy5nb29nbGUucHJvdG9idWYuTWVz
c2FnZU9wdGlvbnMY0dQdIAEoA1INbWVzc2FnZU9wdGlvbjpJCg5zZXJ2aWNl
X29wdGlvbhIfLmdvb2dsZS5wcm90b2J1Zi5TZXJ2aWNlT3B0aW9ucxinoOYC
IAEoA1INc2VydmljZU9wdGlvbjpGCg1tZXRob2Rfb3B0aW9uEh4uZ29vZ2xl
LnByb3RvYnVmLk1ldGhvZE9wdGlvbnMY8eHhAyABKANSDG1ldGhvZE9wdGlv
bjoeCgNmb28SDC50ZXN0Lk5lc3RlZBhkIAEoCVIDZm9vOh4KA2JhchIMLnRl
c3QuTmVzdGVkGGUgASgDUgNiYXI6VwoaZXh0X25lc3RlZF9sZXZlbF9vbmVf
b3V0ZXISGy50ZXN0Lk5lc3RlZC5OZXN0ZWRMZXZlbE9uZRhlIAEoCFIWZXh0
TmVzdGVkTGV2ZWxPbmVPdXRlckIMgAEB6MzIJOqtwOUkSsAdCgcSBQAAhwEB
CggKAQwSAwAAEgoJCgIDABIDAgAqCggKAQISAwQADQoICgEIEgMGACIKCQoC
CBASAwYAIgoICgEIEgMHACIKDAoFCM2JyQQSAwcAIgoJCgEHEgQJAAsBCgkK
AgcAEgMKAigKCgoDBwACEgMJByIKCgoDBwAEEgMKAgoKCgoDBwAFEgMKCxEK
CgoDBwABEgMKEh0KCgoDBwADEgMKICcKCQoBBxIEDQAPAQoJCgIHARIDDgIo
CgoKAwcBAhIDDQcjCgoKAwcBBBIDDgIKCgoKAwcBBRIDDgsRCgoKAwcBARID
DhIeCgoKAwcBAxIDDiEnCgkKAQcSBBEAEwEKCQoCBwISAxICJgoKCgMHAgIS
AxEHIgoKCgMHAgQSAxICCgoKCgMHAgUSAxILEAoKCgMHAgESAxIRHAoKCgMH
AgMSAxIfJQoJCgEHEgQVABcBCgkKAgcDEgMWAikKCgoDBwMCEgMVByUKCgoD
BwMEEgMWAgoKCgoDBwMFEgMWCxAKCgoDBwMBEgMWER8KCgoDBwMDEgMWIigK
CQoBBxIEGQAbAQoJCgIHBBIDGgIqCgoKAwcEAhIDGQclCgoKAwcEBBIDGgIK
CgoKAwcEBRIDGgsQCgoKAwcEARIDGhEfCgoKAwcEAxIDGiIpCgkKAQcSBB0A
HwEKCQoCBwUSAx4CKQoKCgMHBQISAx0HJAoKCgMHBQQSAx4CCgoKCgMHBQUS
Ax4LEAoKCgMHBQESAx4RHgoKCgMHBQMSAx4hKAoKCgIFABIEIQAqAQoKCgMF
AAESAyEFDwoKCgMFAAMSAyICHAoLCgQFAAMCEgMiAhwKCgoDBQADEgMjAh4K
DQoGBQADzIMkEgMjAh4KCwoEBQACABIDJQIOCgwKBQUAAgABEgMlAgkKDAoF
BQACAAISAyUMDQoLCgQFAAIBEgMmAg4KDAoFBQACAQESAyYCCQoMCgUFAAIB
AhIDJgwNCgsKBAUAAgISAycCDwoMCgUFAAICARIDJwIKCgwKBQUAAgICEgMn
DQ4KCwoEBQACAxIDKAIOCgwKBQUAAgMBEgMoAgkKDAoFBQACAwISAygMDQoL
CgQFAAIEEgMpAg4KDAoFBQACBAESAykCCQoMCgUFAAIEAhIDKQwNCgoKAgQA
EgQsADEBCgoKAwQAARIDLAgbCgsKBAQAAgASAy0CGwoMCgUEAAIABBIDLQIK
CgwKBQQAAgAFEgMtCxEKDAoFBAACAAESAy0SFgoMCgUEAAIAAxIDLRkaCgsK
BAQAAgESAy4CGwoMCgUEAAIBBBIDLgIKCgwKBQQAAgEFEgMuCw8KDAoFBAAC
AQESAy4QFgoMCgUEAAIBAxIDLhkaCgsKBAQAAgISAy8CHgoMCgUEAAICBBID
LwIKCgwKBQQAAgIFEgMvCxEKDAoFBAACAgESAy8SGQoMCgUEAAICAxIDLxwd
CgsKBAQAAgMSAzACIgoMCgUEAAIDBBIDMAIKCgwKBQQAAgMFEgMwCxAKDAoF
BAACAwESAzARHQoMCgUEAAIDAxIDMCAhCgoKAgQBEgQzADUBCgoKAwQBARID
MwgcCgsKBAQBAgASAzQCGwoMCgUEAQIABBIDNAIKCgwKBQQBAgAFEgM0CxAK
DAoFBAECAAESAzQRFgoMCgUEAQIAAxIDNBkaCgoKAgQCEgQ3AEEBCgoKAwQC
ARIDNwgQCgoKAwQCBxIDOAIbCgsKBAQCBwcSAzgCGwoKCgMEAgcSAzkCIAoN
CgYEAgfR1B0SAzkCIAoKCgMEAgUSAzsCGAoLCgQEAgUAEgM7DRcKDAoFBAIF
AAESAzsNEAoMCgUEAgUAAhIDOxQXCgsKBAQCAgASAz0CRwoMCgUEAgIABBID
PQIKCgwKBQQCAgAFEgM9CxEKDAoFBAICAAESAz0SFgoMCgUEAgIAAxIDPRka
CgwKBQQCAgAIEgM9G0YKDwoIBAICAAiRtTQSAz0cNwoNCgYEAgIACAESAz05
RQoLCgQEAgIBEgM+AiIKDAoFBAICAQQSAz4CCgoMCgUEAgIBBRIDPgsQCgwK
BQQCAgEBEgM+ER0KDAoFBAICAQMSAz4gIQoLCgQEAgICEgM/AiEKDAoFBAIC
AgQSAz8CCgoMCgUEAgICBhIDPwsVCgwKBQQCAgIBEgM/FhwKDAoFBAICAgMS
Az8fIAoLCgQEAgIDEgNAAigKDAoFBAICAwQSA0ACCgoMCgUEAgIDBhIDQAsV
CgwKBQQCAgMBEgNAFiMKDAoFBAICAwMSA0AmJwoKCgIEAxIEQwBFAQoKCgME
AwESA0MIIQoLCgQEAwIAEgNEAiYKDAoFBAMCAAQSA0QCCgoMCgUEAwIABRID
RAsRCgwKBQQDAgABEgNEEiEKDAoFBAMCAAMSA0QkJQoKCgIEBBIERwBSAQoK
CgMEBAESA0cIEgoMCgQEBAQAEgRIAksDCgwKBQQEBAABEgNIBxEKDQoGBAQE
AAIAEgNJBA0KDgoHBAQEAAIAARIDSQQICg4KBwQEBAACAAISA0kLDAoNCgYE
BAQAAgESA0oEDwoOCgcEBAQAAgEBEgNKBAoKDgoHBAQEAAIBAhIDSg0OCgsK
AwQEBhIETQJRAwoLCgQEBAYAEgNOBCoKDAoFBAQGAAISA00JFgoMCgUEBAYA
BBIDTgQMCgwKBQQEBgAFEgNODREKDAoFBAQGAAESA04SIwoMCgUEBAYAAxID
TiYpCgsKBAQEBgESA08EJgoMCgUEBAYBAhIDTQkWCgwKBQQEBgEEEgNPBAwK
DAoFBAQGAQUSA08NEQoMCgUEBAYBARIDTxIfCgwKBQQEBgEDEgNPIiUKCwoE
BAQGAhIDUARICgwKBQQEBgICEgNNCRYKDAoFBAQGAgQSA1AEDAoMCgUEBAYC
BhIDUA0iCgwKBQQEBgIBEgNQIzIKDAoFBAQGAgMSA1A1OAoMCgUEBAYCCBID
UDlHCgwKBQQEBgIHEgNQQkYKCgoCBAUSBFQAWAEKCgoDBAUBEgNUCBUKDAoE
BAUDABIEVQJXAwoMCgUEBQMAARIDVQoWCg0KBgQFAwACABIDVgQfCg4KBwQF
AwACAAQSA1YEDAoOCgcEBQMAAgAFEgNWDRMKDgoHBAUDAAIAARIDVhQaCg4K
BwQFAwACAAMSA1YdHgoKCgIEBhIEWgBzAQoKCgMEBgESA1oIDgoKCgMEBgUS
A1sCGAoLCgQEBgUAEgNbDRcKDAoFBAYFAAESA1sNEAoMCgUEBgUAAhIDWxQX
CgsKBAQGAgASA10CGwoMCgUEBgIABBIDXQIKCgwKBQQGAgAFEgNdCxEKDAoF
BAYCAAESA10SFgoMCgUEBgIAAxIDXRkaCgsKBAQGAgESA14CIQoMCgUEBgIB
BBIDXgIKCgwKBQQGAgEGEgNeCxMKDAoFBAYCAQESA14UHAoMCgUEBgIBAxID
Xh8gCgsKBAQGAgISA18CKwoMCgUEBgICBBIDXwIKCgwKBQQGAgIGEgNfCxMK
DAoFBAYCAgESA18UJgoMCgUEBgICAxIDXykqCgsKBAQGAgMSA2ACIQoMCgUE
BgIDBBIDYAIKCgwKBQQGAgMGEgNgCxUKDAoFBAYCAwESA2AWHAoMCgUEBgID
AxIDYB8gCgwKBAQGAwASBGICagMKDAoFBAYDAAESA2IKGAoMCgUEBgMABRID
YwQaCg0KBgQGAwAFABIDYw8ZCg4KBwQGAwAFAAESA2MPEgoOCgcEBgMABQAC
EgNjFhkKDQoGBAYDAAIAEgNkBC8KDgoHBAYDAAIABBIDZAQMCg4KBwQGAwAC
AAUSA2QNEQoOCgcEBgMAAgABEgNkEhsKDgoHBAYDAAIAAxIDZB4fCg4KBwQG
AwACAAgSA2QgLgoOCgcEBgMAAgAHEgNkKS0KDQoFBAYDAAYSBGYEaQUKDQoG
BAYDAAYAEgNnBjIKDgoHBAYDAAYAAhIDZgsTCg4KBwQGAwAGAAQSA2cGDgoO
CgcEBgMABgAFEgNnDxMKDgoHBAYDAAYAARIDZxQrCg4KBwQGAwAGAAMSA2cu
MQoNCgYEBgMABgESA2gGKAoOCgcEBgMABgECEgNmCxMKDgoHBAYDAAYBBBID
aAYOCg4KBwQGAwAGAQUSA2gPEwoOCgcEBgMABgEBEgNoFCEKDgoHBAYDAAYB
AxIDaCQnCgsKAwQGBhIEbAJuAwoLCgQEBgYAEgNtBC0KDAoFBAYGAAISA2wJ
FwoMCgUEBgYABBIDbQQMCgwKBQQGBgAFEgNtDREKDAoFBAYGAAESA20SJgoM
CgUEBgYAAxIDbSksCgkKAQcSBHUAeAEKCQoCBwYSA3YCHAoKCgMHBgISA3UH
DQoKCgMHBgQSA3YCCgoKCgMHBgUSA3YLEQoKCgMHBgESA3YSFQoKCgMHBgMS
A3YYGwoJCgIHBxIDdwIbCgoKAwcHAhIDdQcNCgoKAwcHBBIDdwIKCgoKAwcH
BRIDdwsQCgoKAwcHARIDdxEUCgoKAwcHAxIDdxcaCgkKAQcSBHoAfAEKCQoC
BwgSA3sCMQoKCgMHCAISA3oHHAoKCgMHCAQSA3sCCgoKCgMHCAUSA3sLDwoK
CgMHCAESA3sQKgoKCgMHCAMSA3stMAoLCgIGABIFfgCHAQEKCgoDBgABEgN+
CBcKCgoDBgADEgN/AigKDgoHBgADp6DmAhIDfwIoCg4KBAYAAgASBoEBAoMB
AwoNCgUGAAIAARIEgQEGCgoNCgUGAAIAAhIEgQEMHwoNCgUGAAIAAxIEgQEq
MgoNCgUGAAIABBIEggEEHwoRCgkGAAIABPHh4QMSBIIBBB8KDAoEBgACARIE
hAECQQoNCgUGAAIBARIEhAEGFwoNCgUGAAIBAhIEhAEZLAoNCgUGAAIBAxIE
hAE3PwoMCgQGAAICEgSFAQI+Cg0KBQYAAgIBEgSFAQYTCg0KBQYAAgICEgSF
ARUpCg0KBQYAAgIDEgSFATQ8CgwKBAYAAgMSBIYBAkIKDQoFBgACAwESBIYB
BhgKDQoFBgACAwISBIYBGi0KDQoFBgACAwMSBIYBOEA=
