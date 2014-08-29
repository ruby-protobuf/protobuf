##
# This file is auto-generated. DO NOT EDIT!
#
require 'protobuf/message'

module Test

  ##
  # Message Classes
  #
  class FullName < ::Protobuf::Message; end
  class OneofTest < ::Protobuf::Message; end


  ##
  # Message Fields
  #
  class FullName
    optional :string, :first_name, 1
    optional :string, :last_name, 2
  end

  class OneofTest
    set_oneof_names :SingleIdentifier
    optional ::Test::FullName, :full_name, 1, :oneof => :SingleIdentifier
    optional :string, :email, 2, :oneof => :SingleIdentifier
    optional :string, :username, 3, :oneof => :SingleIdentifier
  end

end

