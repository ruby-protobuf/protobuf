require 'spec_helper'

describe Protobuf::Message do

  describe '.decode' do
    let(:message) { ::Test::Resource.new(:name => "Jim") }

    it 'creates a new message object decoded from the given bytes' do
      ::Test::Resource.decode(message.encode).should eq message
    end
  end

  describe 'defining a new field' do
    context 'when defining a field with a tag that has already been used' do
      it 'raises a TagCollisionError' do
        expect {
          Class.new(Protobuf::Message) do
            optional ::Protobuf::Field::Int32Field, :foo, 1
            optional ::Protobuf::Field::Int32Field, :bar, 1
          end
        }.to raise_error(Protobuf::TagCollisionError, /Field number 1 has already been used/)
      end
    end

    context 'when defining an extension field with a tag that has already been used' do
      it 'raises a TagCollisionError' do
        expect {
          Class.new(Protobuf::Message) do
            extensions 100...110
            optional ::Protobuf::Field::Int32Field, :foo, 100
            optional ::Protobuf::Field::Int32Field, :bar, 100, :extension => true
          end
        }.to raise_error(Protobuf::TagCollisionError, /Field number 100 has already been used/)
      end
    end

    context 'when defining a field with a name that has already been used' do
      it 'raises a DuplicateFieldNameError' do
        expect {
          Class.new(Protobuf::Message) do
            optional ::Protobuf::Field::Int32Field, :foo, 1
            optional ::Protobuf::Field::Int32Field, :foo, 2
          end
        }.to raise_error(Protobuf::DuplicateFieldNameError, /Field name foo has already been used/)
      end
    end

    context 'when defining an extension field with a name that has already been used' do
      it 'raises a DuplicateFieldNameError' do
        expect {
          Class.new(Protobuf::Message) do
            extensions 100...110
            optional ::Protobuf::Field::Int32Field, :foo, 1
            optional ::Protobuf::Field::Int32Field, :foo, 100, :extension => true
          end
        }.to raise_error(Protobuf::DuplicateFieldNameError, /Field name foo has already been used/)
      end
    end
  end

  describe '.encode' do
    let(:values) { { :name => "Jim" } }

    it 'creates a new message object with the given values and returns the encoded bytes' do
      ::Test::Resource.encode(values).should eq ::Test::Resource.new(values).encode
    end
  end

  describe '#initialize' do
    it "initializes the enum getter to 0" do
      test_enum = Test::EnumTestMessage.new
      test_enum.non_default_enum.should eq(0)
    end

    it "exposes the enum getter raw value through ! method" do
      test_enum = Test::EnumTestMessage.new
      test_enum.non_default_enum!.should be_nil
    end

    it "exposes the enum getter raw value through ! method (when set)" do
      test_enum = Test::EnumTestMessage.new
      test_enum.non_default_enum = 1
      test_enum.non_default_enum!.should eq(1)
    end

    it "does not try to set attributes which have nil values" do
      Test::EnumTestMessage.any_instance.should_not_receive("non_default_enum=")
      Test::EnumTestMessage.new(:non_default_enum => nil)
    end

    it "takes a hash as an initialization argument" do
      test_enum = Test::EnumTestMessage.new(:non_default_enum => 2)
      test_enum.non_default_enum.should eq(2)
    end

    it "initializes with an object that responds to #to_hash" do
      hashie_object = OpenStruct.new(:to_hash => { :non_default_enum => 2 })
      test_enum = Test::EnumTestMessage.new(hashie_object)
      test_enum.non_default_enum.should eq(2)
    end
  end

  describe '#encode' do
    context "encoding" do
      it "accepts UTF-8 strings into string fields" do
        message = ::Test::Resource.new(:name => "Kyle Redfearn\u0060s iPad")

        expect { message.encode }.to_not raise_error
      end

      it "keeps utf-8 when utf-8 is input for string fields" do
        name = "my name\xC3"
        name.force_encoding("UTF-8")

        message = ::Test::Resource.new(:name => name)
        new_message = ::Test::Resource.decode(message.encode)
        (new_message.name == name).should be_true
      end

      it "trims binary when binary is input for string fields" do
        name = "my name\xC3"
        name.force_encoding("ASCII-8BIT")

        message = ::Test::Resource.new(:name => name)
        new_message = ::Test::Resource.decode(message.encode)
        (new_message.name == "my name").should be_true
      end
    end

    context "when there's no value for a required field" do
      let(:message) { ::Test::ResourceWithRequiredField.new }

      it "raises a 'message not initialized' error" do
        expect {
          message.encode
        }.to raise_error(Protobuf::SerializationError, /required/i)
      end
    end

    context "repeated fields" do
      let(:message) { ::Test::Resource.new(:name => "something") }

      it "does not raise an error when repeated fields are []" do
        expect {
          message.repeated_enum = []
          message.encode
        }.to_not raise_error
      end

      it "sets the value to nil when empty array is passed" do
        message.repeated_enum = []
        message.instance_variable_get("@values")[:repeated_enum].should be_nil
      end

      it "does not compact the edit original array" do
        a = [nil].freeze
        message.repeated_enum = a
        message.repeated_enum.should eq([])
        a.should eq([nil].freeze)
      end

      it "compacts the set array" do
        message.repeated_enum = [nil]
        message.repeated_enum.should eq([])
      end

      it "raises TypeError when a non-array replaces it" do
        expect {
          message.repeated_enum = 2
        }.to raise_error(/value of type/)
      end
    end
  end

  describe "boolean predicate methods" do
    subject { Test::ResourceFindRequest.new(:name => "resource") }

    it { should respond_to(:active?) }

    it "sets the predicate to true when the boolean value is true" do
      subject.active = true
      subject.active?.should be_true
    end

    it "sets the predicate to false when the boolean value is false" do
      subject.active = false
      subject.active?.should be_false
    end

    it "does not put predicate methods on non-boolean fields" do
      Test::ResourceFindRequest.new(:name => "resource").should_not respond_to(:name?)
    end
  end

  describe "#respond_to_and_has?" do
    subject { Test::EnumTestMessage.new(:non_default_enum => 2) }

    it "is false when the message does not have the field" do
      subject.respond_to_and_has?(:other_field).should be_false
    end

    it "is true when the message has the field" do
      subject.respond_to_and_has?(:non_default_enum).should be_true
    end
  end

  describe "#respond_to_has_and_present?" do
    subject { Test::EnumTestMessage.new(:non_default_enum => 2) }

    it "is false when the message does not have the field" do
      subject.respond_to_and_has_and_present?(:other_field).should be_false
    end

    it "is false when the field is repeated and a value is not present" do
      subject.respond_to_and_has_and_present?(:repeated_enums).should be_false
    end

    it "is false when the field is repeated and the value is empty array" do
      subject.repeated_enums = []
      subject.respond_to_and_has_and_present?(:repeated_enums).should be_false
    end

    it "is true when the field is repeated and a value is present" do
      subject.repeated_enums = [2]
      subject.respond_to_and_has_and_present?(:repeated_enums).should be_true
    end

    it "is true when the message has the field" do
      subject.respond_to_and_has_and_present?(:non_default_enum).should be_true
    end

    context "#API" do
      subject { Test::EnumTestMessage.new(:non_default_enum => 2) }

      it { should respond_to(:respond_to_and_has_and_present?) }
      it { should respond_to(:responds_to_and_has_and_present?) }
      it { should respond_to(:responds_to_has?) }
      it { should respond_to(:respond_to_has?) }
      it { should respond_to(:respond_to_has_present?) }
      it { should respond_to(:responds_to_has_present?) }
      it { should respond_to(:respond_to_and_has_present?) }
      it { should respond_to(:responds_to_and_has_present?) }
    end

  end

  describe '#to_hash' do
    context 'generating values for an ENUM field' do
      it 'converts the enum to its tag representation' do
        hash = Test::EnumTestMessage.new(:non_default_enum => :TWO).to_hash
        hash.should eq({ :non_default_enum => 2 })
      end

      it 'does not populate default values' do
        hash = Test::EnumTestMessage.new.to_hash
        hash.should eq(Hash.new)
      end

      it 'converts repeated enum fields to an array of the tags' do
        hash = Test::EnumTestMessage.new(:repeated_enums => [ :ONE, :TWO, :TWO, :ONE ]).to_hash
        hash.should eq({ :repeated_enums => [ 1, 2, 2, 1 ] })
      end
    end

    context 'generating values for a Message field' do
      it 'recursively hashes field messages' do
        hash = Test::Nested.new({ :resource => { :name => 'Nested' } }).to_hash
        hash.should eq({ :resource => { :name => 'Nested' } })
      end

      it 'recursively hashes a repeated set of messages' do
        proto = Test::Nested.new(:multiple_resources => [
          Test::Resource.new(:name => 'Resource 1'),
          Test::Resource.new(:name => 'Resource 2')
        ])

        proto.to_hash.should eq({ :multiple_resources => [ { :name => 'Resource 1' },
                                                           { :name => 'Resource 2' } ] })

      end
    end
  end

  describe '#to_json' do
    subject do
      ::Test::ResourceFindRequest.new({ :name => 'Test Name', :active => false })
    end

    its(:to_json) { should eq '{"name":"Test Name","active":false}' }
  end

  describe "#define_setter" do
    subject { ::Test::Resource.new }

    it "allows string fields to be set to nil" do
      expect { subject.name = nil }.to_not raise_error
    end

    it "does not allow string fields to be set to Numeric" do
      expect { subject.name = 1}.to raise_error(/name/)
    end
  end

  describe '.get_extension_field' do
    it 'fetches an extension field by its tag' do
      field = ::Test::Resource.get_extension_field(100)
      expect(field).to be_a(::Protobuf::Field::BoolField)
      expect(field.tag).to eq(100)
      expect(field.name).to eq(:ext_is_searchable)
      expect(field).to be_extension
    end

    it 'fetches an extension field by its symbolized name' do
      expect(::Test::Resource.get_extension_field(:ext_is_searchable)).to be_a(::Protobuf::Field::BoolField)
      expect(::Test::Resource.get_extension_field('ext_is_searchable')).to be_a(::Protobuf::Field::BoolField)
    end

    it 'returns nil when attempting to get a non-extension field' do
      expect(::Test::Resource.get_extension_field(1)).to be_nil
    end

    it 'returns nil when field is not found' do
      ::Test::Resource.get_extension_field(-1).should be_nil
      ::Test::Resource.get_extension_field(nil).should be_nil
    end
  end

  describe '.get_field' do
    it 'fetches a non-extension field by its tag' do
      field = ::Test::Resource.get_field(1)
      expect(field).to be_a(::Protobuf::Field::StringField)
      expect(field.tag).to eq(1)
      expect(field.name).to eq(:name)
      expect(field).not_to be_extension
    end

    it 'fetches a non-extension field by its symbolized name' do
      expect(::Test::Resource.get_field(:name)).to be_a(::Protobuf::Field::StringField)
      expect(::Test::Resource.get_field('name')).to be_a(::Protobuf::Field::StringField)
    end

    it 'fetches an extension field when forced' do
      expect(::Test::Resource.get_field(100, true)).to be_a(::Protobuf::Field::BoolField)
      expect(::Test::Resource.get_field(:ext_is_searchable, true)).to be_a(::Protobuf::Field::BoolField)
      expect(::Test::Resource.get_field('ext_is_searchable', true)).to be_a(::Protobuf::Field::BoolField)
    end

    it 'returns nil when attempting to get an extension field' do
      expect(::Test::Resource.get_field(100)).to be_nil
    end

    it 'returns nil when field is not defined' do
      ::Test::Resource.get_field(-1).should be_nil
      ::Test::Resource.get_field(nil).should be_nil
    end
  end

end
