require 'spec_helper'

describe ::Protobuf::Rpc::Connectors::EMClient do
  describe '#send_data' do
    context 'when sending data errs' do
      let(:buffer_double) do
        bd = double(Protobuf::Rpc::Buffer)
        bd.should_receive(:set_data)
        bd
      end

      it 'sets the error instance' do
        buffer_double.should_receive(:write).and_raise(RuntimeError.new('Failure for testing'))
        Protobuf::Rpc::Buffer.stub(:new).with(:read).and_return(Protobuf::Rpc::Buffer.new(:read))
        Protobuf::Rpc::Buffer.stub(:new).with(:write).and_return(buffer_double)
        error = nil
        test_proc = Proc.new do
          StubServer.new do |server|
            client = ::Spec::Proto::TestService.client
            client.find(:name => 'Test Name', :active => true) do |c|
              c.on_failure do |f|
                error = f
              end
            end
          end
        end
        test_proc.call
        error.should_not be_nil
      end
    end
  end
end
