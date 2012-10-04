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

  # Connector Type
  #
  # Default: socket
  #
  # Symbol value which denotes the type of connector to use
  # during client requests to an RPC server.
  def self.connector_type
    @_connector_type ||= DEFAULT_CONNECTOR_TYPE
  end

  def self.connector_type=(type)
    raise ArgumentError, 'Invalid connector type given' unless VALID_CONNECTOR_TYPES.include?(type)
    @_connector_type = type
  end


  # GC Pause during server requests
  #
  # Default: false
  #
  # Boolean value to tell the server to disable
  # the Garbage Collector when handling an rpc request.
  # Once the request is completed, the GC is enabled again.
  # This optomization provides a huge boost in speed to rpc requests.
	def self.gc_pause_server_request?
		return @_gc_pause_server_request unless @_gc_pause_server_request.nil?
		gc_pause_server_request = false
	end

	def self.gc_pause_server_request=(value)
		@_gc_pause_server_request = !!value
	end

  # Print Deprecation Warnings
  #
  # Default: true
  #
  # Simple boolean to define whether we want field deprecation warnings to
  # be printed to stderr or not. The rpc_server has an option to set this value
  # explicitly, or you can turn this option off by setting
  # ENV['PB_IGNORE_DEPRECATIONS'] to a non-empty value.
  #
  # The rpc_server option will override the ENV setting.
	def self.print_deprecation_warnings?
		return @_print_deprecation_warnings unless @_print_deprecation_warnings.nil?
		print_deprecation_warnings = ENV.key?('PB_IGNORE_DEPRECATIONS') ? false : true
	end

	def self.print_deprecation_warnings=(value)
		@_print_deprecation_warnings = !!value
	end

end

require 'protobuf/rpc/client'
require 'protobuf/rpc/service'
require 'protobuf/socket'
