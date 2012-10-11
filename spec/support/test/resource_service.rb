require ::File.expand_path('../resource.pb', __FILE__)

module Test
  class ResourceService

    # request -> Test::ResourceFindRequest
    # response -> Test::Resource
    def find(request, response)
      response.name = request.name
      response.status = request.active ? 1 : 0
      return response
    end

  end
end
