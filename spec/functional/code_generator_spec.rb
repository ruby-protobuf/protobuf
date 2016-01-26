# encoding: binary

require 'spec_helper'
require 'protobuf/code_generator'

RSpec.describe 'code generation' do
  before do
    Object.send(:remove_const, :Protobuf_unittest)
    Object.send(:remove_const, :Protobuf_unittest_import)
  end
  it "generates code for google's unittest.proto" do
    bytes = IO.read(PROTOS_PATH.join('google_unittest.bin'), mode: 'rb')
    expected_unittest_import_public =
      IO.read(PROTOS_PATH.join('google_unittest_import_public.pb.rb'), mode: 'rb')
    expected_unittest_import =
      IO.read(PROTOS_PATH.join('google_unittest_import.pb.rb'), mode: 'rb')
    expected_unittest =
      IO.read(PROTOS_PATH.join('google_unittest.pb.rb'), mode: 'rb')

    expected_output = "z\xE5\x02\n*protos/google_unittest_import_public.pb.rbz\xB6\x02" +
      expected_unittest_import_public +
      "z\x9B\x05\n#protos/google_unittest_import.pb.rbz\xF3\x04" +
      expected_unittest_import +
      "z\xA6\x95\x02\n\x1Cprotos/google_unittest.pb.rbz\x84\x95\x02" +
      expected_unittest

    expect(::Protobuf::CodeGenerator.new(bytes).response_bytes).to eq(expected_output)
  end

  it "generates service stubs"

  it "generates code with custom field and method options"
end
