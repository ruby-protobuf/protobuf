require 'logger'
require 'socket'

module Protobuf
end

# When setting up a client
if defined?(Protobuf::ConnectorType) && Protobuf::ConnectorType == "Socket"
  require 'protobuf/rpc/client'
  require 'protobuf/rpc/connectors/socket'
else
  require 'eventmachine'
  require 'protobuf/ext/eventmachine'
  require 'protobuf/rpc/client'
  require 'protobuf/rpc/connectors/eventmachine'
end

# For running the rpc_server
if defined?(Protobuf::ServerType) && Protobuf::ServerType == "SocketServer"
  require 'protobuf/rpc/service'
  require 'protobuf/rpc/servers/socket_server'
else
  require 'eventmachine'
  require 'protobuf/ext/eventmachine'
  require 'protobuf/rpc/service'
  require 'protobuf/rpc/servers/evented_server'
end
