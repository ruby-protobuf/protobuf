# encoding: binary

require 'spec_helper'
require 'protobuf/code_generator'

RSpec.describe 'code generation' do
  before(:all) do
    require PROTOS_PATH.join('google_unittest.pb') unless defined?(::Protobuf_unittest::ForeignEnum)
    require PROTOS_PATH.join('map-test.pb') unless defined?(::Foo::Bar)
    require PROTOS_PATH.join('google_unittest_custom_options.pb') unless defined?(::Protobuf_unittest::MethodOpt1)
  end

  it "generates code for google's unittest.proto" do
    attrs = {
      optional_int32: 1,
      repeated_string: %w[boom],
      optional_nested_message: { bb: 10 },
      optional_nested_enum: ::Protobuf_unittest::TestAllTypes::NestedEnum::BAZ,
      optional_foreign_message: { c: 12 },
      repeated_import_message: [{ d: 13 }],
    }
    bytes = ::Protobuf_unittest::TestAllTypes.new(attrs).encode
    message = ::Protobuf_unittest::TestAllTypes.decode(bytes)
    expect(message.to_hash).to eq(attrs)
    expect(message.default_int32).to eq(41)
    expect(::Protobuf_unittest::TestAllTypes::FULLY_QUALIFIED_NAME).to eq('protobuf_unittest.TestAllTypes')
    descriptor_file = ::Protobuf_unittest.descriptor_set.file.first
    expect(descriptor_file.name).to eq('protos/google_unittest.proto')
    expect(descriptor_file.package).to eq('protobuf_unittest')
  end

  it "generates code for google's unittest.proto extensions" do
    attrs = { optional_import_message_extension: { d: 14 } }
    bytes = ::Protobuf_unittest::TestAllExtensions.new(attrs).encode
    message = ::Protobuf_unittest::TestAllExtensions.decode(bytes)
    expect(message.to_hash).to eq(attrs)
    expect(message.default_int64_extension).to eq(42)
    ::Protobuf_unittest::TestService.send(:set_option, '.protobuf_unittest.service_opt1', 10)
    expect(::Protobuf_unittest::TestService.get_option!('.protobuf_unittest.service_opt1')).to eq(10)
    rpc = ::Protobuf_unittest::TestService.rpcs[:foo]
    rpc.send(:set_option, '.protobuf_unittest.method_opt1', :METHODOPT1_VAL2)
    expect(rpc.get_option!('.protobuf_unittest.method_opt1')).to eq(:METHODOPT1_VAL2)
  end

  it "generates code for map types" do
    bar = ::Foo::Bar.new(int32_to_baz: { 4 => { looks_like_map: { 'goat' => 'sheep' } } })
    expect(bar.int32_to_baz[4].looks_like_map).to eq('goat' => 'sheep')
  end
end
