require 'protobuf/rpc/service'
require File.dirname(__FILE__) + '/test.pb'
require File.dirname(__FILE__) + '/test_service'

module Spec
  module Proto
    class TestService
    
      # request -> Spec::Proto::ResourceFindRequest
      # response -> Spec::Proto::Resource
      def find
        response.name = request.name
        response.status = request.active ? 1 : 0
      end
    
    end
  end
end
