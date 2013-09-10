##
## Evented Mode
##
#
# Require this file if you wish to run your server and/or client RPC
# with the evented handlers via EventMachine.
#
# To run with rpc_server specify the switch `evented`:
#
#   rpc_server --evented myapp.rb
#
# To run for client-side only override the require in your Gemfile:
#
#   gem 'protobuf', :require => 'protobuf/evented'
#
$stderr.puts <<-WARN
  [DEPRECATED] You are using the evented connector and/or server which has been deprecated.
               Versions >= 3.0 will no longer provide the evented module for clients
               and servers. You should upgrade to the socket or zmq transport configurations.

               To upgrade your rpc_server, simply replace `--evented` option
               with `--socket` or `--zmq`. If you are using the `PB_CLIENT_TYPE`
               env variable, simply assign it to socket or zmq.

               If you are requiring the gem in your gemfile expclitly, change
               the require to match your chosen transport type:

                  `gem 'protobuf', :require => 'protobuf/socket'`
WARN

require 'protobuf'
Protobuf.connector_type = :evented

require 'eventmachine'
require 'protobuf/ext/eventmachine'
require 'protobuf/rpc/servers/evented/server'
require 'protobuf/rpc/connectors/eventmachine'
