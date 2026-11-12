module Protobuf
  class Error < StandardError; end
  # Decode found bytes that are not a valid encoding, or input that is over a
  # decode limit. Rescue this class to catch every decode failure.
  class DecodeError < Error; end
  class InvalidWireType < DecodeError; end
  class DecodeDepthError < DecodeError; end
  class NotInitializedError < Error; end
  class TagCollisionError < Error; end
  class SerializationError < StandardError; end
  class FieldNotDefinedError < StandardError; end
  class DuplicateFieldNameError < StandardError; end
end
