require 'spec_helper'

RSpec.describe Protobuf::Field::Int32Field do
  let(:field_name) { :some_packed_field }

  let(:packable_field_test_class) do
    type = described_class
    name = field_name

    Class.new(::Protobuf::Message) do
      repeated type, name, fields.count + 1, :packed => true
    end
  end

  let(:message_instance) { packable_field_test_class.new(field_name => [100, 200, 300]) }

  subject { packable_field_test_class.get_field(field_name) }

  specify { expect(subject).to be_packed }
end
