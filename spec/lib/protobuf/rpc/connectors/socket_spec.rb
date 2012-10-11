require 'spec_helper'
require 'protobuf/socket'

shared_examples "a Protobuf Connector" do
  subject{ described_class.new({}) }

  context "API" do
    # Check the API
    specify{ subject.respond_to?(:send_request, true).should be_true }
    specify{ subject.respond_to?(:post_init, true).should be_true }
    specify{ subject.respond_to?(:close_connection, true).should be_true }
    specify{ subject.respond_to?(:error?, true).should be_true }
  end
end

describe Protobuf::Rpc::Connectors::Socket do
  subject{ described_class.new({}) }

  it_behaves_like "a Protobuf Connector"

  specify{ described_class.include?(Protobuf::Rpc::Connectors::Common).should be_true }

  context "#read_response" do
    let(:data){ "New data" }

    it "fills the buffer with data from the socket" do
      socket = StringIO.new("#{data.bytesize}-#{data}")
      subject.instance_variable_set(:@socket, socket)
      subject.instance_variable_set(:@stats, OpenStruct.new)
      subject.should_receive(:parse_response).and_return(true)

      subject.__send__(:read_response)
      subject.instance_variable_get(:@response_data).should eq(data)
    end
  end
end
