require 'spec_helper'
require 'spec/proto/test.pb'

describe Protobuf::Enum do
  context 'when coercing from enum' do
    subject { Test::StatusType::PENDING }
    it { should eq(0) }
  end

  context 'when coercing from integer' do
    it { 0.should eq(Test::StatusType::PENDING) }
  end
end
