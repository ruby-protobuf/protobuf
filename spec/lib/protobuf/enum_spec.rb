require 'spec_helper'

describe Protobuf::Enum do
  let(:name) { :THREE }
  let(:tag)  { 3 }

  before(:all) do
    Test::EnumTestType.define(:MINUS_ONE, -1)
    Test::EnumTestType.define(:THREE, 3)
  end

  before(:all) do
    EnumAliasTest = ::Class.new(::Protobuf::Enum) do
      set_option :allow_alias
      define :FOO, 1
      define :BAR, 1
      define :BAZ, 2
    end
  end

  describe '.aliases_allowed?' do
    it 'is false when the option is not set' do
      expect(Test::EnumTestType.aliases_allowed?).to be_false
    end
  end

  describe '.all_enum_values_by_value' do
    it 'returns an array of EnumValues for the given tag' do
      expect(EnumAliasTest.all_enum_values_by_value(1)).to eq([ EnumAliasTest::FOO, EnumAliasTest::BAR ])
      expect(EnumAliasTest.all_enum_values_by_value(2)).to eq([ EnumAliasTest::BAZ ])
      expect(EnumAliasTest.all_enum_values_by_value(3)).to eq([])
    end
  end

  describe '.define' do
    it 'defines a constant enum value on the parent class' do
      expect(Test::EnumTestType.constants).to include(name)
      expect(Test::EnumTestType::THREE).to be_a(Protobuf::EnumValue)
    end

    context 'when enum allows aliases' do
      before(:all) do
        DefineEnumAlias = ::Class.new(::Protobuf::Enum) do
          set_option :allow_alias
        end
      end

      it 'allows defining enum values with the same tag number' do
        expect {
          DefineEnumAlias.define(:FOO, 1)
          DefineEnumAlias.define(:BAR, 1)
        }.not_to raise_error
      end
    end
  end

  describe '.fetch' do
    context 'when value is an EnumValue' do
      it 'responds with that object' do
        expect(Test::EnumTestType.fetch(Test::EnumTestType::THREE)).to eq(Test::EnumTestType::THREE)
      end
    end

    context 'when value can be coerced to a symbol' do
      it 'fetches based on the symbol name value' do
        expect(Test::EnumTestType.fetch("ONE")).to eq(Test::EnumTestType::ONE)
        expect(Test::EnumTestType.fetch(:ONE)).to eq(Test::EnumTestType::ONE)
      end
    end

    context 'when value can be coerced to an integer' do
      it 'fetches based on the integer tag value' do
        expect(Test::EnumTestType.fetch(3.0)).to eq(Test::EnumTestType::THREE)
        expect(Test::EnumTestType.fetch(3)).to eq(Test::EnumTestType::THREE)
      end

      context 'when enum allows aliases' do
        it 'fetches the first defined EnumValue' do
          expect(EnumAliasTest.fetch(1)).to eq(EnumAliasTest::FOO)
        end
      end
    end

    context 'when value is not an applicable type' do
      it 'returns a nil' do
        expect(Test::EnumTestType.fetch(Test::Resource.new)).to be_nil
        expect(Test::EnumTestType.fetch(nil)).to be_nil
        expect(Test::EnumTestType.fetch(false)).to be_nil
      end
    end
  end

  describe '.enum_value_by_value' do
    it 'gets the EnumValue corresponding to the given value (tag)' do
      expect(Test::EnumTestType.enum_value_by_value(tag)).to eq(Test::EnumTestType.const_get(name))
    end
  end

  describe '.name_by_value' do
    it 'get the name by value of the enum given the enum' do
      expect(Test::EnumTestType.name_by_value(::Test::EnumTestType::THREE)).to eq(name)
    end

    it 'gets the name of the enum corresponding to the given value (tag)' do
      expect(Test::EnumTestType.name_by_value(tag)).to eq(name)
    end

    it 'gets the name when the tag is coercable to an int' do
      expect(Test::EnumTestType.name_by_value("3")).to eq(name)
    end

    it 'returns nil when tag does not correspond to a name' do
      expect(Test::EnumTestType.name_by_value(12345)).to be_nil
    end

    context 'when given name is nil' do
      it 'returns a nil' do
        expect(Test::EnumTestType.name_by_value(nil)).to be_nil
      end
    end

    context 'when enum allows aliases' do
      it 'returns the first defined name for that value' do
        expect(EnumAliasTest.name_by_value(1)).to eq(:FOO)
      end
    end
  end

  describe '.valid_value?' do
    context 'when tag is defined' do
      specify { expect(Test::EnumTestType.valid_value?(tag)).to be_true }
    end

    context 'when tag is not defined' do
      specify { expect(Test::EnumTestType.valid_value?(300)).to be_false }
    end

    context 'when enum allows aliases' do
      it 'treats aliased values as valid' do
        expect(EnumAliasTest.valid_value?(1)).to be_true
      end
    end
  end

  describe '.enum_value_by_name' do
    it 'gets the EnumValue corresponding to the given name' do
      expect(Test::EnumTestType.enum_value_by_name(name)).to eq(Test::EnumTestType::THREE)
    end
  end

  describe '.enum_values' do
    it 'provides a hash of defined EnumValue objects' do
      expect(Test::EnumTestType.values).to eq({
        :MINUS_ONE => Test::EnumTestType::MINUS_ONE,
        :ONE       => Test::EnumTestType::ONE,
        :TWO       => Test::EnumTestType::TWO,
        :THREE     => Test::EnumTestType::THREE
      })
    end

    context 'when enum allows aliases' do

      it 'treats aliased values as valid' do
        expect(EnumAliasTest.enum_values).to eq({
          :FOO => EnumAliasTest::FOO,
          :BAR => EnumAliasTest::BAR,
          :BAZ => EnumAliasTest::BAZ
        })
      end
    end
  end

  describe '.all_values' do
    it 'provides an array of the integer values' do
      expect(Test::EnumTestType.all_values).to include(-1, 1, 2, 3)
    end

    context 'when enum allows aliases' do
      it 'returns a unique array of all defined enum values' do
        expect(EnumAliasTest.all_values).to include(1, 2)
      end
    end
  end

  context 'when coercing from enum' do
    subject { Test::StatusType::PENDING }
    it { should eq(0) }
  end

  context 'when coercing from integer' do
    specify { expect(0).to eq(Test::StatusType::PENDING) }
  end

end
