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

end
