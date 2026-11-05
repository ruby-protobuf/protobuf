require 'protobuf/rpc/service'

module Protobuf
  module Rpc
    # Base class for application services, like `ApplicationController`.
    # Filters and `rescue_from` handlers defined here pass to every subclass.
    # Generate services with `PB_SERVICE_PARENT=::Protobuf::Rpc::ApplicationService`
    # to inherit from it.
    class ApplicationService < Service
    end
  end
end
