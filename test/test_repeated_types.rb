require 'test/unit'
require 'test/proto/types.pb'

class RepeatedTypesTest < Test::Unit::TestCase
  def test_serialize
    # empty set
    types = Test::Types::RepeatedTypes.new
    assert_equal('', types.to_s)

    # has 1 member
    types = Test::Types::RepeatedTypes.new
    types.type1 << 0.01
    types.type2 << 0.1
    types.type3 << 1
    types.type4 << 10
    types.type5 << 100
    types.type6 << 1000
    types.type7 << -1
    types.type8 << -10
    types.type9 << 10000
    types.type10 << 100000
    types.type11 << false
    types.type12 << 'hello all types'
    image_bin = File.open('test/data/unk.png', 'r+b'){|f| f.read}
    types.type13 << image_bin
    types.type14 << -100
    types.type15 << -1000

    serialized_string = types.serialize_to_string

    types2 = Test::Types::RepeatedTypes.new
    types2.parse_from_string serialized_string
    assert_in_delta(0.01, types2.type1[0], 0.00001)
    assert_in_delta(0.1, types2.type2[0], 0.00001)
    assert_equal(1, types2.type3[0])
    assert_equal(10, types2.type4[0])
    assert_equal(100, types2.type5[0])
    assert_equal(1000, types2.type6[0])
    assert_equal(-1, types2.type7[0])
    assert_equal(-10, types2.type8[0])
    assert_equal(10000, types2.type9[0])
    assert_equal(100000, types2.type10[0])
    assert(!types2.type11[0])
    assert_equal('hello all types', types2.type12[0])
    assert_equal(10938, types2.type13[0].size)
    assert_equal(image_bin, types2.type13[0])
    assert_equal(-100, types2.type14[0])
    assert_equal(-1000, types2.type15[0])

    # has 2 members
    types.type1 << 1.0/0   # double (Inf)
    types.type2 << -1.0/0  # float (-Inf)
    types.type3 << -1      # int32
    types.type4 << -10     # int64
    types.type5 << 100     # uint32
    types.type6 << 1000    # uint64
    types.type7 << -1000   # sint32
    types.type8 << -10000  # sint64
    types.type9 << 10000   # fixed32
    types.type10 << 100000 # fixed64
    types.type11 << true
    types.type12 << 'hello all types'
    image_bin = File.open('test/data/unk.png', 'r+b'){|f| f.read}
    types.type13 << image_bin
    types.type14 << -2_000_000_000  # sfixed32
    types.type15 << -8_000_000_000_000_000_000  # sfixed64

    serialized_string = types.serialize_to_string

    types2 = Test::Types::RepeatedTypes.new
    types2.parse_from_string serialized_string
    assert_in_delta(0.01, types2.type1[0], 0.00001)
    assert_in_delta(0.1, types2.type2[0], 0.00001)
    assert_equal(1, types2.type3[0])
    assert_equal(10, types2.type4[0])
    assert_equal(100, types2.type5[0])
    assert_equal(1000, types2.type6[0])
    assert_equal(-1, types2.type7[0])
    assert_equal(-10, types2.type8[0])
    assert_equal(10000, types2.type9[0])
    assert_equal(100000, types2.type10[0])
    assert(!types2.type11[0])
    assert_equal('hello all types', types2.type12[0])
    assert_equal(10938, types2.type13[0].size)
    assert_equal(image_bin, types2.type13[0])
    assert_equal(-100, types2.type14[0])
    assert_equal(-1000, types2.type15[0])

    assert_equal(1.0/0.0, types2.type1[1])
    assert_equal(-1.0/0.0, types2.type2[1])
    assert_equal(-1, types2.type3[1])
    assert_equal(-10, types2.type4[1])
    assert_equal(100, types2.type5[1])
    assert_equal(1000, types2.type6[1])
    assert_equal(-1000, types2.type7[1])
    assert_equal(-10000, types2.type8[1])
    assert_equal(10000, types2.type9[1])
    assert_equal(100000, types2.type10[1])
    assert types2.type11[1]
    assert_equal('hello all types', types2.type12[1])
    assert_equal(10938, types2.type13[1].size)
    assert_equal(image_bin, types2.type13[1])
    assert_equal(-2_000_000_000, types2.type14[1])
    assert_equal(-8_000_000_000_000_000_000, types2.type15[1])
  end

  def test_repeated_types
    types = Test::Types::RepeatedTypes.new
    # types.type3 is a repeated int32 field.
    assert(types.type3.empty?)
    types.type3 << 0
    types.type3 << 1
    assert_equal(0, types.type3[0])
    assert_equal(1, types.type3[1])
    assert_equal(2, types.type3.size)

    assert_raise(TypeError) do
      types.type3 << 'string'
    end
    
    types.type3[1] = 10
    assert_equal(0, types.type3[0])
    assert_equal(10, types.type3[1])
    assert_equal(2, types.type3.size)

    types.type3.replace([10, 20, 30])
    assert_equal(10, types.type3[0])
    assert_equal(20, types.type3[1])
    assert_equal(30, types.type3[2])
    assert_equal(3, types.type3.size)
  end
end
