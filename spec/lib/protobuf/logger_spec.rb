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
      subject.instance.should be_nil
    end

    it 'doesn\'t create a logger if the level was not set' do
      subject.level = nil
      subject.instance.should be_nil
    end

    it 'gets a new instance of the logger when file and level are set' do
      subject.file.should_not be_nil
      subject.level.should_not be_nil
      subject.instance.should_not be_nil
    end

    it 'keeps the same object from multiple calls to instance' do
      subject.instance === subject.instance
    end

  end

  describe '.configure' do
    before(:each) { subject.reset_device! }
    it 'sets the file and level in one call' do
      subject.file.should_not be
      subject.level.should_not be
      subject.instance.should_not be
      subject.configure :file => 'myfile.log', :level => ::Logger::WARN
      subject.file.should == 'myfile.log'
      subject.level.should == ::Logger::WARN
      subject.instance.level.should == ::Logger::WARN
    end

    context 'specifying logger' do
      let(:logger) { double('Logger') }

      it 'sets the logger instance' do
        subject.instance.should_not be
        subject.configure :logger => logger
        subject.instance.should == logger
      end
    end
  end

  describe '.reset_device!' do

    it 'resets the logger instance, file, and level' do
      subject.instance.should be
      subject.file.should be
      subject.level.should be
      subject.reset_device!
      subject.instance.should_not be
      subject.file.should_not be
      subject.level.should_not be
    end

  end

  context 'when logging' do

    it 'doesn\'t raise errors when log instance is nil' do
      subject.reset_device!
      subject.instance.should be_nil
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
      subject.instance.should_not be_nil
      subject.instance.should_receive(:info).with('Should log great')
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
          subject.should_receive(:log_error).twice
          subject.should_receive(:log_debug)
          subject.log_exception(RuntimeError.new('this is an exception'))
        end
      end

      its(:log_signature) { should eq "[MyTestClass]" }
      describe '#sign_message' do
        specify { subject.sign_message("this is a test").should eq "[MyTestClass] this is a test" }
        specify { subject.class.sign_message("this is a test").should eq "[MyTestClass] this is a test" }
      end

      it 'passes all embedded log calls to Logger instance' do
        Protobuf::Logger.instance.should_receive(:debug).with('[MyTestClass] log this')
        subject.log_debug('log this')
      end

    end
  end
end
