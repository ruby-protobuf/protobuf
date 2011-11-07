require 'test/unit'
require 'test/proto/lowercase.pb'

class LowercaseTest < Test::Unit::TestCase
  def test_lowercase
    message = nil
    assert_nothing_raised { message = Test::Lowercase::Baaz.new }
    assert_nothing_raised { message.x = Test::Lowercase::Foo::Bar.new }
    assert_equal(Test::Lowercase::Foo::Bar, message.get_field_by_name(:x).type)
  end
end
