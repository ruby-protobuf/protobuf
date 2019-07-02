# encoding: utf-8
# frozen_string_literal: true

##
# This file is auto-generated. DO NOT EDIT!
#
require 'base64'
require 'set'
require 'protobuf'

module Test
  FULLY_QUALIFIED_NAME = 'test' unless defined?(self::FULLY_QUALIFIED_NAME)

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
  class Header < ::Protobuf::Message
    class Type < ::Protobuf::Enum
      FULLY_QUALIFIED_NAME = FULLY_QUALIFIED_NAME + '.Type'

      define :PayloadTypeA, 1
      define :PayloadTypeB, 2
    end

  end

  class PayloadA < ::Protobuf::Message
    class Foo < ::Protobuf::Message; end

  end

  class PayloadB < ::Protobuf::Message
    class Foo < ::Protobuf::Message; end

  end



  ##
  # Message Fields
  #
  class Header
    FULLY_QUALIFIED_NAME = FULLY_QUALIFIED_NAME + '.Header'
    required ::Test::Header::Type, :type, 1
    # Extension Fields
    extensions 100...536870912
    optional ::Test::PayloadA, :".test.PayloadA.payload", 100, :extension => true
  end

  class PayloadA
    FULLY_QUALIFIED_NAME = FULLY_QUALIFIED_NAME + '.PayloadA'
    class Foo
      FULLY_QUALIFIED_NAME = FULLY_QUALIFIED_NAME + '.Foo'
      optional :string, :foo_a, 1
    end

  end

  class PayloadB
    FULLY_QUALIFIED_NAME = FULLY_QUALIFIED_NAME + '.PayloadB'
    class Foo
      FULLY_QUALIFIED_NAME = FULLY_QUALIFIED_NAME + '.Foo'
      optional :string, :foo_b, 1
    end

  end

end


# Raw descriptor bytes below
__END__
CiNwcm90b3MvbXVsdGlfZmllbGRfZXh0ZW5zaW9ucy5wcm90bxIEdGVzdCJl
CgZIZWFkZXISJQoEdHlwZRgBIAIoDjIRLnRlc3QuSGVhZGVyLlR5cGVSBHR5
cGUiKgoEVHlwZRIQCgxQYXlsb2FkVHlwZUEQARIQCgxQYXlsb2FkVHlwZUIQ
AioICGQQgICAgAIibQoIUGF5bG9hZEEaGgoDRm9vEhMKBWZvb19hGAEgASgJ
UgRmb29BMkUKFi50ZXN0LlBheWxvYWRBLnBheWxvYWQSDC50ZXN0LkhlYWRl
chhkIAEoCzIOLnRlc3QuUGF5bG9hZEFSB3BheWxvYWQiJgoIUGF5bG9hZEIa
GgoDRm9vEhMKBWZvb19iGAEgASgJUgRmb29CSo4FCgYSBAAAIgEKCAoBDBID
AAASCggKAQISAwIADQoKCgIEABIEBAANAQoKCgMEAAESAwQIDgoKCgMEAAUS
AwUCGAoLCgQEAAUAEgMFDRcKDAoFBAAFAAESAwUNEAoMCgUEAAUAAhIDBRQX
CgwKBAQABAASBAcCCgMKDAoFBAAEAAESAwcHCwoNCgYEAAQAAgASAwgEFQoO
CgcEAAQAAgABEgMIBBAKDgoHBAAEAAIAAhIDCBMUCg0KBgQABAACARIDCQQV
Cg4KBwQABAACAQESAwkEEAoOCgcEAAQAAgECEgMJExQKCwoEBAACABIDDAIZ
CgwKBQQAAgAEEgMMAgoKDAoFBAACAAYSAwwLDwoMCgUEAAIAARIDDBAUCgwK
BQQAAgADEgMMFxgKCgoCBAESBA8AFwEKCgoDBAEBEgMPCBAKDAoEBAEDABIE
EAISAwoMCgUEAQMAARIDEAoNCg0KBgQBAwACABIDEQQeCg4KBwQBAwACAAQS
AxEEDAoOCgcEAQMAAgAFEgMRDRMKDgoHBAEDAAIAARIDERQZCg4KBwQBAwAC
AAMSAxEcHQoLCgMEAQYSBBQCFgMKCwoEBAEGABIDFQQkCgwKBQQBBgACEgMU
CQ8KDAoFBAEGAAQSAxUEDAoMCgUEAQYABhIDFQ0VCgwKBQQBBgABEgMVFh0K
DAoFBAEGAAMSAxUgIwoKCgIEAhIEGQAiAQoKCgMEAgESAxkIEAoMCgQEAgMA
EgQaAhwDCgwKBQQCAwABEgMaCg0KDQoGBAIDAAIAEgMbBB4KDgoHBAIDAAIA
BBIDGwQMCg4KBwQCAwACAAUSAxsNEwoOCgcEAgMAAgABEgMbFBkKDgoHBAID
AAIAAxIDGxwd
