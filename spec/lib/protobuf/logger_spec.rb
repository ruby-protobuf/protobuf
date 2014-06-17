require 'protobuf/logger'
require 'stringio'
require 'fileutils'

describe Protobuf::Logger do

  subject { Protobuf::Logger }

  before(:each) do
    Protobuf::Logger.reset_device!
    Protobuf::Logger.file = '/dev/null'
    Protobuf::Logger.level = ::Logger::INFO
  end

  after(:all) do
    ::FileUtils.rm_f('myfile.log')
  end

  describe '.instance' do

    it 'doesn\'t create a logger if the file was not set' do
      subject.file = nil
      expect(subject.instance).to be_nil
    end

    it 'doesn\'t create a logger if the level was not set' do
      subject.level = nil
      expect(subject.instance).to be_nil
    end

    it 'gets a new instance of the logger when file and level are set' do
      expect(subject.file).to_not be_nil
      expect(subject.level).to_not be_nil
      expect(subject.instance).to_not be_nil
    end

    it 'keeps the same object from multiple calls to instance' do
      expect(subject.instance).to equal(subject.instance)
    end

  end

  describe '.configure' do
    before(:each) { subject.reset_device! }
    it 'sets the file and level in one call' do
      expect(subject.file).to_not be
      expect(subject.level).to_not be
      expect(subject.instance).to_not be
      subject.configure :file => 'myfile.log', :level => ::Logger::WARN
      expect(subject.file).to eq('myfile.log')
      expect(subject.level).to eq(::Logger::WARN)
      expect(subject.instance.level).to eq(::Logger::WARN)
    end

  end

  describe '.reset_device!' do

    it 'resets the logger instance, file, and level' do
      expect(subject.instance).to be
      expect(subject.file).to be
      expect(subject.level).to be
      subject.reset_device!
      expect(subject.instance).to_not be
      expect(subject.file).to_not be
      expect(subject.level).to_not be
    end

  end

  context 'when logging' do

    it 'doesn\'t raise errors when log instance is nil' do
      subject.reset_device!
      expect(subject.instance).to be_nil
      expect {
        subject.debug 'No errors here'
        subject.info 'No errors here'
        subject.warn 'No errors here'
        subject.error 'No errors here'
        subject.fatal 'No errors here'
        subject.add 'No errors here'
        subject.log 'No errors here'
      }.to_not raise_error
    end

    it 'logs correctly when instance is valid' do
      expect(subject.instance).to_not be_nil
      expect(subject.instance).to receive(:info).with('Should log great')
      subject.info 'Should log great'
    end

  end

  describe Protobuf::Logger::LogMethods do

    context 'when included in another class' do

      before(:all) do
        class MyTestClass
          include Protobuf::Logger::LogMethods
        end
      end

      subject { MyTestClass.new }

      it { should respond_to(:log_debug) }
      it { should respond_to(:log_info) }
      it { should respond_to(:log_warn) }
      it { should respond_to(:log_error) }
      it { should respond_to(:log_fatal) }
      it { should respond_to(:log_add) }
      it { should respond_to(:log_log) }

      context '#log_exception' do
        it 'logs the exception message as an error and backtrace as debug' do
          expect(subject).to receive(:log_error).twice
          expect(subject).to receive(:log_debug)
          subject.log_exception(RuntimeError.new('this is an exception'))
        end
      end

      specify { expect(subject.log_signature).to eq "[MyTestClass]" }
      describe '#sign_message' do
        specify { expect(subject.sign_message("this is a test")).to eq "[MyTestClass] this is a test" }
        specify { expect(subject.class.sign_message("this is a test")).to eq "[MyTestClass] this is a test" }
      end

      it 'passes all embedded log calls to Logger instance' do
        expect(Protobuf::Logger.instance).to receive(:debug).with('[MyTestClass] log this')
        subject.log_debug('log this')
      end

    end
  end
end
