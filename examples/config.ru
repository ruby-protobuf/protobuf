require "protobuf"
require "protobuf/rpc/servers/http/server"

require_relative "lib/example/reverse-service"

run Protobuf::Rpc::Http::Server.new
