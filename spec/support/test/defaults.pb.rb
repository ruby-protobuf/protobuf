##
# This file is auto-generated. DO NOT EDIT!
#
require 'protobuf/message'

module Test

  ##
  # Message Classes
  #
  class Defaults < ::Protobuf::Message; end


  ##
  # Message Fields
  #
  class Defaults
    optional ::Protobuf::Field::BytesField, :escaped_bytes, 1, :default => "\000\001\007\010\014\n\r\t\013\\\\'\"\376"
    optional ::Protobuf::Field::DoubleField, :infinity_default, 2, :default => ::Float::INFINITY
    optional ::Protobuf::Field::FloatField, :neg_infinity_default, 3, :default => -::Float::INFINITY
    optional ::Protobuf::Field::DoubleField, :nan_default, 4, :default => ::Float::NAN
  end

end

