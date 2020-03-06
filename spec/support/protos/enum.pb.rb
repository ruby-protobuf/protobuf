# encoding: utf-8
# frozen_string_literal: true

##
# This file is auto-generated. DO NOT EDIT!
#
require 'base64'
require 'set'
require 'protobuf'


##
# Imports
#
require 'protos/resource.pb'

module Test
  FULLY_QUALIFIED_NAME = 'test' unless defined?(self::FULLY_QUALIFIED_NAME)

  @descriptors = [] unless instance_variable_defined?(:@descriptors)
  @descriptors << lambda do
    bytes = File.read(__FILE__, mode: 'rb').split(/^__END__$/, 2).last
    ::Google::Protobuf::FileDescriptorProto.decode(Base64.decode64(bytes))
  end

  @descriptor_dependencies = Set.new unless instance_variable_defined?(:@descriptor_dependencies)
  @descriptor_dependencies |= [Test]

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
  class EnumTestType < ::Protobuf::Enum
    FULLY_QUALIFIED_NAME = FULLY_QUALIFIED_NAME + '.EnumTestType'

    define :ZERO, 0
    define :ONE, 1
    define :TWO, 2
  end

  class AliasedEnum < ::Protobuf::Enum
    FULLY_QUALIFIED_NAME = FULLY_QUALIFIED_NAME + '.AliasedEnum'

    set_option :allow_alias, true

    define :THREE, 3
    define :TRES, 3
    define :FOUR, 4
    define :CUATRO, 4
  end


  ##
  # Message Classes
  #
  class EnumTestMessage < ::Protobuf::Message; end


  ##
  # Message Fields
  #
  class EnumTestMessage
    FULLY_QUALIFIED_NAME = FULLY_QUALIFIED_NAME + '.EnumTestMessage'
    optional ::Test::EnumTestType, :non_default_enum, 1
    optional ::Test::EnumTestType, :default_enum, 2, :default => ::Test::EnumTestType::ONE
    repeated ::Test::EnumTestType, :repeated_enums, 3
    optional ::Test::AliasedEnum, :alias_non_default_enum, 4
    optional ::Test::AliasedEnum, :alias_default_enum, 5, :default => ::Test::AliasedEnum::CUATRO
    repeated ::Test::AliasedEnum, :alias_repeated_enums, 6
  end


  ##
  # Extended Message Fields
  #
  class ::Test::Resource < ::Protobuf::Message
    optional :int32, :".test.ext_other_file_defined_field", 200, :extension => true
  end

end


