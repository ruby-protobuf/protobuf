require 'test/unit'
require 'protobuf/message/message'
require 'protobuf/message/enum'
require 'test/proto/addressbook.pb'
require 'test/proto/addressbook_base.pb'

class EnumValueTest < Test::Unit::TestCase
  def test_enum_value
    e = Protobuf::EnumValue.new(Object, :name, 100)
    assert_kind_of(Protobuf::EnumValue, e)
    assert_equal(:name, e.name)
    assert_equal(100, e.value)
    assert_equal('name', e.to_s)
    assert_equal('name', "#{e}")
    assert(e == 100)
    assert(100 == e)
    assert(101, e + 1)
    assert(101, 1 + e)
  end

  def test_enum_field_and_enum_value
    phone_number = Tutorial::Person::PhoneNumber.new

    assert_kind_of(Protobuf::EnumValue, phone_number.type)
    assert_equal(Tutorial::Person::PhoneType::HOME, phone_number.type)

    phone_number.type = 1
    assert_kind_of(Protobuf::EnumValue, phone_number.type)
    assert_equal(Tutorial::Person::PhoneType::HOME, phone_number.type)
    assert_equal(1, phone_number.type)

    phone_number.type = :HOME
    assert_kind_of(Protobuf::EnumValue, phone_number.type)
    assert_equal(Tutorial::Person::PhoneType::HOME, phone_number.type)
    assert_equal(1, phone_number.type)

    assert_raise(TypeError) do
      phone_number.type = TutorialExt::Person::PhoneType::HOME
    end
  end
end
