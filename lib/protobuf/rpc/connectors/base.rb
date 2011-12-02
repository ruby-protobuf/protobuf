require 'protobuf/common/logger'

module Protobuf
  module Rpc
    module Connectors
      class Base
        include Protobuf::Logger::LogMethods
        
        attr_reader :options
        attr_accessor :success_cb, :failure_cb
        
        def initialize options
          @options = options
          @success_cb = nil
          @failure_cb = nil
        end
        
        def send_request
          raise 'not implemented'
        end
        
        def async?
          !!@options[:async]
        end
        
      end
    end
  end
end