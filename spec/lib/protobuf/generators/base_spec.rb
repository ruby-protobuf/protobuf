require 'spec_helper'

require 'protobuf/code_generator'
require 'protobuf/generators/base'

RSpec.describe ::Protobuf::Generators::Base do

  subject { described_class.new(double) }

  context 'namespaces' do
    let(:descriptor) { double(:name => 'Baz') }
    subject { described_class.new(descriptor, 0, :namespace => [:foo, :bar]) }
    specify { expect(subject.type_namespace).to eq([:foo, :bar, 'Baz']) }
    specify { expect(subject.fully_qualified_type_namespace).to eq('.foo.bar.Baz') }
  end

  describe '#run_once' do
    it 'protects the block from being entered more than once' do
      foo = 0
      bar = 0

      test_run_once = lambda do
        bar += 1
        subject.run_once(:foo_test) do
          foo += 1
        end
      end

      10.times { test_run_once.call }
      expect(foo).to eq(1)
      expect(bar).to eq(10)
    end

    it 'always returns the same object' do
      rv = subject.run_once(:foo_test) do
        "foo bar"
      end
      expect(rv).to eq("foo bar")

      rv = subject.run_once(:foo_test) do
        "baz quux"
      end
      expect(rv).to eq("foo bar")
    end
  end

  describe '#to_s' do
    before do
      class ToStringTest < ::Protobuf::Generators::Base
        def compile
          run_once(:compile) do
            puts "this is a test"
          end
        end
      end
    end

    subject { ToStringTest.new(double) }

    it 'compiles and returns the contents' do
      10.times do
        expect(subject.to_s).to eq("this is a test\n")
      end
    end
  end

  describe '#validate_tags' do
    context 'when tags are duplicated' do
      it 'fails with a GeneratorFatalError' do
        expect(::Protobuf::CodeGenerator).to receive(:fatal).with(/FooBar object has duplicate tags\. Expected 3 tags, but got 4/)
        described_class.validate_tags("FooBar", [1, 2, 2, 3])
      end
    end

    context 'when tags are missing in the range' do
      it 'prints a warning' do
        allow(ENV).to receive(:key?).and_call_original
        allow(ENV).to receive(:key?).with("PB_NO_TAG_WARNINGS").and_return(false)
        expect(::Protobuf::CodeGenerator).to receive(:print_tag_warning_suppress)
        expect(::Protobuf::CodeGenerator).to receive(:warn).with(/FooBar object should have 5 tags \(1\.\.5\), but found 4 tags/)
        described_class.validate_tags("FooBar", [1, 2, 4, 5])
      end
    end
  end

end
