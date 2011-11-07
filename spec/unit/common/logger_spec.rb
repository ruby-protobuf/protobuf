require 'protobuf/common/logger'
require 'stringio'

describe Protobuf::Logger do
  
  subject { Protobuf::Logger }
  
  before(:each) do
    Protobuf::Logger.reset_device!
    Protobuf::Logger.file = '/dev/null'
    Protobuf::Logger.level = ::Logger::INFO
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
      }.should_not raise_error
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
      
      it 'responds to all logger methods' do
        subject.should respond_to :log_debug
        subject.should respond_to :log_info
        subject.should respond_to :log_warn
        subject.should respond_to :log_error
        subject.should respond_to :log_fatal
        subject.should respond_to :log_add
        subject.should respond_to :log_log
      end
      
      it 'passes all embedded log calls to Logger instance' do
        Protobuf::Logger.instance.should_receive(:debug).with('log this')
        subject.log_debug('log this')
      end
      
    end
    
  end
  
end