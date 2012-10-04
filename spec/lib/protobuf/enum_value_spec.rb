require 'spec_helper'

describe Protobuf::EnumValue do

	subject { Test::EnumTestType::ONE }
	its(:parent_class) { should eq Test::EnumTestType }
	its(:name) { should eq :ONE }
	its(:value) { should eq 1 }
	its(:to_hash_value) { should eq 1 }
	its(:to_s) { should eq "ONE" }
	its(:inspect) { should eq '#<Protobuf::EnumValue Test::EnumTestType::ONE=1>' }

end
