require 'logger'
require 'socket'
require 'pp'
require 'stringio'

module Protobuf
end


Protobuf::ClientType = ENV['PB_CLIENT_TYPE'] if ENV['PB_CLIENT_TYPE']
Protobuf::ServerType = ENV['PB_SERVER_TYPE'] if ENV['PB_SERVER_TYPE']

# When setting up a client
unless defined?(Protobuf::ClientType) && Protobuf::ClientType == "Socket"
  Protobuf::ClientType = "EventMachine"
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
