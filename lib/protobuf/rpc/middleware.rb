require 'middleware'

require 'protobuf/rpc/middleware/runner'

module Protobuf
  module Rpc
    def self.middleware
      @middleware ||= ::Middleware::Builder.new(:runner_class => ::Protobuf::Rpc::Middleware::Runner)
    end

    # Ensure the middleware stack is initialized
    middleware
  end
end
