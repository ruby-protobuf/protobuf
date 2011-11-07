require 'test/unit'
require 'test/proto/addressbook_ext.pb'

class ExtensionTest < Test::Unit::TestCase
  def test_accessor
    assert(TutorialExt::Person.extension_fields.to_a.map{|t, f| f.name}.include?(:age))
    person = TutorialExt::Person.new
    assert_nothing_raised {person.age = 100}
    assert_equal(100, person.age)
  end

  def test_serialize
    # serialize to string
    person = TutorialExt::Person.new
    person.id = 1234
    person.age = 70
    person.name = 'John Doe'
    person.email = 'jdoe@example.com'
    phone = TutorialExt::Person::PhoneNumber.new
    phone.number = '555-4321'
    phone.type = TutorialExt::Person::PhoneType::HOME
    person.phone << phone
    serialized_string = person.serialize_to_string

    # parse the serialized string
    person2 = TutorialExt::Person.new
    person2.parse_from_string serialized_string
    assert_equal(1234, person2.id)
    assert_equal(70, person2.age)
    assert_equal('John Doe', person2.name)
    assert_equal('jdoe@example.com', person2.email)
    assert_equal(1, person2.phone.size)
    assert_equal('555-4321', person2.phone[0].number)
    assert_equal(TutorialExt::Person::PhoneType::HOME, person2.phone[0].type)
  end
end
