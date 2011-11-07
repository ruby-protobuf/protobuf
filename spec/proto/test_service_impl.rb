require 'spec/proto/test_service'

module Spec
  module Proto
    class TestService
      located_at "localhost:9191"
    
      # request -> Spec::Proto::ResourceFindRequest
      # response -> Spec::Proto::Resource
      def find
        response.name = request.name
        response.status = request.active ? 1 : 0
      end
    
    end
  end
end