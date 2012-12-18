require 'spec_helper'

describe Protobuf::EnumValue do

	subject { Test::EnumTestType::ONE }
  its(:class) { should eq(Fixnum) }
	its(:parent_class) { should eq(Test::EnumTestType) }
	its(:name) { should eq(:ONE) }
	its(:value) { should eq(1) }
	its(:to_hash_value) { should eq(1) }
	its(:to_s) { should eq("1") }
	its(:inspect) { should eq('#<Protobuf::EnumValue Test::EnumTestType::ONE=1>') }
  specify { subject.to_s(:name).should eq("ONE") }

  it "can be used as the index to an array" do
    array = [0, 1, 2, 3]
    array[::Test::EnumTestType::ONE].should eq(1)
  end

  describe '#try' do
    specify { subject.try(:class).should eq subject.class }
    specify { subject.try(:name).should eq subject.name }
    specify { subject.try(:value).should eq subject.value }
    specify { subject.try(:to_i).should eq subject.to_i }
    specify { subject.try(:to_int).should eq subject.to_int }
    specify { subject.try { |yielded| yielded.should eq subject } }
  end

end
