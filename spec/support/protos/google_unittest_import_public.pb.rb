# encoding: utf-8
# frozen_string_literal: true

##
# This file is auto-generated. DO NOT EDIT!
#
require 'base64'
require 'set'
require 'protobuf'

module Protobuf_unittest_import
  FULLY_QUALIFIED_NAME = 'protobuf_unittest_import' unless defined?(self::FULLY_QUALIFIED_NAME)

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
  # Message Classes
  #
  class PublicImportMessage < ::Protobuf::Message; end


  ##
  # File Options
  #
  set_option :java_package, "com.google.protobuf.test"


  ##
  # Message Fields
  #
  class PublicImportMessage
    FULLY_QUALIFIED_NAME = FULLY_QUALIFIED_NAME + '.PublicImportMessage'
    optional :int32, :e, 1
  end

end


# Raw descriptor bytes below
__END__
Cipwcm90b3MvZ29vZ2xlX3VuaXR0ZXN0X2ltcG9ydF9wdWJsaWMucHJvdG8S
GHByb3RvYnVmX3VuaXR0ZXN0X2ltcG9ydCIjChNQdWJsaWNJbXBvcnRNZXNz
YWdlEgwKAWUYASABKAVSAWVCGgoYY29tLmdvb2dsZS5wcm90b2J1Zi50ZXN0
Sv0NCgYSBCAAKAEK9gwKAQwSAyAAEjLBDCBQcm90b2NvbCBCdWZmZXJzIC0g
R29vZ2xlJ3MgZGF0YSBpbnRlcmNoYW5nZSBmb3JtYXQKIENvcHlyaWdodCAy
MDA4IEdvb2dsZSBJbmMuICBBbGwgcmlnaHRzIHJlc2VydmVkLgogaHR0cHM6
Ly9kZXZlbG9wZXJzLmdvb2dsZS5jb20vcHJvdG9jb2wtYnVmZmVycy8KCiBS
ZWRpc3RyaWJ1dGlvbiBhbmQgdXNlIGluIHNvdXJjZSBhbmQgYmluYXJ5IGZv
cm1zLCB3aXRoIG9yIHdpdGhvdXQKIG1vZGlmaWNhdGlvbiwgYXJlIHBlcm1p
dHRlZCBwcm92aWRlZCB0aGF0IHRoZSBmb2xsb3dpbmcgY29uZGl0aW9ucyBh
cmUKIG1ldDoKCiAgICAgKiBSZWRpc3RyaWJ1dGlvbnMgb2Ygc291cmNlIGNv
ZGUgbXVzdCByZXRhaW4gdGhlIGFib3ZlIGNvcHlyaWdodAogbm90aWNlLCB0
aGlzIGxpc3Qgb2YgY29uZGl0aW9ucyBhbmQgdGhlIGZvbGxvd2luZyBkaXNj
bGFpbWVyLgogICAgICogUmVkaXN0cmlidXRpb25zIGluIGJpbmFyeSBmb3Jt
IG11c3QgcmVwcm9kdWNlIHRoZSBhYm92ZQogY29weXJpZ2h0IG5vdGljZSwg
dGhpcyBsaXN0IG9mIGNvbmRpdGlvbnMgYW5kIHRoZSBmb2xsb3dpbmcgZGlz
Y2xhaW1lcgogaW4gdGhlIGRvY3VtZW50YXRpb24gYW5kL29yIG90aGVyIG1h
dGVyaWFscyBwcm92aWRlZCB3aXRoIHRoZQogZGlzdHJpYnV0aW9uLgogICAg
ICogTmVpdGhlciB0aGUgbmFtZSBvZiBHb29nbGUgSW5jLiBub3IgdGhlIG5h
bWVzIG9mIGl0cwogY29udHJpYnV0b3JzIG1heSBiZSB1c2VkIHRvIGVuZG9y
c2Ugb3IgcHJvbW90ZSBwcm9kdWN0cyBkZXJpdmVkIGZyb20KIHRoaXMgc29m
dHdhcmUgd2l0aG91dCBzcGVjaWZpYyBwcmlvciB3cml0dGVuIHBlcm1pc3Np
b24uCgogVEhJUyBTT0ZUV0FSRSBJUyBQUk9WSURFRCBCWSBUSEUgQ09QWVJJ
R0hUIEhPTERFUlMgQU5EIENPTlRSSUJVVE9SUwogIkFTIElTIiBBTkQgQU5Z
IEVYUFJFU1MgT1IgSU1QTElFRCBXQVJSQU5USUVTLCBJTkNMVURJTkcsIEJV
VCBOT1QKIExJTUlURUQgVE8sIFRIRSBJTVBMSUVEIFdBUlJBTlRJRVMgT0Yg
TUVSQ0hBTlRBQklMSVRZIEFORCBGSVRORVNTIEZPUgogQSBQQVJUSUNVTEFS
IFBVUlBPU0UgQVJFIERJU0NMQUlNRUQuIElOIE5PIEVWRU5UIFNIQUxMIFRI
RSBDT1BZUklHSFQKIE9XTkVSIE9SIENPTlRSSUJVVE9SUyBCRSBMSUFCTEUg
Rk9SIEFOWSBESVJFQ1QsIElORElSRUNULCBJTkNJREVOVEFMLAogU1BFQ0lB
TCwgRVhFTVBMQVJZLCBPUiBDT05TRVFVRU5USUFMIERBTUFHRVMgKElOQ0xV
RElORywgQlVUIE5PVAogTElNSVRFRCBUTywgUFJPQ1VSRU1FTlQgT0YgU1VC
U1RJVFVURSBHT09EUyBPUiBTRVJWSUNFUzsgTE9TUyBPRiBVU0UsCiBEQVRB
LCBPUiBQUk9GSVRTOyBPUiBCVVNJTkVTUyBJTlRFUlJVUFRJT04pIEhPV0VW
RVIgQ0FVU0VEIEFORCBPTiBBTlkKIFRIRU9SWSBPRiBMSUFCSUxJVFksIFdI
RVRIRVIgSU4gQ09OVFJBQ1QsIFNUUklDVCBMSUFCSUxJVFksIE9SIFRPUlQK
IChJTkNMVURJTkcgTkVHTElHRU5DRSBPUiBPVEhFUldJU0UpIEFSSVNJTkcg
SU4gQU5ZIFdBWSBPVVQgT0YgVEhFIFVTRQogT0YgVEhJUyBTT0ZUV0FSRSwg
RVZFTiBJRiBBRFZJU0VEIE9GIFRIRSBQT1NTSUJJTElUWSBPRiBTVUNIIERB
TUFHRS4KMiggQXV0aG9yOiBsaXVqaXNpQGdvb2dsZS5jb20gKFBoZXJsIExp
dSkKCggKAQISAyIAIQoICgEIEgMkADEKCQoCCAESAyQAMQoKCgIEABIEJgAo
AQoKCgMEAAESAyYIGwoLCgQEAAIAEgMnAhcKDAoFBAACAAQSAycCCgoMCgUE
AAIABRIDJwsQCgwKBQQAAgABEgMnERIKDAoFBAACAAMSAycVFg==
