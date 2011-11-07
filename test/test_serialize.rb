# encoding: utf-8
require 'test/unit'
require 'test/proto/addressbook.pb'

class SerializeTest < Test::Unit::TestCase
  def test_serialize
    # serialize to string
    person = Tutorial::Person.new
    person.id = 1234
    person.name = 'John Doe'
    person.email = 'jdoe@example.com'
    phone = Tutorial::Person::PhoneNumber.new
    phone.number = '555-4321'
    phone.type = Tutorial::Person::PhoneType::HOME
    person.phone << phone
    serialized_string = person.serialize_to_string

    # parse the serialized string
    person2 = Tutorial::Person.new
    person2.parse_from_string(serialized_string)
    assert_equal(1234, person2.id)
    assert_equal('John Doe', person2.name)
    assert_equal('jdoe@example.com', person2.email)
    assert_equal(1, person2.phone.size)
    assert_equal('555-4321', person2.phone[0].number)
    assert_equal(Tutorial::Person::PhoneType::HOME, person2.phone[0].type)
  end

  def test_serialize_utf8string
    # serialize to string
    person = Tutorial::Person.new
    person.id = 1234
    person.name = '山田 太郎' # kanji characters
    serialized_string = person.serialize_to_string

    # parse the serialized string
    person2 = Tutorial::Person.new
    person2.parse_from_string(serialized_string)
    assert_equal(1234, person2.id)
    assert_equal('山田 太郎', person2.name)
  end

  def test_unknown_field
    person = Tutorial::Person.new
    person.id = 1234
    person.name = 'a b c'
    serialized_string = person.serialize_to_string

    # add invalid field
    tag = 1000
    wire_type = Protobuf::WireType::VARINT
    serialized_string << Protobuf::Field::VarintField.encode((tag << 3) | wire_type)
    serialized_string << Protobuf::Field::VarintField.encode(100)

    # decode
    person2 = Tutorial::Person.new
    person2.parse_from_string(serialized_string)

    assert_equal(person, person2)
  end
end
