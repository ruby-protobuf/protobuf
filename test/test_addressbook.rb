require 'test/unit'
require 'protobuf/message/message'
require 'protobuf/message/enum'
require 'test/proto/addressbook.pb'

class AddressbookTest < Test::Unit::TestCase
  def test_enum
    phone_number = Tutorial::Person::PhoneNumber.new
    assert_equal(Tutorial::Person::PhoneType::HOME, phone_number.type)
    phone_number.type = Tutorial::Person::PhoneType::MOBILE
    assert_equal(0, phone_number.type)
    phone_number.type = Tutorial::Person::PhoneType::HOME
    assert_equal(1, phone_number.type)
    phone_number.type = Tutorial::Person::PhoneType::WORK
    assert_equal(2, phone_number.type)
    assert_raise(TypeError) do
      phone_number.type = 3
    end
  end

  def test_symbol_enum
    phone_number = Tutorial::Person::PhoneNumber.new
    assert_equal(Tutorial::Person::PhoneType::HOME, phone_number.type)
    phone_number.type = :MOBILE
    assert_equal(0, phone_number.type)
    phone_number.type = :HOME
    assert_equal(1, phone_number.type)
    phone_number.type = :WORK
    assert_equal(2, phone_number.type)
    assert_raise(TypeError) do
      phone_number.type = :UNKNOWN
    end
  end

  def test_initial_value
    person = Tutorial::Person.new
    assert_nil(person.name)
    assert_nil(person.id)
    assert_equal([], person.phone)
    assert_equal('', person.email)
  end

  def test_repeatable
    address_book = Tutorial::AddressBook.new
    assert_equal([], address_book.person)
    assert_instance_of(Protobuf::Field::FieldArray, address_book.person)
    address_book.person << Tutorial::Person.new
    assert_equal(1, address_book.person.size)
    assert_raise(TypeError) do
      address_book.person << 1
    end
    assert_equal(1, address_book.person.size)
    address_book.person << Tutorial::Person.new
    assert_equal(2, address_book.person.size)
  end
end
