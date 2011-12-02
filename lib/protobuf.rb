require 'socket'
require 'socketpool'
require 'eventmachine'
require 'protobuf/ext/eventmachine'

module Protobuf
end

require 'protobuf/rpc/client'
require 'protobuf/rpc/service'
require 'protobuf/rpc/servers/socket_server'
require 'protobuf/rpc/servers/evented_server'
