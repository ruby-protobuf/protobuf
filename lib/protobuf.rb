require 'logger'
require 'socket'
require 'pp'
require 'stringio'
require 'active_support/all'

module Protobuf

  # See Protobuf#connector_type documentation.
  VALID_CONNECTOR_TYPES = [ :socket, :zmq, :evented ].freeze

  # Default is Socket as it has no external dependencies.
  DEFAULT_CONNECTOR_TYPE = :socket

	module_function

  # GC Pause during server requests
  #
  # Boolean value to tell the server to disable
  # the Garbage Collector when handling an rpc request.
  # Once the request is completed, the GC is enabled again.
  # This optomization provides a huge boost in speed to rpc requests.
	def self.gc_pause_server_request
		return @_gc_pause_server_request unless @_gc_pause_server_request.nil?
		gc_pause_server_request = false
	end

	def self.gc_pause_server_request=(value)
		@_gc_pause_server_request = !!value
	end

  # GC Pause during serializations (server-side only)
  #
  # Boolean value to tell the server to disable
  # the Garbage Collector when serializing a response proto.
  # Once the serialization is completed, the GC is enabled again.
  # This optomization provides a large boost in speed to rpc requests.
  # Note that this option is ignored if gc_pause_server_request is
  # enabled since serialization is during the request cycle.
	def self.gc_pause_server_serialization
		return @_gc_pause_server_serialization unless @_gc_pause_server_serialization.nil?
		gc_pause_server_serialization = false
	end

	def self.gc_pause_server_serialization=(value)
		@_gc_pause_server_serialization = !!value
	end

  # Connector Type
  #
  # Symbol value which denotes the type of connector to use
  # during client requests to an RPC server.
  def self.connector_type
    @_connector_type ||= DEFAULT_CONNECTOR_TYPE
  end

  def self.connector_type=(type)
    raise 'Invalid connector type given' unless VALID_CONNECTOR_TYPES.include?(type)
    @_connector_type = type
  end

end

require 'protobuf/rpc/client'
require 'protobuf/rpc/service'
require 'protobuf/socket'
