require 'protobuf/common/logger'

module Protobuf
  module Rpc
    module Connectors
      DEFAULT_OPTIONS = {
        :service        => nil,           # Service to invoke
        :method         => nil,           # Service method to call
        :host           => 'localhost',   # A default host (usually overridden)
        :port           => '9938',        # A default port (usually overridden)
        :request        => nil,           # The request object sent by the client
        :request_type   => nil,           # The request type expected by the client
        :response_type  => nil,           # The response type expected by the client
        :async          => false,         # Whether or not to block a client call, this is actually handled by client.rb
        :timeout        => 30             # The default timeout for the request, also handled by client.rb
      }

      class Base
        include Protobuf::Logger::LogMethods
        
        attr_reader :options
        attr_accessor :success_cb, :failure_cb

        def initialize(options)
          @options = DEFAULT_OPTIONS.merge(options)
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
