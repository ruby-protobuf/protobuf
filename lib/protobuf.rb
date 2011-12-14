require 'logger'
require 'socket'
require 'pp'
require 'stringio'

module Protobuf
end

# When setting up a client
unless defined?(Protobuf::ConnectorType) && Protobuf::ConnectorType == "Socket"
  Protobuf::ConnectorType = "EventMachine"
  require 'eventmachine'
  require 'protobuf/ext/eventmachine'
  require 'protobuf/rpc/connectors/eventmachine'
end

# For running the rpc_server
unless defined?(Protobuf::ServerType) && Protobuf::ServerType == "SocketServer"
  Protobuf::ServerType = "EventedServer"
  require 'eventmachine'
  require 'protobuf/ext/eventmachine'
  require 'protobuf/rpc/servers/evented_server'
end

require 'protobuf/rpc/client'
require 'protobuf/rpc/connectors/socket'
require 'protobuf/rpc/service'
require 'protobuf/rpc/servers/socket_server'
