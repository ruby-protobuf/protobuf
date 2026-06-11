require 'protobuf/rpc/service'

module Protobuf
  module Rpc
    # Base class application services should inherit from. Mirrors the
    # `ApplicationController` pattern: a stable seam for shared filters,
    # callbacks, and helpers that belong to the host app rather than the gem.
    class ApplicationService < Service
    end
  end
end
