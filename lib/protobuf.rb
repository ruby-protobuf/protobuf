require 'logger'
require 'socket'
require 'pp'
require 'stringio'

module Protobuf
end

Protobuf::ClientType = ENV['PB_CLIENT_TYPE'] if ENV['PB_CLIENT_TYPE']
Protobuf::ServerType = ENV['PB_SERVER_TYPE'] if ENV['PB_SERVER_TYPE']

# When setting up a client
case
when defined?(Protobuf::ClientType) && Protobuf::ClientType == "Zmq" then 
  require 'ffi-rzmq'
  require 'protobuf/rpc/client'
  require 'protobuf/rpc/connectors/zmq'
else
  Protobuf::ClientType = "EventMachine"
  require 'eventmachine'
  require 'protobuf/ext/eventmachine'
  require 'protobuf/rpc/connectors/eventmachine'
end

# For running the rpc_server
case
when defined?(Protobuf::ServerType) && Protobuf::ServerType == "ZmqServer" then
  require 'ffi-rzmq'
  require 'protobuf/rpc/service'
  require 'protobuf/rpc/servers/zmq_server'
else
  Protobuf::ServerType = "EventedServer"
  require 'eventmachine'
  require 'protobuf/ext/eventmachine'
  require 'protobuf/rpc/servers/evented_server'
end

# Socket Client/Server loaded by default as it has no impact on cross-platform issues
require 'protobuf/rpc/service'
require 'protobuf/rpc/servers/socket_server'  

  require 'ffi-rzmq'
  require 'protobuf/rpc/client'
  require 'protobuf/rpc/connectors/zmq'

require 'protobuf/rpc/client'
require 'protobuf/rpc/connectors/socket'
