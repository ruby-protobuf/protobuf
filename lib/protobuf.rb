require 'logger'
require 'socket'
require 'socketpool'

module Protobuf
end

if defined?(Protobuf::ServerType) && Protobuf::ServerType == "SocketServer"
  require 'protobuf/rpc/client'
  require 'protobuf/rpc/service'
  require 'protobuf/rpc/servers/socket_server'
else
  require 'eventmachine'
  require 'protobuf/ext/eventmachine'
  require 'protobuf/rpc/client'
  require 'protobuf/rpc/service'
  require 'protobuf/rpc/servers/evented_server'
end
