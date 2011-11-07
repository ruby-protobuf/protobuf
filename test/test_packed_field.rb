require 'test/unit'
require 'test/proto/packed.pb'

class PackedFieldTest < Test::Unit::TestCase

  def test_packed_field
    values = [1, 1_000, 10_000, 1_000_000, 1_000_000_000]

    # encode
    message = Test::PackedField::Message.new
    message.a = values
    message.b = values

    expected = ''
    serialized_string = nil
    assert_nothing_raised { serialized_string = message.serialize_to_string }

    value = values.map {|v| Protobuf::Field::VarintField.encode(v) }.join
    expected << Protobuf::Field::VarintField.encode((1 << 3) | 2)  # tag=1, wire_type=2 (length-delimited)
    expected << Protobuf::Field::VarintField.encode(value.size)
    expected << value

    value = values.pack('V*')
    expected << Protobuf::Field::VarintField.encode((2 << 3) | 2)  # tag=2, wire_type=2 (length-delimited)
    expected << Protobuf::Field::VarintField.encode(value.size)
    expected << value

    assert_equal(expected, serialized_string)

    # decode
    message2 = Test::PackedField::Message.new
    assert_nothing_raised { message2.parse_from_string(serialized_string) }

    values.each_with_index do |val, n|
      assert_equal(val, message.a[n])
      assert_equal(val, message.b[n])
    end
  end

end
