require 'spec_helper'

describe Protobuf::EnumValue do

  def capture_stderr(&required_block)
    real_stderr = $stderr
    $stderr = StringIO.new
    yield
    $stderr.string
  ensure
    $stderr = real_stderr
  end

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

  it "prints a Warning to $stderr when #value is called" do 
    local_warning = capture_stderr do 
      ::Test::EnumTestType::ONE.value
    end

    local_warning.should match(/deprecated/i)
  end
end
