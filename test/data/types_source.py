import types_pb2
import sys

types = types_pb2.TestTypes()
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
types.type11 = False
types.type12 = 'hello all types'
# TODO test type13
#types.type13 = 

f = open('types.bin', 'wb')
f.write(types.SerializeToString())
f.close()
