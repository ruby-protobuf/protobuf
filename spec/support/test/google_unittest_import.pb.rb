# encoding: utf-8

##
# This file is auto-generated. DO NOT EDIT!
#
require 'protobuf/message'

module GoogleUnittestImport

  ##
  # Enum Classes
  #
  class ImportEnum < ::Protobuf::Enum
    define :IMPORT_FOO, 7
    define :IMPORT_BAR, 8
    define :IMPORT_BAZ, 9
  end


  ##
  # Message Classes
  #
  class PublicImportMessage < ::Protobuf::Message; end
  class ImportMessage < ::Protobuf::Message; end


  ##
  # Message Fields
  #
  class PublicImportMessage
    optional :int32, :e, 1
  end

  class ImportMessage
    optional :int32, :d, 1
  end

end

