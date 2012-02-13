require 'spec_helper'

describe Protobuf::Util do
  
  describe '.underscore' do
    it 'underscores constant name' do
      Protobuf::Util.underscore("HelloMoto").should eq "hello_moto"
    end
    
    context 'when constant name has uppercased word' do
      it 'keeps the uppercased word together' do
        Protobuf::Util.underscore("UPPERCase").should eq "upper_case"
        Protobuf::Util.underscore("MDXService").should eq "mdx_service"
      end
    end
  end
end