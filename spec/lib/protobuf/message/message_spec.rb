require 'spec_helper'
require 'spec/proto/test.pb'

describe Protobuf::Message do
  
  context 'when converting to json' do
    
    it "should be jsonable" do
      msg = Spec::Proto::ResourceFindRequest.new
      msg.should respond_to(:to_json)
      msg.name = 'Jeff'
      msg.active = false
      msg.to_json.should == '{"name":"Jeff","active":false}'
    end
    
    it 'should generate nested messages into nested json objects' do
      date_created = Time.now.to_i
      
      nested = Spec::Proto::Nested.new
      nested.name = 'NESTED'
      nested.resource = Spec::Proto::Resource.new.tap do |r|
        r.name = 'RESOURCE SINGLE'
        r.date_created = date_created
        r.status = Spec::Proto::StatusType::PENDING
      end
      2.times do |i|
        nested.multiple_resources << Spec::Proto::Resource.new.tap do |r|
          r.name = 'RESOURCE MULTIPLE %d' % i
          r.date_created = date_created
          r.status = Spec::Proto::StatusType::PENDING
        end
      end
      nested.status = Spec::Proto::StatusType::ENABLED
      
      nested.to_json.should == %Q{{"name":"NESTED","resource":{"name":"RESOURCE SINGLE","date_created":#{date_created},"status":0,"repeated_enum":[]},"multiple_resources":[{"name":"RESOURCE MULTIPLE 0","date_created":#{date_created},"status":0,"repeated_enum":[]},{"name":"RESOURCE MULTIPLE 1","date_created":#{date_created},"status":0,"repeated_enum":[]}],"status":1}}
    end
    
    
  end
  
  context 'when converting to a hash' do
    
    context 'when message has repeated enum field' do
      
      it 'provides an array of integers' do
        resource = Spec::Proto::Resource.new :repeated_enum => [
          Spec::Proto::StatusType::PENDING,
          Spec::Proto::StatusType::ENABLED,
          Spec::Proto::StatusType::ENABLED,
          Spec::Proto::StatusType::DISABLED,
          Spec::Proto::StatusType::DELETED
        ]
        
        resource.to_hash[:repeated_enum].should == [
          Spec::Proto::StatusType::PENDING.value,
          Spec::Proto::StatusType::ENABLED.value,
          Spec::Proto::StatusType::ENABLED.value,
          Spec::Proto::StatusType::DISABLED.value,
          Spec::Proto::StatusType::DELETED.value
        ]
      end
      
    end
    
  end
  
end