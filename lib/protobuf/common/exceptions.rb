module Protobuf

  class Error < StandardError; end

  class InvalidWireType < Error; end

  class NotInitializedError < Error; end

  class TagCollisionError < Error; end

end
