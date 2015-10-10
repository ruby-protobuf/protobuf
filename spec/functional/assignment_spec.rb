require 'spec_helper'
require 'spec/support/test/resource_service'

RSpec.describe 'assign' do
  class Foo < ::Protobuf::Message
    repeated :string, :string, 1
    repeated :float, :float, 2
    repeated :double, :double, 3
    repeated :int32, :int32, 4
    repeated :int64, :int64, 5
  end

  let(:target) { Foo.new }

  specify 'string to repeated string' do
    target.string = ["foo1", "foo2"]
    expect(target.string).to eq(["foo1", "foo2"])
  end

  specify 'string to repeated int32' do
    target.int32 = ["1", "-1"]
    expect(target.int32).to eq([1, -1])
  end

  specify 'string to repeated int64' do
    target.int64 = [String(2**41), String(-2**41)]
    expect(target.int64).to eq([2**41, -2**41])
  end

  specify 'string to repeated float' do
    target.float = ["1.1", "-1.1"]
    expect(target.float).to eq([1.1, -1.1])
  end

  specify 'string to repeated double' do
    target.double = ["1.1", "-1.1"]
    expect(target.double).to eq([1.1, -1.1])
  end

  specify 'nil to repeated string' do
    target.string = ["foo1", "foo2"]
    target.string = nil
    expect(target.string).to eq([])
  end

  specify 'nil to repeated int32' do
    target.int32 = ["1", "2"]
    target.int32 = nil
    expect(target.int32).to eq([])
  end

  specify 'nil to repeated int64' do
    target.int64 = [String(1**40), String(1**41)]
    target.int64 = nil
    expect(target.int64).to eq([])
  end

  specify 'nil to repeated float' do
    target.float = ["1.1", "1.2"]
    target.float = nil
    expect(target.float).to eq([])
  end

  specify 'nil to repeated double' do
    target.double = ["1.1", "1.2"]
    target.double = nil
    expect(target.double).to eq([])
  end
end
