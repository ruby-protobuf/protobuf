require 'protobuf/message/message'
require 'test/proto/addressbook.pb'
require 'test/proto/merge.pb'
require 'test/unit'

# It should not conflict with Test::InnerMessage1 which is included in merge.proto
class InnerMessage1; end

class MessageTest < Test::Unit::TestCase
  def test_equality
    person1 = Tutorial::Person.new :name => 'ando'
    person2 = Tutorial::Person.new :name => 'ando'
    person3 = Tutorial::Person.new :name => 'Ando'
    assert(person1 == person2)
    assert(person1 != person3)
    assert(person1 != 'ando')
  end

  def test_bracketed_access
    person = Tutorial::Person.new
    name_tag = 1
    person[name_tag] = 'Ichiro'
    assert_equal('Ichiro', person.name)
    assert_equal('Ichiro', person[name_tag])

    person[:id] = 100
    assert_equal(100, person.id)
    person['id'] = 200
    assert_equal(200, person.id)
    assert_equal(200, person[:id])
    assert_equal(200, person['id'])
  end

  def test_initialize_with_hash
    person = Tutorial::Person.new(:name => 'Jiro', :id => 300, :email => 'jiro@ema.il')
    assert_equal('Jiro', person.name)
    assert_equal(300, person.id)
    assert_equal('jiro@ema.il', person.email)

    # initialize with array of hash
    person = Tutorial::Person.new(:phone => [{:number => 'phone1'}, {:number => 'phone2'}])
    assert_equal('phone1', person.phone[0].number)
    assert_equal('phone2', person.phone[1].number)

    # initalize with hash in hash
    message = Test::MergeMessage.new(:require_message => { :name => 'name1', :repeate_message => [{:name => 'name2'}] })
    assert_equal('name1', message.require_message.name)
    assert_equal('name2', message.require_message.repeate_message[0].name)

    message.require_message = { :name => 'name21' }
    message.require_message.repeate_message = [ {:name => 'name22'} ]
    assert_equal('name21', message.require_message.name)
    assert_equal('name22', message.require_message.repeate_message[0].name)
    assert_equal(1,        message.require_message.repeate_message.size)
  end

  def test_defined_filenames
    assert(Tutorial::Person.defined_filenames)
    assert_equal(1, Tutorial::Person.defined_filenames.size)
    assert_match(%r{/.*/proto/addressbook\.pb\.rb}, Tutorial::Person.defined_filenames.first)
  end

  def test_proto_filenames
    assert(Tutorial::Person.proto_filenames)
    assert_equal(1, Tutorial::Person.proto_filenames.size)
    assert_equal('test/proto/addressbook.proto', Tutorial::Person.proto_filenames.first)
  end

  def test_proto_contents
    assert_equal(<<-EOS.strip, Tutorial::Person.proto_contents.values.first.strip)
package tutorial;

message Person {
  required string name = 1;
  required int32 id = 2;
  optional string email = 3;

  enum PhoneType {
    MOBILE = 0;
    HOME = 1;
    WORK = 2;
  }

  message PhoneNumber {
    required string number = 1;
    optional PhoneType type = 2 [default = HOME];
  }

  repeated PhoneNumber phone = 4;
  optional uint32 age = 5 [default = 20];

  extensions 100 to 200;
}

/*
extend Person {
  optional int32 age = 100;
}
*/

message AddressBook {
  repeated Person person = 1;
}
    EOS
  end

  def test_merge_field
    inner_message1_2 = Test::MergeMessage::InnerMessage2.new(:name => 'name12')
    inner_message1_2.repeate_message << Test::MergeMessage::InnerMessage1.new(:name => 'name121')
    message1 = Test::MergeMessage.new(:name => 'name1', :require_message => inner_message1_2)
    message1.repeate_message << Test::MergeMessage::InnerMessage1.new(:name => 'name11')

    inner_message2_2 = Test::MergeMessage::InnerMessage2.new(:name => 'name22')
    inner_message2_2.repeate_message << Test::MergeMessage::InnerMessage1.new(:name => 'name221')
    message2 = Test::MergeMessage.new(:name => 'name2', :require_message => inner_message2_2)
    message2.repeate_message << Test::MergeMessage::InnerMessage1.new(:name => 'name21')

    message1.merge_from(message2)
    assert_equal('name2', message1.name)
    assert_equal(2, message1.repeate_message.size)
    assert_equal('name11', message1.repeate_message[0].name)
    assert_equal('name21', message1.repeate_message[1].name)
    assert_equal('name22', message1.require_message.name)
    assert_equal(2, message1.require_message.repeate_message.size)
    assert_equal('name121', message1.require_message.repeate_message[0].name)
    assert_equal('name221', message1.require_message.repeate_message[1].name)
  end
end
