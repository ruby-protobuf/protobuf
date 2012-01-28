require 'protobuf/common/logger'
require 'protobuf/rpc/rpc.pb'
require 'protobuf/rpc/buffer'
require 'protobuf/rpc/error'
require 'protobuf/rpc/stat'
require 'protobuf/rpc/connectors/common'

module Protobuf
  module Rpc
    module Connectors
      DEFAULT_OPTIONS = {
        :service        => nil,           # Service to invoke
        :method         => nil,           # Service method to call
        :host           => '127.0.0.1',   # A default host (usually overridden)
        :port           => '9399',        # A default port (usually overridden)
        :request        => nil,           # The request object sent by the client
        :request_type   => nil,           # The request type expected by the client
        :response_type  => nil,           # The response type expected by the client
        :async          => false,         # Whether or not to block a client call, this is actually handled by client.rb
        :timeout        => 30             # The default timeout for the request, also handled by client.rb
      }

      class Base
        include Protobuf::Logger::LogMethods
        
        attr_reader :options
        attr_accessor :success_cb, :failure_cb, :complete_cb

        def initialize(options)
          @options = DEFAULT_OPTIONS.merge(options)
        end
        
        def send_request
          raise 'If you inherit a Connector from Base you must implement send_request'
        end
        
        def async?
          !!@options[:async]
        end
        
      end
    end
  end
end
