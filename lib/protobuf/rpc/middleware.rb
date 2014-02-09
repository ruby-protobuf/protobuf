require 'middleware'

require 'protobuf/rpc/middleware/request_decoder'
require 'protobuf/rpc/middleware/response_encoder'
require 'protobuf/rpc/middleware/runner'

module Protobuf
  module Rpc
    def self.middleware
      @middleware ||= ::Middleware::Builder.new(:runner_class => ::Protobuf::Rpc::Middleware::Runner)
    end

    # Ensure the middleware stack is initialized
    middleware
  end

  Rpc.middleware.use(Rpc::Middleware::RequestDecoder)
  Rpc.middleware.use(Rpc::Middleware::ResponseEncoder)
end
