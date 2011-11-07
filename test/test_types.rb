require 'test/unit'
require 'test/proto/types.pb'

class TypesTest < Test::Unit::TestCase
  def test_serialize
    types = Test::Types::TestTypes.new
    types.type1 = 0.01
    types.type2 = 0.1
    types.type3 = 1
    types.type4 = 10
    types.type5 = 100
    types.type6 = 1000
    types.type7 = -1
    types.type8 = -10
    types.type9 = 10000
    types.type10 = 100000
    types.type11 = false
    types.type12 = 'hello all types'
    image_bin = File.open('test/data/unk.png', 'r+b'){|f| f.read}
    types.type13 = image_bin
    types.type14 = -100
    types.type15 = -1000

    serialized_string = types.serialize_to_string

    types2 = Test::Types::TestTypes.new
    types2.parse_from_string(serialized_string)
    assert_in_delta(0.01, types2.type1, 0.00001)
    assert_in_delta(0.1, types2.type2, 0.00001)
    assert_equal(1, types2.type3)
    assert_equal(10, types2.type4)
    assert_equal(100, types2.type5)
    assert_equal(1000, types2.type6)
    assert_equal(-1, types2.type7)
    assert_equal(-10, types2.type8)
    assert_equal(10000, types2.type9)
    assert_equal(100000, types2.type10)
    assert(!types2.type11)
    assert_equal('hello all types', types2.type12)
    assert_equal(10938, types2.type13.size)
    assert_equal(image_bin, types2.type13)
    assert_equal(-100, types2.type14)
    assert_equal(-1000, types2.type15)
  end

  def test_serialize2
    types = Test::Types::TestTypes.new
    types.type1 = 1.0/0   # double (Inf)
    types.type2 = -1.0/0  # float (-Inf)
    types.type3 = -1      # int32
    types.type4 = -10     # int64
    types.type5 = 100     # uint32
    types.type6 = 1000    # uint64
    types.type7 = -1000   # sint32
    types.type8 = -10000  # sint64
    types.type9 = 10000   # fixed32
    types.type10 = 100000 # fixed64
    types.type11 = true
    types.type12 = 'hello all types'
    image_bin = File.open('test/data/unk.png', 'r+b'){|f| f.read}
    types.type13 = image_bin
    types.type14 = -2_000_000_000  # sfixed32
    types.type15 = -8_000_000_000_000_000_000  # sfixed64

    serialized_string = types.serialize_to_string

    types2 = Test::Types::TestTypes.new
    types2.parse_from_string(serialized_string)
    assert_equal(1.0/0.0, types2.type1)
    assert_equal(-1.0/0.0, types2.type2)
    assert_equal(-1, types2.type3)
    assert_equal(-10, types2.type4)
    assert_equal(100, types2.type5)
    assert_equal(1000, types2.type6)
    assert_equal(-1000, types2.type7)
    assert_equal(-10000, types2.type8)
    assert_equal(10000, types2.type9)
    assert_equal(100000, types2.type10)
    assert(types2.type11)
    assert_equal('hello all types', types2.type12)
    assert_equal(10938, types2.type13.size)
    assert_equal(image_bin, types2.type13)
    assert_equal(-2_000_000_000, types2.type14)
    assert_equal(-8_000_000_000_000_000_000, types2.type15)
  end

  def test_parse
    types = Test::Types::TestTypes.new
    types.parse_from_file('test/data/types.bin')
    assert_in_delta(0.01, types.type1, 0.00001)
    assert_in_delta(0.1, types.type2, 0.00001)
    assert_equal(1, types.type3)
    assert_equal(10, types.type4)
    assert_equal(100, types.type5)
    assert_equal(1000, types.type6)
    assert_equal(-1, types.type7)
    assert_equal(-10, types.type8)
    assert_equal(10000, types.type9)
    assert_equal(100000, types.type10)
    assert_equal(false, !!types.type11)
    assert_equal('hello all types', types.type12)
    assert_equal(File.open('test/data/unk.png', 'r+b'){|f| f.read}, types.type13)
  end

  def test_double
    # double fixed 64-bit
    types = Test::Types::TestTypes.new
    assert_nothing_raised { types.type1 = 1 }
    assert_nothing_raised { types.type1 = 1.0 }
    assert_raise(TypeError) { types.type1 = '' }
    assert_nothing_raised { types.type1 = Protobuf::Field::DoubleField.max }
    assert_nothing_raised { types.type1 = Protobuf::Field::DoubleField.min }
  end

  def test_float
    # float fixed 32-bit
    types = Test::Types::TestTypes.new
    assert_nothing_raised { types.type2 = 1 }
    assert_nothing_raised { types.type2 = 1.0 }
    assert_raise(TypeError) { types.type2 = '' }
    assert_nothing_raised { types.type2 = Protobuf::Field::FloatField.max }
    assert_nothing_raised { types.type2 = Protobuf::Field::FloatField.min }
  end

  def test_int32
    types = Test::Types::TestTypes.new
    assert_nothing_raised { types.type3 = 1 }
    assert_nothing_raised { types.type3 = -1 }
    assert_raise(TypeError) { types.type3 = 1.0 }
    assert_raise(TypeError) { types.type3 = '' }
  end

  def test_int64
    types = Test::Types::TestTypes.new
    assert_nothing_raised { types.type4 = 1 }
    assert_nothing_raised { types.type4 = -1 }
    assert_raise(TypeError) { types.type4 = 1.0 }
    assert_raise(TypeError) { types.type4 = '' }
  end

  def test_uint32
    types = Test::Types::TestTypes.new
    assert_nothing_raised { types.type5 = 1 }
    assert_raise(RangeError) { types.type5 = -1 }
    assert_raise(TypeError) { types.type5 = 1.0 }
    assert_raise(TypeError) { types.type5 = '' }
  end

  def test_uint64
    types = Test::Types::TestTypes.new
    assert_nothing_raised { types.type6 = 1 }
    assert_raise(RangeError) { types.type6 = -1 }
    assert_raise(TypeError) { types.type6 = 1.0 }
    assert_raise(TypeError) { types.type6 = '' }
  end

  def test_sint32
    types = Test::Types::TestTypes.new
    assert_nothing_raised { types.type7 = 1 }
    assert_nothing_raised { types.type7 = -1 }
    assert_raise(TypeError) { types.type7 = 1.0 }
    assert_raise(TypeError) { types.type7 = '' }
  end

  def test_sint64
    types = Test::Types::TestTypes.new
    assert_nothing_raised { types.type8 = 1 }
    assert_nothing_raised { types.type8 = -1 }
    assert_raise(TypeError) { types.type8 = 1.0 }
    assert_raise(TypeError) { types.type8 = '' }
  end

  def test_fixed32
    types = Test::Types::TestTypes.new
    assert_nothing_raised { types.type9 = 1 }
    assert_raise(TypeError) { types.type9 = 1.0 }
    assert_raise(TypeError) { types.type9 = '' }
    assert_nothing_raised { types.type9 = Protobuf::Field::Fixed32Field.max }
    assert_raise(RangeError) { types.type9 = Protobuf::Field::Fixed32Field.max + 1 }
    assert_nothing_raised { types.type9 = Protobuf::Field::Fixed32Field.min }
    assert_raise(RangeError) { types.type9 = Protobuf::Field::Fixed32Field.min - 1 }
  end

  def test_fixed64
    types = Test::Types::TestTypes.new
    assert_nothing_raised { types.type10 = 1 }
    assert_raise(TypeError) { types.type10 = 1.0 }
    assert_raise(TypeError) { types.type10 = '' }
    assert_nothing_raised { types.type10 = Protobuf::Field::Fixed64Field.max }
    assert_raise(RangeError) { types.type10 = Protobuf::Field::Fixed64Field.max + 1 }
    assert_nothing_raised { types.type10 = Protobuf::Field::Fixed64Field.min }
    assert_raise(RangeError) { types.type10 = Protobuf::Field::Fixed64Field.min - 1 }
  end

  def test_bool
    types = Test::Types::TestTypes.new
    assert_nothing_raised { types.type11 = true }
    assert_nothing_raised { types.type11 = false }
    assert_nothing_raised { types.type11 = nil }
    assert_raise(TypeError) { types.type11 = 0 }
    assert_raise(TypeError) { types.type11 = '' }
  end

  def test_string
    types = Test::Types::TestTypes.new
    assert_nothing_raised { types.type12 = '' }
    assert_nothing_raised { types.type12 = 'hello' }
    assert_nothing_raised { types.type12 = nil }
    assert_raise(TypeError) { types.type12 = 0 }
    assert_raise(TypeError) { types.type12 = true }
  end

  def test_bytes
    types = Test::Types::TestTypes.new
    assert_nothing_raised { types.type13 = '' }
    assert_nothing_raised { types.type13 = 'hello' }
    assert_nothing_raised { types.type13 = nil }
    assert_raise(TypeError) { types.type13 = 0 }
    assert_raise(TypeError) { types.type13 = true }
    assert_raise(TypeError) { types.type13 = [] }
  end

  def test_varint_getbytes
    assert_equal("\xac\x02", Protobuf::Field::VarintField.encode(300))
  end
end
