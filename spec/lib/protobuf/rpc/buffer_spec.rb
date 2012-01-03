require 'spec_helper'

describe Protobuf::Rpc::Buffer do
  subject { Protobuf::Rpc::Buffer.new }
  
  its(:data) { should be_a(String) }
  its(:mode) { should eq :read }
  its(:flushed?) { should be_false }
  
  describe '#mode=' do
    it 'allows setting mode to :write' do
      subject.mode = :write
      subject.mode.should eq :write
    end
    
    it 'allows setting mode to :read' do
      subject.mode = :read
      subject.mode.should eq :read
    end
    
    it 'sets mode to :read if unknown mode passed' do
      subject.mode = :blue
      subject.mode.should eq :read
    end
  end
  
  describe '#<<' do
    it 'appends given string to @data' do
      subject << 'the'
      subject << 'quick'
      subject << 'brown'
      subject << 'fox'
      subject.data.should eq 'thequickbrownfox'
    end
    
    context 'when in read mode' do
      it 'reads the size from @data if present' do
        subject.mode.should eq :read
        subject.size.should be_nil
        subject << '3'
        subject.size.should be_nil
        subject << '-the'
        subject.size.should eq 3
      end
      
      it 'sets the flushed flag when the given size' do
        subject.mode.should eq :read
        subject.flushed?.should be_false
        subject << '3-the'
        subject.flushed?.should be_true
      end
    end
  end
  
  describe '#write' do
    it 'writes the data prepended with the byte-length' do
      subject << 'hello'
      subject.write(true).should eq '5-hello'
    end
  end
  
  describe 'mode predicate methods' do
    context 'when in read mode' do
      subject { Protobuf::Rpc::Buffer.new(:read) }
      its(:reading?) { should be_true }
      its(:writing?) { should be_false }
    end
    context 'when in write mode' do
      subject { Protobuf::Rpc::Buffer.new(:write) }
      its(:reading?) { should be_false }
      its(:writing?) { should be_true }
    end
  end
  
end