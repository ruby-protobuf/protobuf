##
## HTTP Mode
##
#
# Require this file if you wish to run your server and/or client RPC
# with the HTTP handlers.
#
# To run with rpc_server specify the switch `http`:
#
#   rpc_server --http myapp.rb
#
# To run for client-side only override the require in your Gemfile:
#
#   gem 'protobuf', :require => 'protobuf/http'
#
require 'protobuf'
Protobuf.connector_type = :http

require 'protobuf/rpc/servers/http/server'
require 'protobuf/rpc/connectors/http'
