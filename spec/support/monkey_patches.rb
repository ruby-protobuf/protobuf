require 'protobuf/message'
require 'protobuf/enum'

module Protobuf
  class Message
    def self.reset_cached_variables!
      @all_fields = nil
      @extension_fields = nil
      @fields = nil
    end
  end

  class Enum
    def self.reset_cached_variables!
      @values = nil
      @mapped_enums = nil
    end
  end
end
