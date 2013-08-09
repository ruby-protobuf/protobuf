require ::File.expand_path('../resource.pb', __FILE__)

module Test
  class ResourceService

    # request -> Test::ResourceFindRequest
    # response -> Test::Resource
    def find
      response.name = request.name
      response.status = request.active ? 1 : 0
    end

    # request -> Test::ResourceSleepRequest
    # response -> Test::Resource
    def find_with_sleep
      sleep (request.sleep || 1)
      response.name = 'Request should have timed out'
    end

  end
end
