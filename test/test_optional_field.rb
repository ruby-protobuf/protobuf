require 'test/unit'
require 'test/proto/optional_field.pb'

class OptionalFieldTest < Test::Unit::TestCase
  def test_accessor
    message = Test::OptionalField::Message.new

    # default values
    assert(!message.has_field?(:number))
    assert_equal(20, message.number)

    assert(!message.has_field?(:text))
    assert_equal('default string', message.text)

    assert(!message.has_field?(:enum))
    assert_equal(2, message.enum)

    assert(!message.has_field?(:signed))
    assert_equal(-100, message.signed)

    # assign values
    assert_nothing_raised { message.number = 100 }
    assert(message.has_field?(:number))
    assert_equal(100, message.number)

    assert_nothing_raised { message.text = 'abc' }
    assert(message.has_field?(:text))
    assert_equal('abc', message.text)

    assert_nothing_raised { message.enum = Test::OptionalField::Message::Enum::A }
    assert(message.has_field?(:enum))
    assert_equal(1, message.enum)

    assert_nothing_raised { message.signed = -20 }
    assert(message.has_field?(:signed))
    assert_equal(-20, message.signed)
  end

  def test_serialize
    message1 = Test::OptionalField::Message.new
    message2 = Test::OptionalField::Message.new

    # all fields are empty
    serialized_string = message1.to_s
    assert(serialized_string.empty?)
    message2.parse_from_string(serialized_string)
    assert_equal(message1.number, message2.number)
    assert_equal(message1.text,   message2.text)
    assert_equal(message1.enum,   message2.enum)
    assert_equal(message1.signed, message2.signed)
    assert(!message2.has_field?(:number))
    assert(!message2.has_field?(:text))
    assert(!message2.has_field?(:enum))
    assert(!message2.has_field?(:signed))

    # assign the value whith is equal to default value
    message1 = Test::OptionalField::Message.new
    message1.number = message1.number
    message1.text   = message1.text
    message1.enum   = message1.enum
    message1.signed = message1.signed
    serialized_string = message1.to_s
    assert !serialized_string.empty?

    # set some fields
    message1 = Test::OptionalField::Message.new
    message1.number = 100
    message1.text   = 'new text'
    serialized_string = message1.to_s
    message2.parse_from_string(serialized_string)
    assert_equal(message1.number, message2.number)
    assert_equal(message1.text,   message2.text)
    assert_equal(message1.enum,   message2.enum)
    assert_equal(message1.signed, message2.signed)
    assert( message2.has_field?(:number))
    assert( message2.has_field?(:text))
    assert(!message2.has_field?(:enum))
    assert(!message2.has_field?(:signed))
  end

  def test_merge_optional_fields
    src1 = Test::OptionalField::Message.new
    src2 = Test::OptionalField::Message.new
    dst  = Test::OptionalField::Message.new

    src1.number = 100
    src1.text   = 'old'
    src2.text   = 'new'
    src2.signed = 20

    serialized_string = src1.to_s + src2.to_s
    dst.parse_from_string(serialized_string)

    assert_equal(100,   dst.number)
    assert_equal('new', dst.text)
    assert_equal(20,    dst.signed)
    assert  dst.has_field?(:number)
    assert  dst.has_field?(:text)
    assert !dst.has_field?(:enum)
    assert  dst.has_field?(:signed)
  end

end
