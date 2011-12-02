require 'protobuf/rpc/connectors/eventmachine'
require 'protobuf/rpc/connectors/socket'

module Protobuf
  module Rpc
    class Connector
      
      def self.connector_for_platform platform=RUBY_ENGINE
        case platform
        when /jruby/i
          Connectors::Socket
        else
          Connectors::EventMachine
        end
      end
      
    end
  end
end