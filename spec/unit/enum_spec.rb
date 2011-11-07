require 'spec_helper'
require 'spec/proto/test.pb'

describe Protobuf::Enum do
  context 'when coercing from enum' do
    subject { Spec::Proto::StatusType::PENDING }
    it { should == 0 }
  end
  context 'when coercing from integer' do
    subject { 0 }
    it { should == Spec::Proto::StatusType::PENDING }
  end
end