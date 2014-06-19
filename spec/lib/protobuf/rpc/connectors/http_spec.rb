require 'spec_helper'
require 'protobuf/http'
require 'faraday'

describe ::Protobuf::Rpc::Connectors::Http do
  subject { described_class.new({}) }
  
  it_behaves_like "a Protobuf Connector"

  specify{ described_class.include?(Protobuf::Rpc::Connectors::Common).should be_truthy }

  let(:client_double) do
    Faraday.new do |builder|
      builder.adapter :test do |stub|
        stub.post("/Foo/UserService/find") {[ 200, {}, "\n\n\n\x03foo\x12\x03bar" ]}
        stub.post("/Foo/UserService/foo1") {[ 404, {
          'x-protobuf-error' => "Foo::UserService#foo1 is not a defined RPC method.",
          'x-protobuf-error-reason' => Protobuf::Socketrpc::ErrorReason::METHOD_NOT_FOUND.to_s
        }, "" ]}
        stub.post("/Foo/UserService/foo2") {[ 500, {}, "" ]}
        stub.post("/base/Foo/UserService/foo3") {[ 200, {}, "\n\n\n\x03foo\x12\x03bar" ]}
      end
    end
  end

  describe "#send_data" do
    before do
      subject.stub(:client) { client_double }
      subject.stub(:parse_response) {}
    end

    it "handles RPC success correctly" do
      subject.stub(:request_bytes) { "\n\x10Foo::UserService\x12\x04find\x1A\r\n\vfoo@bar.com\"\rabcdefghijklm" }
      subject.send(:setup_connection)
      subject.send(:send_data)
      subject.instance_variable_get(:@response_data).should eq "\n\f\n\n\n\x03foo\x12\x03bar"
    end

    it "handles RPC error correctly" do
      subject.stub(:request_bytes) { "\n\x10Foo::UserService\x12\x04foo1\x1A\r\n\vfoo@bar.com\"\rabcdefghijklm" }
      subject.send(:setup_connection)
      subject.send(:send_data)
      subject.instance_variable_get(:@response_data).should eq "\n\x00\x122Foo::UserService#foo1 is not a defined RPC method. \x03"
    end

    it "handles server error correctly" do
      subject.stub(:request_bytes) { "\n\x10Foo::UserService\x12\x04foo2\x1A\r\n\vfoo@bar.com\"\rabcdefghijklm" }
      subject.send(:setup_connection)
      subject.send(:send_data)
      subject.instance_variable_get(:@response_data).should eq "\n\x00\x12\x1DBad response from the server. \x07"
    end

    it "prepends base path option correctly" do
      subject.stub(:options) { { :base => "/base" }}
      subject.stub(:request_bytes) { "\n\x10Foo::UserService\x12\x04foo3\x1A\r\n\vfoo@bar.com\"\rabcdefghijklm" }
      subject.send(:setup_connection)
      subject.send(:send_data)
      subject.instance_variable_get(:@response_data).should eq "\n\f\n\n\n\x03foo\x12\x03bar"
    end
  end
end
