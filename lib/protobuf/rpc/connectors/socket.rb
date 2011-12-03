require 'protobuf/rpc/connectors/base'

module Protobuf
  module Rpc
    module Connectors
      class Socket < Base
        
        def send_request
          check_async
          connect_to_rpc_server
        end

        private

        def check_async
          raise "Cannot use Socket client in async mode" if async?
        end

        def connect_to_rpc_server
          @socket = TCPSocket.new(options[:host], options[:port])

        end
        
      end
    end
  end
end
