require 'spec_helper'

require 'protobuf/generators/service_generator'

RSpec.describe ::Protobuf::Generators::ServiceGenerator do

  class ::CustomMethodEnum < ::Protobuf::Enum
    define :BOOM, 1
    define :BAM, 2
  end

  class ::CustomMethodMessage < ::Protobuf::Message
    optional :string, :foo, 1
  end

  class ::Google::Protobuf::MethodOptions < ::Protobuf::Message
    optional :string, :custom_string_option, 22000, :extension => true
    optional :bool, :custom_bool_option, 22001, :extension => true
    optional :int32, :custom_int32_option, 22002, :extension => true
    optional ::CustomMethodEnum, :custom_enum_option, 22003, :extension => true
    optional ::CustomMethodMessage, :custom_message_option, 22004, :extension => true
  end

  let(:methods) do
    [
      { :name => 'Search', :input_type => 'FooRequest', :output_type => 'FooResponse' },
      {
        :name => 'FooBar',
        :input_type => '.foo.Request',
        :output_type => '.bar.Response',
        :options => {
          :custom_string_option => 'boom',
          :custom_bool_option => true,
          :custom_int32_option => 123,
          :custom_message_option => CustomMethodMessage.new(:foo => 'bam'),
          :custom_enum_option => CustomMethodEnum::BAM,
        },
      },
    ]
  end
  let(:service_fields) do
    {
      :name => 'TestService',
      :method => methods,
    }
  end

  let(:service) { ::Google::Protobuf::ServiceDescriptorProto.new(service_fields) }

  subject { described_class.new(service) }

  describe '#compile' do
    let(:compiled) do
      <<EOF
class TestService < ::Protobuf::Rpc::Service
  rpc :search, FooRequest, FooResponse
  rpc :foo_bar, ::Foo::Request, ::Bar::Response, :custom_string_option => "boom", :custom_bool_option => true, :custom_int32_option => 123, :custom_enum_option => ::CustomMethodEnum::BAM, :custom_message_option => { :foo => "bam" }
end

EOF
    end

    it 'compiles the service and it\'s rpc methods' do
      subject.compile
      expect(subject.to_s).to eq(compiled)
    end
  end

  describe '#build_method' do
    it 'returns a string identifying the given method descriptor' do
      expect(subject.build_method(service.method.first)).to eq("rpc :search, FooRequest, FooResponse")
    end
  end

end
