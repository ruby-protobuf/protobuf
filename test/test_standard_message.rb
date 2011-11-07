require 'test/unit'
require 'protobuf/message/message'
require 'protobuf/message/enum'
require 'test/proto/addressbook.pb'

class StandardMessageTest < Test::Unit::TestCase
  def test_initialized
    person = Tutorial::Person.new
    assert(!person.initialized?)
    assert_raise(Protobuf::NotInitializedError) { person.to_s }
    person.name = 'name'
    assert(!person.initialized?)
    person.id = 12
    assert( person.initialized?)

    # repeated field
    person.phone << Tutorial::Person::PhoneNumber.new
    assert(!person.initialized?)
    person.phone.last.number = '123-456'
    assert( person.initialized?)
  end

  def test_clear
    person = Tutorial::Person.new
    person.name = 'name'
    person.id = 1234
    person.email = 'abc@cde.fgh'
    person.phone << Tutorial::Person::PhoneNumber.new
    person.clear!

    assert_nil(person.name)
    assert_nil(person.id)
    assert_equal('', person.email)
    assert_equal(0, person.phone.size)

    assert(!person.has_field?(:name))
    assert(!person.has_field?(:id))
    assert(!person.has_field?(:email))
  end

  def test_dup
    person = Tutorial::Person.new
    person.name = 'name'
    person.id = 1234
    person.email = 'abc@cde.fgh'
    person.phone << Tutorial::Person::PhoneNumber.new
    person.phone.last.number = '123-456'
    person.phone.last.type = Tutorial::Person::PhoneType::MOBILE
    person.phone << Tutorial::Person::PhoneNumber.new
    person.phone.last.number = '456-123'
    person.phone.last.type = Tutorial::Person::PhoneType::WORK

    person2 = person.dup
    assert(person == person2)
    assert(!person.eql?(person2))
    assert_equal(person.name, person2.name)
    assert_equal(person.id, person2.id)
    assert_equal(person.email, person2.email)
    assert_equal(person.phone.size, person2.phone.size)
    assert(person.phone.first == person2.phone.first)
    assert(!person.phone.first.eql?(person2.phone.first))
    assert_equal(person.phone.first.number, person2.phone.first.number)
    assert_equal(person.phone.first.type, person2.phone.first.type)
    assert(person.phone.last == person2.phone.last)
    assert(!person.phone.last.eql?(person2.phone.last))
    assert_equal(person.phone.last.number, person2.phone.last.number)
    assert_equal(person.phone.last.type, person2.phone.last.type)
  end

  def test_inspect
    person = Tutorial::Person.new
    person.name = 'name'
    person.id = 1234
    person.email = 'abc@cde.fgh'
    person.phone << Tutorial::Person::PhoneNumber.new
    person.phone.last.number = '123-456'
    person.phone.last.type = Tutorial::Person::PhoneType::MOBILE
    person.phone << Tutorial::Person::PhoneNumber.new
    person.phone.last.number = '456-123'
    person.phone.last.type = Tutorial::Person::PhoneType::WORK

    assert_equal <<-EOS, person.inspect
name: "name"
id: 1234
email: "abc@cde.fgh"
phone {
  number: "123-456"
  type: MOBILE
}
phone {
  number: "456-123"
  type: WORK
}
    EOS
  end
end
