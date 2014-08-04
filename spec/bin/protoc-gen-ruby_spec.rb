require 'spec_helper'

require 'protobuf/code_generator'

describe 'protoc-gen-ruby' do
  let(:binpath) { ::File.expand_path('../../../bin/protoc-gen-ruby', __FILE__) }
  let(:request_bytes) { ::Google::Protobuf::Compiler::CodeGeneratorRequest.new(:file_to_generate => [ "test/foo.proto" ]) }
  let(:expected_file) { ::Google::Protobuf::Compiler::CodeGeneratorResponse::File.new(:name => 'test/foo.pb.rb') }
  let(:expected_response_bytes) { ::Google::Protobuf::Compiler::CodeGeneratorRequest.encode(:files => [ expected_file ]) }

  it 'reads the serialized request bytes and outputs serialized response bytes' do
    ::IO.popen(binpath, 'w+') do |pipe|
      pipe.write(request_bytes)
      expect(pipe.read(expected_response_bytes.size)).to eq expected_response_bytes
    end
  end
end

