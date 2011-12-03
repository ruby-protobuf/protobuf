require 'protobuf/rpc/connectors/base'

module Protobuf
  module Rpc
    module Connectors
      class Socket < Base
        include Protobuf::Rpc::Connectors::Common
        
        def send_request
          post_init
          check_async
          connect_to_rpc_server
        end

        private

        def send_data(data)
        end

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
