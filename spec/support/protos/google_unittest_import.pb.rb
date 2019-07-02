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
require 'protos/google_unittest_import_public.pb'

module Protobuf_unittest_import
  FULLY_QUALIFIED_NAME = 'protobuf_unittest_import' unless defined?(self::FULLY_QUALIFIED_NAME)

  @descriptors = [] unless instance_variable_defined?(:@descriptors)
  @descriptors << lambda do
    bytes = File.read(__FILE__, mode: 'rb').split(/^__END__$/, 2).last
    ::Google::Protobuf::FileDescriptorProto.decode(Base64.decode64(bytes))
  end

  @descriptor_dependencies = Set.new unless instance_variable_defined?(:@descriptor_dependencies)
  @descriptor_dependencies |= [Protobuf_unittest_import]

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
  class ImportEnum < ::Protobuf::Enum
    FULLY_QUALIFIED_NAME = FULLY_QUALIFIED_NAME + '.ImportEnum'

    define :IMPORT_FOO, 7
    define :IMPORT_BAR, 8
    define :IMPORT_BAZ, 9
  end

  class ImportEnumForMap < ::Protobuf::Enum
    FULLY_QUALIFIED_NAME = FULLY_QUALIFIED_NAME + '.ImportEnumForMap'

    define :UNKNOWN, 0
    define :FOO, 1
    define :BAR, 2
  end


  ##
  # Message Classes
  #
  class ImportMessage < ::Protobuf::Message; end


  ##
  # File Options
  #
  set_option :java_package, "com.google.protobuf.test"
  set_option :optimize_for, ::Google::Protobuf::FileOptions::OptimizeMode::SPEED
  set_option :cc_enable_arenas, true


  ##
  # Message Fields
  #
  class ImportMessage
    FULLY_QUALIFIED_NAME = FULLY_QUALIFIED_NAME + '.ImportMessage'
    optional :int32, :d, 1
  end

end


