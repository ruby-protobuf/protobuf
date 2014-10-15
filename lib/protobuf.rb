require 'logger'
require 'socket'
require 'pp'
require 'stringio'

require 'active_support/core_ext/object/blank'
require 'active_support/core_ext/object/try'
require 'active_support/notifications'
require 'active_support/inflector'
require 'active_support/json'

module Protobuf

  # See Protobuf#connector_type documentation.
  CONNECTORS = [ :socket, :zmq ].freeze

  # Default is Socket as it has no external dependencies.
  DEFAULT_CONNECTOR = :socket

  module_function

  class << self
    # Client Host
    #
    # Default: `hostname` of the system
    #
    # The name or address of the host to use during client RPC calls.
    attr_accessor :client_host
  end

  self.client_host = Socket.gethostname

  # Connector Type
  #
  # Default: socket
  #
  # Symbol value which denotes the type of connector to use
  # during client requests to an RPC server.
  def self.connector_type
    @connector_type ||= DEFAULT_CONNECTOR
  end

  def self.connector_type=(type)
    raise ArgumentError, 'Invalid connector type given' unless CONNECTORS.include?(type)
    @connector_type = type
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
    return @gc_pause_server_request unless @gc_pause_server_request.nil?
    self.gc_pause_server_request = false
  end

  def self.gc_pause_server_request=(value)
    @gc_pause_server_request = !!value
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
    return @print_deprecation_warnings unless @print_deprecation_warnings.nil?
    self.print_deprecation_warnings = ENV.key?('PB_IGNORE_DEPRECATIONS') ? false : true
  end

  def self.print_deprecation_warnings=(value)
    @print_deprecation_warnings = !!value
  end

  # Permit unknown field on Message initialization
  #
  # Default: true
  #
  # Simple boolean to define whether we want to permit unknown fields
  # on Message intialization; otherwise a ::Protobuf::FieldNotDefinedError is thrown.
  def self.ignore_unknown_fields?
    !defined?(@ignore_unknown_fields) || @ignore_unknown_fields
  end

  def self.ignore_unknown_fields=(value)
    @ignore_unknown_fields = !!value
  end
end

unless ENV.key?('PB_NO_NETWORKING')
  require 'protobuf/rpc/client'
  require 'protobuf/rpc/service'

  env_connector_type = ENV.fetch('PB_CLIENT_TYPE') do
    ::Protobuf::DEFAULT_CONNECTOR
  end.to_s.downcase.strip.to_sym

  if ::Protobuf::CONNECTORS.include?(env_connector_type)
    require "protobuf/#{env_connector_type}"
  else
    $stderr.puts <<-WARN
    [WARNING] Require attempted on an invalid connector type '#{env_connector_type}'.
              Falling back to default '#{::Protobuf::DEFAULT_CONNECTOR}' connector.
    WARN

    require "protobuf/#{::Protobuf::DEFAULT_CONNECTOR}"
  end
end
