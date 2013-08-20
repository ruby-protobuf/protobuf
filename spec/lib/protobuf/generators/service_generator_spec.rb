require 'spec_helper'

require 'protobuf/generators/service_generator'

describe ::Protobuf::Generators::ServiceGenerator do

  let(:methods) {
    [
      { :name => 'Search', :input_type => 'FooRequest', :output_type => 'FooResponse' },
      { :name => 'FooBar', :input_type => '.foo.Request', :output_type => '.bar.Response' }
    ]
  }
  let(:service_fields) { { :name => 'TestService',
                           :method => methods } }

  let(:service) { ::Google::Protobuf::ServiceDescriptorProto.new(service_fields) }

  subject { described_class.new(service) }

  describe '#compile' do
    let(:compiled) {
      %q{class TestService < ::Protobuf::Rpc::Service
  rpc :search, FooRequest, FooResponse
  rpc :foo_bar, ::Foo::Request, ::Bar::Response
end

}
    }

    it 'compiles the service and it\'s rpc methods' do
      subject.compile
      subject.to_s.should eq(compiled)
    end
  end

  describe '#build_method' do
    it 'returns a string identifying the given method descriptor' do
      subject.build_method(service.method.first).should eq("rpc :search, FooRequest, FooResponse")
    end
  end

end