# Raw descriptor bytes below
__END__
ChFwcm90b3MvZW51bS5wcm90bxIEdGVzdBoVcHJvdG9zL3Jlc291cmNlLnBy
b3RvIpwDCg9FbnVtVGVzdE1lc3NhZ2USPAoQbm9uX2RlZmF1bHRfZW51bRgB
IAEoDjISLnRlc3QuRW51bVRlc3RUeXBlUg5ub25EZWZhdWx0RW51bRI6Cgxk
ZWZhdWx0X2VudW0YAiABKA4yEi50ZXN0LkVudW1UZXN0VHlwZToDT05FUgtk
ZWZhdWx0RW51bRI5Cg5yZXBlYXRlZF9lbnVtcxgDIAMoDjISLnRlc3QuRW51
bVRlc3RUeXBlUg1yZXBlYXRlZEVudW1zEkYKFmFsaWFzX25vbl9kZWZhdWx0
X2VudW0YBCABKA4yES50ZXN0LkFsaWFzZWRFbnVtUhNhbGlhc05vbkRlZmF1
bHRFbnVtEkcKEmFsaWFzX2RlZmF1bHRfZW51bRgFIAEoDjIRLnRlc3QuQWxp
YXNlZEVudW06BkNVQVRST1IQYWxpYXNEZWZhdWx0RW51bRJDChRhbGlhc19y
ZXBlYXRlZF9lbnVtcxgGIAMoDjIRLnRlc3QuQWxpYXNlZEVudW1SEmFsaWFz
UmVwZWF0ZWRFbnVtcyoqCgxFbnVtVGVzdFR5cGUSCAoEWkVSTxAAEgcKA09O
RRABEgcKA1RXTxACKjwKC0FsaWFzZWRFbnVtEgkKBVRIUkVFEAMSCAoEVFJF
UxADEggKBEZPVVIQBBIKCgZDVUFUUk8QBBoCEAE6TwocZXh0X290aGVyX2Zp
bGVfZGVmaW5lZF9maWVsZBIOLnRlc3QuUmVzb3VyY2UYyAEgASgFUhhleHRP
dGhlckZpbGVEZWZpbmVkRmllbGRKmAgKBhIEAAAkAQoICgEMEgMAABIKCAoB
AhIDAgANCgkKAgMAEgMDAB8KQwoCBQASBAcACwEyNyBUZXN0IGV4dGVuZGlu
ZyBhbm90aGVyIG1lc3NhZ2UgZnJvbSBhbiBpbXBvcnRlZCBmaWxlLgoKCgoD
BQABEgMHBREKCwoEBQACABIDCAILCgwKBQUAAgABEgMIAgYKDAoFBQACAAIS
AwgJCgoLCgQFAAIBEgMJAgoKDAoFBQACAQESAwkCBQoMCgUFAAIBAhIDCQgJ
CgsKBAUAAgISAwoCCgoMCgUFAAICARIDCgIFCgwKBQUAAgICEgMKCAkKGgoC
BQESBA4AFgEaDiBVc2VzIGFsaWFzZXMKCgoKAwUBARIDDgUQCgoKAwUBAxID
DwIcCgsKBAUBAwISAw8CHAoLCgQFAQIAEgMRAg0KDAoFBQECAAESAxECBwoM
CgUFAQIAAhIDEQsMCgsKBAUBAgESAxICDQoMCgUFAQIBARIDEgIGCgwKBQUB
AgECEgMSCwwKCwoEBQECAhIDFAINCgwKBQUBAgIBEgMUAgYKDAoFBQECAgIS
AxQLDAoLCgQFAQIDEgMVAg0KDAoFBQECAwESAxUCCAoMCgUFAQIDAhIDFQsM
CgoKAgQAEgQYACABCgoKAwQAARIDGAgXCgsKBAQAAgASAxkCLQoMCgUEAAIA
BBIDGQIKCgwKBQQAAgAGEgMZCxcKDAoFBAACAAESAxkYKAoMCgUEAAIAAxID
GSssCgsKBAQAAgESAxoCNwoMCgUEAAIBBBIDGgIKCgwKBQQAAgEGEgMaCxcK
DAoFBAACAQESAxoYJAoMCgUEAAIBAxIDGicoCgwKBQQAAgEIEgMaKTYKDAoF
BAACAQcSAxoyNQoLCgQEAAICEgMbAisKDAoFBAACAgQSAxsCCgoMCgUEAAIC
BhIDGwsXCgwKBQQAAgIBEgMbGCYKDAoFBAACAgMSAxspKgoLCgQEAAIDEgMd
AjIKDAoFBAACAwQSAx0CCgoMCgUEAAIDBhIDHQsWCgwKBQQAAgMBEgMdFy0K
DAoFBAACAwMSAx0wMQoLCgQEAAIEEgMeAj8KDAoFBAACBAQSAx4CCgoMCgUE
AAIEBhIDHgsWCgwKBQQAAgQBEgMeFykKDAoFBAACBAMSAx4sLQoMCgUEAAIE
CBIDHi4+CgwKBQQAAgQHEgMeNz0KCwoEBAACBRIDHwIwCgwKBQQAAgUEEgMf
AgoKDAoFBAACBQYSAx8LFgoMCgUEAAIFARIDHxcrCgwKBQQAAgUDEgMfLi8K
CQoBBxIEIgAkAQoJCgIHABIDIwI0CgoKAwcAAhIDIgcUCgoKAwcABBIDIwIK
CgoKAwcABRIDIwsQCgoKAwcAARIDIxEtCgoKAwcAAxIDIzAz
