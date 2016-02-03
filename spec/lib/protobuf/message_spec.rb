# encoding: utf-8

require 'stringio'
require 'spec_helper'
require PROTOS_PATH.join('resource.pb')
require PROTOS_PATH.join('enum.pb')

RSpec.describe Protobuf::Message do

  describe '.decode' do
    let(:message) { ::Test::Resource.new(:name => "Jim") }

    it 'creates a new message object decoded from the given bytes' do
      expect(::Test::Resource.decode(message.encode)).to eq message
    end

    context 'with a new enum value' do
      let(:older_message) do
        Class.new(Protobuf::Message) do
          enum_class = Class.new(::Protobuf::Enum) do
            define :YAY, 1
          end

          optional enum_class, :enum_field, 1
          repeated enum_class, :enum_list, 2
        end
      end

      let(:newer_message) do
        Class.new(Protobuf::Message) do
          enum_class = Class.new(::Protobuf::Enum) do
            define :YAY, 1
            define :HOORAY, 2
          end

          optional enum_class, :enum_field, 1
          repeated enum_class, :enum_list, 2
        end
      end

      context 'with a singular field' do
        it 'treats the field as if it was unset when decoding' do
          newer = newer_message.new(:enum_field => :HOORAY).serialize

          expect(older_message.decode(newer).enum_field!).to be_nil
        end

        it 'rejects an unknown value when using the constructor' do
          expect { older_message.new(:enum_field => :HOORAY) }.to raise_error(TypeError)
        end

        it 'rejects an unknown value when the setter' do
          older = older_message.new
          expect { older.enum_field = :HOORAY }.to raise_error(TypeError)
        end
      end

      context 'with a repeated field' do
        it 'treats the field as if it was unset when decoding' do
          newer = newer_message.new(:enum_list => [:HOORAY]).serialize

          expect(older_message.decode(newer).enum_list).to eq([])
        end

        it 'rejects an unknown value when using the constructor' do
          expect { older_message.new(:enum_list => [:HOORAY]) }.to raise_error(TypeError)
        end

        it 'rejects an unknown value when the setter' do
          older = older_message.new
          expect { older.enum_field = [:HOORAY] }.to raise_error(TypeError)
        end
      end
    end
  end

  describe '.decode_from' do
    let(:message) { ::Test::Resource.new(:name => "Jim") }

    it 'creates a new message object decoded from the given byte stream' do
      stream = ::StringIO.new(message.encode)
      expect(::Test::Resource.decode_from(stream)).to eq message
    end
  end

  describe 'defining a new field' do
    context 'when defining a field with a tag that has already been used' do
      it 'raises a TagCollisionError' do
        expect do
          Class.new(Protobuf::Message) do
            optional ::Protobuf::Field::Int32Field, :foo, 1
            optional ::Protobuf::Field::Int32Field, :bar, 1
          end
        end.to raise_error(Protobuf::TagCollisionError, /Field number 1 has already been used/)
      end
    end

    context 'when defining an extension field with a tag that has already been used' do
      it 'raises a TagCollisionError' do
        expect do
          Class.new(Protobuf::Message) do
            extensions 100...110
            optional ::Protobuf::Field::Int32Field, :foo, 100
            optional ::Protobuf::Field::Int32Field, :bar, 100, :extension => true
          end
        end.to raise_error(Protobuf::TagCollisionError, /Field number 100 has already been used/)
      end
    end

    context 'when defining a field with a name that has already been used' do
      it 'raises a DuplicateFieldNameError' do
        expect do
          Class.new(Protobuf::Message) do
            optional ::Protobuf::Field::Int32Field, :foo, 1
            optional ::Protobuf::Field::Int32Field, :foo, 2
          end
        end.to raise_error(Protobuf::DuplicateFieldNameError, /Field name foo has already been used/)
      end
    end

    context 'when defining an extension field with a name that has already been used' do
      it 'raises a DuplicateFieldNameError' do
        expect do
          Class.new(Protobuf::Message) do
            extensions 100...110
            optional ::Protobuf::Field::Int32Field, :foo, 1
            optional ::Protobuf::Field::Int32Field, :foo, 100, :extension => true
          end
        end.to raise_error(Protobuf::DuplicateFieldNameError, /Field name foo has already been used/)
      end
    end
  end

  describe '.encode' do
    let(:values) { { :name => "Jim" } }

    it 'creates a new message object with the given values and returns the encoded bytes' do
      expect(::Test::Resource.encode(values)).to eq ::Test::Resource.new(values).encode
    end
  end

  describe '#initialize' do
    it "defaults to the first value listed in the enum's type definition" do
      test_enum = Test::EnumTestMessage.new
      expect(test_enum.non_default_enum).to eq(1)
    end

    it "defaults to a a value with a name" do
      test_enum = Test::EnumTestMessage.new
      expect(test_enum.non_default_enum.name).to eq(:ONE)
    end

    it "exposes the enum getter raw value through ! method" do
      test_enum = Test::EnumTestMessage.new
      expect(test_enum.non_default_enum!).to be_nil
    end

    it "exposes the enum getter raw value through ! method (when set)" do
      test_enum = Test::EnumTestMessage.new
      test_enum.non_default_enum = 1
      expect(test_enum.non_default_enum!).to eq(1)
    end

    it "does not try to set attributes which have nil values" do
      expect_any_instance_of(Test::EnumTestMessage).not_to receive("non_default_enum=")
      Test::EnumTestMessage.new(:non_default_enum => nil)
    end

    it "takes a hash as an initialization argument" do
      test_enum = Test::EnumTestMessage.new(:non_default_enum => 2)
      expect(test_enum.non_default_enum).to eq(2)
    end

    it "initializes with an object that responds to #to_hash" do
      hashie_object = OpenStruct.new(:to_hash => { :non_default_enum => 2 })
      test_enum = Test::EnumTestMessage.new(hashie_object)
      expect(test_enum.non_default_enum).to eq(2)
    end

    it "initializes with an object with a block" do
      test_enum = Test::EnumTestMessage.new { |p| p.non_default_enum = 2 }
      expect(test_enum.non_default_enum).to eq(2)
    end

    context 'ignoring unknown fields' do
      around do |example|
        orig = ::Protobuf.ignore_unknown_fields?
        ::Protobuf.ignore_unknown_fields = true
        example.call
        ::Protobuf.ignore_unknown_fields = orig
      end

      context 'with valid fields' do
        let(:values) { { :name => "Jim" } }

        it "does not raise an error" do
          expect { ::Test::Resource.new(values) }.to_not raise_error
        end
      end

      context 'with non-existent field' do
        let(:values) { { :name => "Jim", :othername => "invalid" } }

        it "does not raise an error" do
          expect { ::Test::Resource.new(values) }.to_not raise_error
        end
      end
    end

    context 'not ignoring unknown fields' do
      around do |example|
        orig = ::Protobuf.ignore_unknown_fields?
        ::Protobuf.ignore_unknown_fields = false
        example.call
        ::Protobuf.ignore_unknown_fields = orig
      end

      context 'with valid fields' do
        let(:values) { { :name => "Jim" } }

        it "does not raise an error" do
          expect { ::Test::Resource.new(values) }.to_not raise_error
        end
      end

      context 'with non-existent field' do
        let(:values) { { :name => "Jim", :othername => "invalid" } }

        it "raises an error and mentions the erroneous field" do
          expect { ::Test::Resource.new(values) }.to raise_error(::Protobuf::FieldNotDefinedError, /othername/)
        end

        context 'with a nil value' do
          let(:values) { { :name => "Jim", :othername => nil } }

          it "raises an error and mentions the erroneous field" do
            expect { ::Test::Resource.new(values) }.to raise_error(::Protobuf::FieldNotDefinedError, /othername/)
          end
        end
      end
    end
  end

  describe '#encode' do
    context "encoding" do
      it "accepts UTF-8 strings into string fields" do
        message = ::Test::Resource.new(:name => "Kyle Redfearn\u0060s iPad")

        expect { message.encode }.to_not raise_error
      end

      it "keeps utf-8 when utf-8 is input for string fields" do
        name = 'my name💩'
        name.force_encoding(Encoding::UTF_8)

        message = ::Test::Resource.new(:name => name)
        new_message = ::Test::Resource.decode(message.encode)
        expect(new_message.name == name).to be true
      end

      it "trims binary when binary is input for string fields" do
        name = "my name\xC3"
        name.force_encoding(Encoding::BINARY)

        message = ::Test::Resource.new(:name => name)
        new_message = ::Test::Resource.decode(message.encode)
        expect(new_message.name == "my name").to be true
      end
    end

    context "when there's no value for a required field" do
      let(:message) { ::Test::ResourceWithRequiredField.new }

      it "raises a 'message not initialized' error" do
        expect do
          message.encode
        end.to raise_error(Protobuf::SerializationError, /required/i)
      end
    end

    context "repeated fields" do
      let(:message) { ::Test::Resource.new(:name => "something") }

      it "does not raise an error when repeated fields are []" do
        expect do
          message.repeated_enum = []
          message.encode
        end.to_not raise_error
      end

      it "sets the value to nil when empty array is passed" do
        message.repeated_enum = []
        expect(message.instance_variable_get("@values")[:repeated_enum]).to be_nil
      end

      it "does not compact the edit original array" do
        a = [nil].freeze
        message.repeated_enum = a
        expect(message.repeated_enum).to eq([])
        expect(a).to eq([nil].freeze)
      end

      it "compacts the set array" do
        message.repeated_enum = [nil]
        expect(message.repeated_enum).to eq([])
      end

      it "raises TypeError when a non-array replaces it" do
        expect do
          message.repeated_enum = 2
        end.to raise_error(/value of type/)
      end
    end
  end

  describe "boolean predicate methods" do
    subject { Test::ResourceFindRequest.new(:name => "resource") }

    it { is_expected.to respond_to(:active?) }

    it "sets the predicate to true when the boolean value is true" do
      subject.active = true
      expect(subject.active?).to be true
    end

    it "sets the predicate to false when the boolean value is false" do
      subject.active = false
      expect(subject.active?).to be false
    end

    it "does not put predicate methods on non-boolean fields" do
      expect(Test::ResourceFindRequest.new(:name => "resource")).to_not respond_to(:name?)
    end
  end

  describe "#respond_to_and_has?" do
    subject { Test::EnumTestMessage.new(:non_default_enum => 2) }

    it "is false when the message does not have the field" do
      expect(subject.respond_to_and_has?(:other_field)).to be false
    end

    it "is true when the message has the field" do
      expect(subject.respond_to_and_has?(:non_default_enum)).to be true
    end
  end

  describe "#respond_to_has_and_present?" do
    subject { Test::EnumTestMessage.new(:non_default_enum => 2) }

    it "is false when the message does not have the field" do
      expect(subject.respond_to_and_has_and_present?(:other_field)).to be false
    end

    it "is false when the field is repeated and a value is not present" do
      expect(subject.respond_to_and_has_and_present?(:repeated_enums)).to be false
    end

    it "is false when the field is repeated and the value is empty array" do
      subject.repeated_enums = []
      expect(subject.respond_to_and_has_and_present?(:repeated_enums)).to be false
    end

    it "is true when the field is repeated and a value is present" do
      subject.repeated_enums = [2]
      expect(subject.respond_to_and_has_and_present?(:repeated_enums)).to be true
    end

    it "is true when the message has the field" do
      expect(subject.respond_to_and_has_and_present?(:non_default_enum)).to be true
    end

    context "#API" do
      subject { Test::EnumTestMessage.new(:non_default_enum => 2) }

      specify { expect(subject).to respond_to(:respond_to_and_has_and_present?) }
      specify { expect(subject).to respond_to(:responds_to_and_has_and_present?) }
      specify { expect(subject).to respond_to(:responds_to_has?) }
      specify { expect(subject).to respond_to(:respond_to_has?) }
      specify { expect(subject).to respond_to(:respond_to_has_present?) }
      specify { expect(subject).to respond_to(:responds_to_has_present?) }
      specify { expect(subject).to respond_to(:respond_to_and_has_present?) }
      specify { expect(subject).to respond_to(:responds_to_and_has_present?) }
    end

  end

  describe '#inspect' do
    let(:klass) do
      Class.new(Protobuf::Message) do |klass|
        enum_class = Class.new(Protobuf::Enum) do
          define :YAY, 1
        end

        klass.const_set(:EnumKlass, enum_class)

        optional :string, :name, 1
        repeated :int32, :counts, 2
        optional enum_class, :enum, 3
      end
    end

    before { stub_const('MyMessage', klass) }

    it 'lists the fields' do
      proto = klass.new(:name => 'wooo', :counts => [1, 2, 3], :enum => klass::EnumKlass::YAY)
      expect(proto.inspect).to eq('#<MyMessage name="wooo" counts=[1, 2, 3] enum=#<Protobuf::Enum(MyMessage::EnumKlass)::YAY=1>>')
    end
  end

  describe '#to_hash' do
    context 'generating values for an ENUM field' do
      it 'converts the enum to its tag representation' do
        hash = Test::EnumTestMessage.new(:non_default_enum => :TWO).to_hash
        expect(hash).to eq(:non_default_enum => 2)
      end

      it 'does not populate default values' do
        hash = Test::EnumTestMessage.new.to_hash
        expect(hash).to eq({})
      end

      it 'converts repeated enum fields to an array of the tags' do
        hash = Test::EnumTestMessage.new(:repeated_enums => [:ONE, :TWO, :TWO, :ONE]).to_hash
        expect(hash).to eq(:repeated_enums => [1, 2, 2, 1])
      end
    end

    context 'generating values for a Message field' do
      it 'recursively hashes field messages' do
        hash = Test::Nested.new(:resource => { :name => 'Nested' }).to_hash
        expect(hash).to eq(:resource => { :name => 'Nested' })
      end

      it 'recursively hashes a repeated set of messages' do
        proto = Test::Nested.new(
          :multiple_resources => [
            Test::Resource.new(:name => 'Resource 1'),
            Test::Resource.new(:name => 'Resource 2'),
          ],
        )

        expect(proto.to_hash).to eq(
          :multiple_resources => [
            { :name => 'Resource 1' },
            { :name => 'Resource 2' },
          ],
        )
      end
    end
  end

  describe '#to_json' do
    subject do
      ::Test::ResourceFindRequest.new(:name => 'Test Name', :active => false)
    end

    specify { expect(subject.to_json).to eq '{"name":"Test Name","active":false}' }
  end

  describe '.to_json' do
    it 'returns the class name of the message for use in json encoding' do
      expect do
        ::Timeout.timeout(0.1) do
          expect(::Test::Resource.to_json).to eq("Test::Resource")
        end
      end.not_to raise_error
    end
  end

  describe "#define_setter" do
    subject { ::Test::Resource.new }

    it "allows string fields to be set to nil" do
      expect { subject.name = nil }.to_not raise_error
    end

    it "does not allow string fields to be set to Numeric" do
      expect { subject.name = 1 }.to raise_error(/name/)
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
      expect(::Test::Resource.get_extension_field(-1)).to be_nil
      expect(::Test::Resource.get_extension_field(nil)).to be_nil
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
      expect(::Test::Resource.get_field(-1)).to be_nil
      expect(::Test::Resource.get_field(nil)).to be_nil
    end
  end

end
