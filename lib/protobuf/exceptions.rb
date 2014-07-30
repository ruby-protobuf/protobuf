module Protobuf
  class Error < StandardError; end
  class InvalidWireType < Error; end
  class NotInitializedError < Error; end
  class TagCollisionError < Error; end
  class SerializationError < Error; end
  class FieldNotDefinedError < Error; end
  class DuplicateFieldNameError < Error; end
end
