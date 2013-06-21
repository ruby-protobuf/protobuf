require 'timeout'
require 'protobuf/logger'
require 'protobuf/rpc/rpc.pb'
require 'protobuf/rpc/buffer'
require 'protobuf/rpc/error'
require 'protobuf/rpc/stat'
require 'protobuf/rpc/connectors/common'

module Protobuf
  module Rpc
    module Connectors
      DEFAULT_OPTIONS = {
        :service        => nil,           # Fully-qualified Service class
        :method         => nil,           # Service method to invoke
        :host           => '127.0.0.1',   # The hostname or address of the service (usually overridden or pre-configured)
        :port           => '9399',        # The port of the service (usually overridden or pre-configured)
        :request        => nil,           # The request object sent by the client
        :request_type   => nil,           # The request type expected by the client
        :response_type  => nil,           # The response type expected by the client
        :timeout        => 300,           # The default timeout for the request, also handled by client.rb
        :client_host    => nil            # The hostname or address of this client
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
      end
    end
  end
end
