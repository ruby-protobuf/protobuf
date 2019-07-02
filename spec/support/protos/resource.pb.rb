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
KAlSDWZvb0lzUmVxdWlyZWQirgIKClNlYXJjaGFibGUiIgoKU2VhcmNoVHlw
ZRIICgRGTEFUEAESCgoGTkVTVEVEEAIySwoiLnRlc3QuU2VhcmNoYWJsZS5l
eHRfaXNfc2VhcmNoYWJsZRIOLnRlc3QuUmVzb3VyY2UYZCABKAhSD2V4dElz
U2VhcmNoYWJsZTJDCh4udGVzdC5TZWFyY2hhYmxlLmV4dF9pc19oaWRkZW4S
Di50ZXN0LlJlc291cmNlGGUgASgIUgtleHRJc0hpZGRlbjJqCiAudGVzdC5T
ZWFyY2hhYmxlLmV4dF9zZWFyY2hfdHlwZRIOLnRlc3QuUmVzb3VyY2UYZiAB
KA4yGy50ZXN0LlNlYXJjaGFibGUuU2VhcmNoVHlwZToERkxBVFINZXh0U2Vh
cmNoVHlwZSI3Cg1NZXNzYWdlUGFyZW50GiYKDE1lc3NhZ2VDaGlsZBIWCgZj
aGlsZDEYASABKAlSBmNoaWxkMSKABAoGTmVzdGVkEhIKBG5hbWUYASABKAlS
BG5hbWUSKgoIcmVzb3VyY2UYAiABKAsyDi50ZXN0LlJlc291cmNlUghyZXNv
dXJjZRI9ChJtdWx0aXBsZV9yZXNvdXJjZXMYAyADKAsyDi50ZXN0LlJlc291
cmNlUhFtdWx0aXBsZVJlc291cmNlcxIoCgZzdGF0dXMYBCABKA4yEC50ZXN0
LlN0YXR1c1R5cGVSBnN0YXR1cxrrAQoOTmVzdGVkTGV2ZWxPbmUSIQoJbGV2
ZWxfb25lGAEgASgIOgR0cnVlUghsZXZlbE9uZSoECGQQZjJgCjMudGVzdC5O
ZXN0ZWQuTmVzdGVkTGV2ZWxPbmUuZXh0X25lc3RlZF9pbl9sZXZlbF9vbmUS
Di50ZXN0LlJlc291cmNlGGkgASgIUhNleHROZXN0ZWRJbkxldmVsT25lMk4K
KS50ZXN0Lk5lc3RlZC5OZXN0ZWRMZXZlbE9uZS5leHRfZHVwX2ZpZWxkEg4u
dGVzdC5SZXNvdXJjZRhqIAEoCFILZXh0RHVwRmllbGQqBAhkEG8yWQohLnRl
c3QuTmVzdGVkLmV4dF9uZXN0ZWRfbGV2ZWxfb25lEhsudGVzdC5OZXN0ZWQu
TmVzdGVkTGV2ZWxPbmUYZCABKAhSEWV4dE5lc3RlZExldmVsT25lKmAKClN0
YXR1c1R5cGUSCwoHUEVORElORxAAEgsKB0VOQUJMRUQQARIMCghESVNBQkxF
RBACEgsKB0RFTEVURUQQAxILCgdBTElBU0VEEAMaEBAB4JygAuv5////////
/wEymQIKD1Jlc291cmNlU2VydmljZRI4CgRGaW5kEhkudGVzdC5SZXNvdXJj
ZUZpbmRSZXF1ZXN0Gg4udGVzdC5SZXNvdXJjZSIFiI+OHgISPgoRRmluZFdp
dGhScGNGYWlsZWQSGS50ZXN0LlJlc291cmNlRmluZFJlcXVlc3QaDi50ZXN0
LlJlc291cmNlEjsKDUZpbmRXaXRoU2xlZXASGi50ZXN0LlJlc291cmNlU2xl
ZXBSZXF1ZXN0Gg4udGVzdC5SZXNvdXJjZRI/ChJGaW5kTm90SW1wbGVtZW50
ZWQSGS50ZXN0LlJlc291cmNlRmluZFJlcXVlc3QaDi50ZXN0LlJlc291cmNl
Gg64grIWltK/mtv/////ATpGChEudGVzdC5maWxlX29wdGlvbhIcLmdvb2ds
ZS5wcm90b2J1Zi5GaWxlT3B0aW9ucxjNickEIAEoBFIKZmlsZU9wdGlvbjpI
ChIudGVzdC5maWVsZF9vcHRpb24SHS5nb29nbGUucHJvdG9idWYuRmllbGRP
cHRpb25zGJG1NCABKARSC2ZpZWxkT3B0aW9uOkUKES50ZXN0LmVudW1fb3B0
aW9uEhwuZ29vZ2xlLnByb3RvYnVmLkVudW1PcHRpb25zGMyDJCABKANSCmVu
dW1PcHRpb246TgoULnRlc3QubWVzc2FnZV9vcHRpb24SHy5nb29nbGUucHJv
dG9idWYuTWVzc2FnZU9wdGlvbnMY0dQdIAEoA1INbWVzc2FnZU9wdGlvbjpP
ChQudGVzdC5zZXJ2aWNlX29wdGlvbhIfLmdvb2dsZS5wcm90b2J1Zi5TZXJ2
aWNlT3B0aW9ucxinoOYCIAEoA1INc2VydmljZU9wdGlvbjpMChMudGVzdC5t
ZXRob2Rfb3B0aW9uEh4uZ29vZ2xlLnByb3RvYnVmLk1ldGhvZE9wdGlvbnMY
8eHhAyABKANSDG1ldGhvZE9wdGlvbjokCgkudGVzdC5mb28SDC50ZXN0Lk5l
c3RlZBhkIAEoCVIDZm9vOiQKCS50ZXN0LmJhchIMLnRlc3QuTmVzdGVkGGUg
ASgDUgNiYXI6XQogLnRlc3QuZXh0X25lc3RlZF9sZXZlbF9vbmVfb3V0ZXIS
Gy50ZXN0Lk5lc3RlZC5OZXN0ZWRMZXZlbE9uZRhlIAEoCFIWZXh0TmVzdGVk
TGV2ZWxPbmVPdXRlckIMgAEB6MzIJOqtwOUkSsAdCgcSBQAAhwEBCggKAQwS
AwAAEgoJCgIDABIDAgAqCggKAQISAwQADQoICgEIEgMGACIKCQoCCBASAwYA
IgoICgEIEgMHACIKDAoFCM2JyQQSAwcAIgoJCgEHEgQJAAsBCgkKAgcAEgMK
AigKCgoDBwACEgMJByIKCgoDBwAEEgMKAgoKCgoDBwAFEgMKCxEKCgoDBwAB
EgMKEh0KCgoDBwADEgMKICcKCQoBBxIEDQAPAQoJCgIHARIDDgIoCgoKAwcB
AhIDDQcjCgoKAwcBBBIDDgIKCgoKAwcBBRIDDgsRCgoKAwcBARIDDhIeCgoK
AwcBAxIDDiEnCgkKAQcSBBEAEwEKCQoCBwISAxICJgoKCgMHAgISAxEHIgoK
CgMHAgQSAxICCgoKCgMHAgUSAxILEAoKCgMHAgESAxIRHAoKCgMHAgMSAxIf
JQoJCgEHEgQVABcBCgkKAgcDEgMWAikKCgoDBwMCEgMVByUKCgoDBwMEEgMW
AgoKCgoDBwMFEgMWCxAKCgoDBwMBEgMWER8KCgoDBwMDEgMWIigKCQoBBxIE
GQAbAQoJCgIHBBIDGgIqCgoKAwcEAhIDGQclCgoKAwcEBBIDGgIKCgoKAwcE
BRIDGgsQCgoKAwcEARIDGhEfCgoKAwcEAxIDGiIpCgkKAQcSBB0AHwEKCQoC
BwUSAx4CKQoKCgMHBQISAx0HJAoKCgMHBQQSAx4CCgoKCgMHBQUSAx4LEAoK
CgMHBQESAx4RHgoKCgMHBQMSAx4hKAoKCgIFABIEIQAqAQoKCgMFAAESAyEF
DwoKCgMFAAMSAyICHAoLCgQFAAMCEgMiAhwKCgoDBQADEgMjAh4KDQoGBQAD
zIMkEgMjAh4KCwoEBQACABIDJQIOCgwKBQUAAgABEgMlAgkKDAoFBQACAAIS
AyUMDQoLCgQFAAIBEgMmAg4KDAoFBQACAQESAyYCCQoMCgUFAAIBAhIDJgwN
CgsKBAUAAgISAycCDwoMCgUFAAICARIDJwIKCgwKBQUAAgICEgMnDQ4KCwoE
BQACAxIDKAIOCgwKBQUAAgMBEgMoAgkKDAoFBQACAwISAygMDQoLCgQFAAIE
EgMpAg4KDAoFBQACBAESAykCCQoMCgUFAAIEAhIDKQwNCgoKAgQAEgQsADEB
CgoKAwQAARIDLAgbCgsKBAQAAgASAy0CGwoMCgUEAAIABBIDLQIKCgwKBQQA
AgAFEgMtCxEKDAoFBAACAAESAy0SFgoMCgUEAAIAAxIDLRkaCgsKBAQAAgES
Ay4CGwoMCgUEAAIBBBIDLgIKCgwKBQQAAgEFEgMuCw8KDAoFBAACAQESAy4Q
FgoMCgUEAAIBAxIDLhkaCgsKBAQAAgISAy8CHgoMCgUEAAICBBIDLwIKCgwK
BQQAAgIFEgMvCxEKDAoFBAACAgESAy8SGQoMCgUEAAICAxIDLxwdCgsKBAQA
AgMSAzACIgoMCgUEAAIDBBIDMAIKCgwKBQQAAgMFEgMwCxAKDAoFBAACAwES
AzARHQoMCgUEAAIDAxIDMCAhCgoKAgQBEgQzADUBCgoKAwQBARIDMwgcCgsK
BAQBAgASAzQCGwoMCgUEAQIABBIDNAIKCgwKBQQBAgAFEgM0CxAKDAoFBAEC
AAESAzQRFgoMCgUEAQIAAxIDNBkaCgoKAgQCEgQ3AEEBCgoKAwQCARIDNwgQ
CgoKAwQCBxIDOAIbCgsKBAQCBwcSAzgCGwoKCgMEAgcSAzkCIAoNCgYEAgfR
1B0SAzkCIAoKCgMEAgUSAzsCGAoLCgQEAgUAEgM7DRcKDAoFBAIFAAESAzsN
EAoMCgUEAgUAAhIDOxQXCgsKBAQCAgASAz0CRwoMCgUEAgIABBIDPQIKCgwK
BQQCAgAFEgM9CxEKDAoFBAICAAESAz0SFgoMCgUEAgIAAxIDPRkaCgwKBQQC
AgAIEgM9G0YKDwoIBAICAAiRtTQSAz0cNwoNCgYEAgIACAESAz05RQoLCgQE
AgIBEgM+AiIKDAoFBAICAQQSAz4CCgoMCgUEAgIBBRIDPgsQCgwKBQQCAgEB
EgM+ER0KDAoFBAICAQMSAz4gIQoLCgQEAgICEgM/AiEKDAoFBAICAgQSAz8C
CgoMCgUEAgICBhIDPwsVCgwKBQQCAgIBEgM/FhwKDAoFBAICAgMSAz8fIAoL
CgQEAgIDEgNAAigKDAoFBAICAwQSA0ACCgoMCgUEAgIDBhIDQAsVCgwKBQQC
AgMBEgNAFiMKDAoFBAICAwMSA0AmJwoKCgIEAxIEQwBFAQoKCgMEAwESA0MI
IQoLCgQEAwIAEgNEAiYKDAoFBAMCAAQSA0QCCgoMCgUEAwIABRIDRAsRCgwK
BQQDAgABEgNEEiEKDAoFBAMCAAMSA0QkJQoKCgIEBBIERwBSAQoKCgMEBAES
A0cIEgoMCgQEBAQAEgRIAksDCgwKBQQEBAABEgNIBxEKDQoGBAQEAAIAEgNJ
BA0KDgoHBAQEAAIAARIDSQQICg4KBwQEBAACAAISA0kLDAoNCgYEBAQAAgES
A0oEDwoOCgcEBAQAAgEBEgNKBAoKDgoHBAQEAAIBAhIDSg0OCgsKAwQEBhIE
TQJRAwoLCgQEBAYAEgNOBCoKDAoFBAQGAAISA00JFgoMCgUEBAYABBIDTgQM
CgwKBQQEBgAFEgNODREKDAoFBAQGAAESA04SIwoMCgUEBAYAAxIDTiYpCgsK
BAQEBgESA08EJgoMCgUEBAYBAhIDTQkWCgwKBQQEBgEEEgNPBAwKDAoFBAQG
AQUSA08NEQoMCgUEBAYBARIDTxIfCgwKBQQEBgEDEgNPIiUKCwoEBAQGAhID
UARICgwKBQQEBgICEgNNCRYKDAoFBAQGAgQSA1AEDAoMCgUEBAYCBhIDUA0i
CgwKBQQEBgIBEgNQIzIKDAoFBAQGAgMSA1A1OAoMCgUEBAYCCBIDUDlHCgwK
BQQEBgIHEgNQQkYKCgoCBAUSBFQAWAEKCgoDBAUBEgNUCBUKDAoEBAUDABIE
VQJXAwoMCgUEBQMAARIDVQoWCg0KBgQFAwACABIDVgQfCg4KBwQFAwACAAQS
A1YEDAoOCgcEBQMAAgAFEgNWDRMKDgoHBAUDAAIAARIDVhQaCg4KBwQFAwAC
AAMSA1YdHgoKCgIEBhIEWgBzAQoKCgMEBgESA1oIDgoKCgMEBgUSA1sCGAoL
CgQEBgUAEgNbDRcKDAoFBAYFAAESA1sNEAoMCgUEBgUAAhIDWxQXCgsKBAQG
AgASA10CGwoMCgUEBgIABBIDXQIKCgwKBQQGAgAFEgNdCxEKDAoFBAYCAAES
A10SFgoMCgUEBgIAAxIDXRkaCgsKBAQGAgESA14CIQoMCgUEBgIBBBIDXgIK
CgwKBQQGAgEGEgNeCxMKDAoFBAYCAQESA14UHAoMCgUEBgIBAxIDXh8gCgsK
BAQGAgISA18CKwoMCgUEBgICBBIDXwIKCgwKBQQGAgIGEgNfCxMKDAoFBAYC
AgESA18UJgoMCgUEBgICAxIDXykqCgsKBAQGAgMSA2ACIQoMCgUEBgIDBBID
YAIKCgwKBQQGAgMGEgNgCxUKDAoFBAYCAwESA2AWHAoMCgUEBgIDAxIDYB8g
CgwKBAQGAwASBGICagMKDAoFBAYDAAESA2IKGAoMCgUEBgMABRIDYwQaCg0K
BgQGAwAFABIDYw8ZCg4KBwQGAwAFAAESA2MPEgoOCgcEBgMABQACEgNjFhkK
DQoGBAYDAAIAEgNkBC8KDgoHBAYDAAIABBIDZAQMCg4KBwQGAwACAAUSA2QN
EQoOCgcEBgMAAgABEgNkEhsKDgoHBAYDAAIAAxIDZB4fCg4KBwQGAwACAAgS
A2QgLgoOCgcEBgMAAgAHEgNkKS0KDQoFBAYDAAYSBGYEaQUKDQoGBAYDAAYA
EgNnBjIKDgoHBAYDAAYAAhIDZgsTCg4KBwQGAwAGAAQSA2cGDgoOCgcEBgMA
BgAFEgNnDxMKDgoHBAYDAAYAARIDZxQrCg4KBwQGAwAGAAMSA2cuMQoNCgYE
BgMABgESA2gGKAoOCgcEBgMABgECEgNmCxMKDgoHBAYDAAYBBBIDaAYOCg4K
BwQGAwAGAQUSA2gPEwoOCgcEBgMABgEBEgNoFCEKDgoHBAYDAAYBAxIDaCQn
CgsKAwQGBhIEbAJuAwoLCgQEBgYAEgNtBC0KDAoFBAYGAAISA2wJFwoMCgUE
BgYABBIDbQQMCgwKBQQGBgAFEgNtDREKDAoFBAYGAAESA20SJgoMCgUEBgYA
AxIDbSksCgkKAQcSBHUAeAEKCQoCBwYSA3YCHAoKCgMHBgISA3UHDQoKCgMH
BgQSA3YCCgoKCgMHBgUSA3YLEQoKCgMHBgESA3YSFQoKCgMHBgMSA3YYGwoJ
CgIHBxIDdwIbCgoKAwcHAhIDdQcNCgoKAwcHBBIDdwIKCgoKAwcHBRIDdwsQ
CgoKAwcHARIDdxEUCgoKAwcHAxIDdxcaCgkKAQcSBHoAfAEKCQoCBwgSA3sC
MQoKCgMHCAISA3oHHAoKCgMHCAQSA3sCCgoKCgMHCAUSA3sLDwoKCgMHCAES
A3sQKgoKCgMHCAMSA3stMAoLCgIGABIFfgCHAQEKCgoDBgABEgN+CBcKCgoD
BgADEgN/AigKDgoHBgADp6DmAhIDfwIoCg4KBAYAAgASBoEBAoMBAwoNCgUG
AAIAARIEgQEGCgoNCgUGAAIAAhIEgQEMHwoNCgUGAAIAAxIEgQEqMgoNCgUG
AAIABBIEggEEHwoRCgkGAAIABPHh4QMSBIIBBB8KDAoEBgACARIEhAECQQoN
CgUGAAIBARIEhAEGFwoNCgUGAAIBAhIEhAEZLAoNCgUGAAIBAxIEhAE3PwoM
CgQGAAICEgSFAQI+Cg0KBQYAAgIBEgSFAQYTCg0KBQYAAgICEgSFARUpCg0K
BQYAAgIDEgSFATQ8CgwKBAYAAgMSBIYBAkIKDQoFBgACAwESBIYBBhgKDQoF
BgACAwISBIYBGi0KDQoFBgACAwMSBIYBOEA=
