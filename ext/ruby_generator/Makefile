all: \
	RubyGenerator.h \
	RubyGenerator.cpp
	g++ -Wall -I/code/src/utilities/protobuf-2.4.1/src -lprotoc -lprotobuf -lpthread -o protoc-ruby RubyGenerator.cpp

test:
	rm -rf test/out/*
	./protoc-ruby --proto_path=../defs --ruby_out=../out ../defs/atlas/util.proto ../defs/atlas/newman/*.proto

.PHONY: all test
