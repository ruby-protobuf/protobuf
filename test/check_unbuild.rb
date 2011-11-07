#!/usr/bin/env ruby

$:.push "#{File.dirname(__FILE__)}/../lib"

require 'test/unit'
require 'protobuf/descriptor/descriptor_builder' 
require 'protobuf/descriptor/descriptor_proto'

class DescriptorTest < Test::Unit::TestCase
  def test_unbuild
    tutorial_proto = Google::Protobuf::FileDescriptorProto.new
    tutorial_proto.parse_from_file 'person.bin'
    Protobuf::Descriptor::DescriptorBuilder.build tutorial_proto

    assert_nothing_raised {Tutorial::Person}
    assert_nothing_raised {Tutorial::Person.new}
    assert_equal(['age', 'email', 'id', 'name', 'phone'], 
      Tutorial::Person.fields.map{|tag, field| field.name}.sort)

    assert_nothing_raised {Tutorial::Person::PhoneNumber}
    assert_nothing_raised {Tutorial::Person::PhoneNumber.new}
    assert_equal(['number', 'type'], 
      Tutorial::Person::PhoneNumber.fields.map{|tag, field| field.name}.sort)

    assert_nothing_raised {Tutorial::Person::PhoneType}
    assert_equal(0, Tutorial::Person::PhoneType::MOBILE)
    assert_equal(1, Tutorial::Person::PhoneType::HOME)
    assert_equal(2, Tutorial::Person::PhoneType::WORK)
  end
end