# Raw descriptor bytes below
__END__
CiNwcm90b3MvZ29vZ2xlX3VuaXR0ZXN0X2ltcG9ydC5wcm90bxIYcHJvdG9i
dWZfdW5pdHRlc3RfaW1wb3J0Gipwcm90b3MvZ29vZ2xlX3VuaXR0ZXN0X2lt
cG9ydF9wdWJsaWMucHJvdG8iHQoNSW1wb3J0TWVzc2FnZRIMCgFkGAEgASgF
UgFkKjwKCkltcG9ydEVudW0SDgoKSU1QT1JUX0ZPTxAHEg4KCklNUE9SVF9C
QVIQCBIOCgpJTVBPUlRfQkFaEAkqMQoQSW1wb3J0RW51bUZvck1hcBILCgdV
TktOT1dOEAASBwoDRk9PEAESBwoDQkFSEAJCHwoYY29tLmdvb2dsZS5wcm90
b2J1Zi50ZXN0SAH4AQFKwBUKBhIEJABIAQqYDgoBDBIDJAASMsEMIFByb3Rv
Y29sIEJ1ZmZlcnMgLSBHb29nbGUncyBkYXRhIGludGVyY2hhbmdlIGZvcm1h
dAogQ29weXJpZ2h0IDIwMDggR29vZ2xlIEluYy4gIEFsbCByaWdodHMgcmVz
ZXJ2ZWQuCiBodHRwczovL2RldmVsb3BlcnMuZ29vZ2xlLmNvbS9wcm90b2Nv
bC1idWZmZXJzLwoKIFJlZGlzdHJpYnV0aW9uIGFuZCB1c2UgaW4gc291cmNl
IGFuZCBiaW5hcnkgZm9ybXMsIHdpdGggb3Igd2l0aG91dAogbW9kaWZpY2F0
aW9uLCBhcmUgcGVybWl0dGVkIHByb3ZpZGVkIHRoYXQgdGhlIGZvbGxvd2lu
ZyBjb25kaXRpb25zIGFyZQogbWV0OgoKICAgICAqIFJlZGlzdHJpYnV0aW9u
cyBvZiBzb3VyY2UgY29kZSBtdXN0IHJldGFpbiB0aGUgYWJvdmUgY29weXJp
Z2h0CiBub3RpY2UsIHRoaXMgbGlzdCBvZiBjb25kaXRpb25zIGFuZCB0aGUg
Zm9sbG93aW5nIGRpc2NsYWltZXIuCiAgICAgKiBSZWRpc3RyaWJ1dGlvbnMg
aW4gYmluYXJ5IGZvcm0gbXVzdCByZXByb2R1Y2UgdGhlIGFib3ZlCiBjb3B5
cmlnaHQgbm90aWNlLCB0aGlzIGxpc3Qgb2YgY29uZGl0aW9ucyBhbmQgdGhl
IGZvbGxvd2luZyBkaXNjbGFpbWVyCiBpbiB0aGUgZG9jdW1lbnRhdGlvbiBh
bmQvb3Igb3RoZXIgbWF0ZXJpYWxzIHByb3ZpZGVkIHdpdGggdGhlCiBkaXN0
cmlidXRpb24uCiAgICAgKiBOZWl0aGVyIHRoZSBuYW1lIG9mIEdvb2dsZSBJ
bmMuIG5vciB0aGUgbmFtZXMgb2YgaXRzCiBjb250cmlidXRvcnMgbWF5IGJl
IHVzZWQgdG8gZW5kb3JzZSBvciBwcm9tb3RlIHByb2R1Y3RzIGRlcml2ZWQg
ZnJvbQogdGhpcyBzb2Z0d2FyZSB3aXRob3V0IHNwZWNpZmljIHByaW9yIHdy
aXR0ZW4gcGVybWlzc2lvbi4KCiBUSElTIFNPRlRXQVJFIElTIFBST1ZJREVE
IEJZIFRIRSBDT1BZUklHSFQgSE9MREVSUyBBTkQgQ09OVFJJQlVUT1JTCiAi
QVMgSVMiIEFORCBBTlkgRVhQUkVTUyBPUiBJTVBMSUVEIFdBUlJBTlRJRVMs
IElOQ0xVRElORywgQlVUIE5PVAogTElNSVRFRCBUTywgVEhFIElNUExJRUQg
V0FSUkFOVElFUyBPRiBNRVJDSEFOVEFCSUxJVFkgQU5EIEZJVE5FU1MgRk9S
CiBBIFBBUlRJQ1VMQVIgUFVSUE9TRSBBUkUgRElTQ0xBSU1FRC4gSU4gTk8g
RVZFTlQgU0hBTEwgVEhFIENPUFlSSUdIVAogT1dORVIgT1IgQ09OVFJJQlVU
T1JTIEJFIExJQUJMRSBGT1IgQU5ZIERJUkVDVCwgSU5ESVJFQ1QsIElOQ0lE
RU5UQUwsCiBTUEVDSUFMLCBFWEVNUExBUlksIE9SIENPTlNFUVVFTlRJQUwg
REFNQUdFUyAoSU5DTFVESU5HLCBCVVQgTk9UCiBMSU1JVEVEIFRPLCBQUk9D
VVJFTUVOVCBPRiBTVUJTVElUVVRFIEdPT0RTIE9SIFNFUlZJQ0VTOyBMT1NT
IE9GIFVTRSwKIERBVEEsIE9SIFBST0ZJVFM7IE9SIEJVU0lORVNTIElOVEVS
UlVQVElPTikgSE9XRVZFUiBDQVVTRUQgQU5EIE9OIEFOWQogVEhFT1JZIE9G
IExJQUJJTElUWSwgV0hFVEhFUiBJTiBDT05UUkFDVCwgU1RSSUNUIExJQUJJ
TElUWSwgT1IgVE9SVAogKElOQ0xVRElORyBORUdMSUdFTkNFIE9SIE9USEVS
V0lTRSkgQVJJU0lORyBJTiBBTlkgV0FZIE9VVCBPRiBUSEUgVVNFCiBPRiBU
SElTIFNPRlRXQVJFLCBFVkVOIElGIEFEVklTRUQgT0YgVEhFIFBPU1NJQklM
SVRZIE9GIFNVQ0ggREFNQUdFLgoyyQEgQXV0aG9yOiBrZW50b25AZ29vZ2xl
LmNvbSAoS2VudG9uIFZhcmRhKQogIEJhc2VkIG9uIG9yaWdpbmFsIFByb3Rv
Y29sIEJ1ZmZlcnMgZGVzaWduIGJ5CiAgU2FuamF5IEdoZW1hd2F0LCBKZWZm
IERlYW4sIGFuZCBvdGhlcnMuCgogQSBwcm90byBmaWxlIHdoaWNoIGlzIGlt
cG9ydGVkIGJ5IHVuaXR0ZXN0LnByb3RvIHRvIHRlc3QgaW1wb3J0aW5nLgoK
9QEKAQISAyoAIRrqASBXZSBkb24ndCBwdXQgdGhpcyBpbiBhIHBhY2thZ2Ug
d2l0aGluIHByb3RvMiBiZWNhdXNlIHdlIG5lZWQgdG8gbWFrZSBzdXJlCiB0
aGF0IHRoZSBnZW5lcmF0ZWQgY29kZSBkb2Vzbid0IGRlcGVuZCBvbiBiZWlu
ZyBpbiB0aGUgcHJvdG8yIG5hbWVzcGFjZS4KIEluIHRlc3RfdXRpbC5oIHdl
IGRvCiAidXNpbmcgbmFtZXNwYWNlIHVuaXR0ZXN0X2ltcG9ydCA9IHByb3Rv
YnVmX3VuaXR0ZXN0X2ltcG9ydCIuCgoICgEIEgMsABwKCQoCCAkSAywAHAoI
CgEIEgMtAB8KCQoCCB8SAy0AHwoICgEIEgMwADEKLgoCCAESAzAAMRojIEV4
ZXJjaXNlIHRoZSBqYXZhX3BhY2thZ2Ugb3B0aW9uLgoKcwoCAwASAzYAOxoU
IFRlc3QgcHVibGljIGltcG9ydAoyUiBEbyBub3Qgc2V0IGEgamF2YV9vdXRl
cl9jbGFzc25hbWUgaGVyZSB0byB2ZXJpZnkgdGhhdCBQcm90bzIgd29ya3Mg
d2l0aG91dAogb25lLgoKCQoCCgASAzYHDQoKCgIEABIEOAA6AQoKCgMEAAES
AzgIFQoLCgQEAAIAEgM5AhcKDAoFBAACAAQSAzkCCgoMCgUEAAIABRIDOQsQ
CgwKBQQAAgABEgM5ERIKDAoFBAACAAMSAzkVFgoKCgIFABIEPABAAQoKCgMF
AAESAzwFDwoLCgQFAAIAEgM9AhEKDAoFBQACAAESAz0CDAoMCgUFAAIAAhID
PQ8QCgsKBAUAAgESAz4CEQoMCgUFAAIBARIDPgIMCgwKBQUAAgECEgM+DxAK
CwoEBQACAhIDPwIRCgwKBQUAAgIBEgM/AgwKDAoFBQACAgISAz8PEApICgIF
ARIERABIARo8IFRvIHVzZSBhbiBlbnVtIGluIGEgbWFwLCBpdCBtdXN0IGhh
cyB0aGUgZmlyc3QgdmFsdWUgYXMgMC4KCgoKAwUBARIDRAUVCgsKBAUBAgAS
A0UCDgoMCgUFAQIAARIDRQIJCgwKBQUBAgACEgNFDA0KCwoEBQECARIDRgIK
CgwKBQUBAgEBEgNGAgUKDAoFBQECAQISA0YICQoLCgQFAQICEgNHAgoKDAoF
BQECAgESA0cCBQoMCgUFAQICAhIDRwgJUAA=
