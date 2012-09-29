require 'logger'
require 'socket'
require 'pp'
require 'stringio'
require 'active_support/all'

module Protobuf
end

Protobuf::ClientType = ENV['PB_CLIENT_TYPE'] if ENV['PB_CLIENT_TYPE']
Protobuf::ServerType = ENV['PB_SERVER_TYPE'] if ENV['PB_SERVER_TYPE']

# Socket Client/Server loaded by default as it has no impact on cross-platform issues
require 'protobuf/rpc/servers/socket/server'
require 'protobuf/rpc/connectors/socket'
require 'protobuf/rpc/client'
require 'protobuf/rpc/service'

# When setting up a client
case
when defined?(Protobuf::ClientType) && Protobuf::ClientType =~ /\Asocket\Z/i then
  #no-op
when defined?(Protobuf::ClientType) && Protobuf::ClientType =~ /\Azmq\Z/i then
  require 'ffi-rzmq'
  require 'protobuf/rpc/connectors/zmq'
else
  Protobuf::ClientType = "EventMachine"
  require 'eventmachine'
  require 'protobuf/ext/eventmachine'
  require 'protobuf/rpc/connectors/eventmachine'
end

# For running the rpc_server
case
when defined?(Protobuf::ServerType) && Protobuf::ServerType =~ /\Asocket\Z/i then
  #no-op
when defined?(Protobuf::ServerType) && Protobuf::ServerType =~ /\Azmq\Z/i then
  require 'ffi-rzmq'
  require 'protobuf/rpc/servers/zmq/server'
else
  Protobuf::ServerType = "Evented::Server"
  require 'eventmachine'
  require 'protobuf/ext/eventmachine'
  require 'protobuf/rpc/servers/evented/server'
end
