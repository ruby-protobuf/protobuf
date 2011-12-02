require 'spec_helper'
require 'protobuf/rpc/server'
require 'spec/proto/test_service_impl'

describe Protobuf::Rpc::Server do
  context 'when sending response objects' do
    it 'should be able to send a hash object as a response' do
      server = Protobuf::Rpc::Server.new
      
      # Setup the right mocks
      server.instance_variable_set(:@klass, Spec::Proto::TestService)
      response_wrapper = mock('response')
      response_wrapper.stub(:response_proto=)
      server.instance_variable_set(:@response, response_wrapper)
      Spec::Proto::TestService.stub_chain(:rpcs, :[], :[], :response_type).and_return(Spec::Proto::ResourceFindRequest)
      
      # Setup expectations
      hash_response = {:name => 'Test Name', :active => false}
      expected = Spec::Proto::ResourceFindRequest.new(hash_response)
      Spec::Proto::ResourceFindRequest.should_receive(:new).with(hash_response).and_return(expected)
      server.should_not_receive(:handle_error)
      
      # Call the method
      server.send(:parse_response_from_service, hash_response)
    end
  end
end