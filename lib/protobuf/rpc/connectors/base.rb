require 'timeout'
require 'protobuf/logging'
require 'protobuf/rpc/rpc.pb'
require 'protobuf/rpc/buffer'
require 'protobuf/rpc/error'
require 'protobuf/rpc/stat'
require 'protobuf/rpc/connectors/common'

module Protobuf
  module Rpc
    module Connectors
      DEFAULT_OPTIONS = {
        :service                 => nil,         # Fully-qualified Service class
        :method                  => nil,         # Service method to invoke
        :host                    => '127.0.0.1', # The hostname or address of the service (usually overridden)
        :port                    => '9399',      # The port of the service (usually overridden or pre-configured)
        :request                 => nil,         # The request object sent by the client
        :request_type            => nil,         # The request type expected by the client
        :response_type           => nil,         # The response type expected by the client
        :timeout                 => nil,         # The timeout for the request, also handled by client.rb
        :client_host             => nil,         # The hostname or address of this client
        :first_alive_load_balance => false,      # Do we want to use check_avail frames before request
      }

      class Base
        include Protobuf::Logging

        attr_reader :options
        attr_accessor :success_cb, :failure_cb, :complete_cb

        def initialize(options)
          @options = DEFAULT_OPTIONS.merge(options)
          @stats = ::Protobuf::Rpc::Stat.new(:CLIENT)
        end

        def first_alive_load_balance?
          ENV.key?("PB_FIRST_ALIVE_LOAD_BALANCE") ||
            options[:first_alive_load_balance]
        end

        def send_request
          fail 'If you inherit a Connector from Base you must implement send_request'
        end

        def ping_port
          @ping_port ||= ENV["PB_RPC_PING_PORT"]
        end

        def ping_port_enabled?
          ENV.key?("PB_RPC_PING_PORT")
        end
      end
    end
  end
end
