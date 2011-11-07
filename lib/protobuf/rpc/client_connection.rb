require 'eventmachine'
require 'protobuf/common/logger'
require 'protobuf/rpc/rpc.pb'
require 'protobuf/rpc/buffer'
require 'protobuf/rpc/error'
require 'protobuf/rpc/stat'

# Handles client connections to the server
module Protobuf
  module Rpc
    ClientError = Struct.new("ClientError", :code, :message)
    
    class ClientConnection < EM::Connection
      include Protobuf::Logger::LogMethods
      
      attr_reader :options, :request, :response
      attr_reader :error, :error_reason, :error_message

      DEFAULT_OPTIONS = {
        :service        => nil,           # Service to invoke
        :method         => nil,           # Service method to call
        :host           => 'localhost',   # A default host (usually overridden)
        :port           => '9938',        # A default port (usually overridden)
        :request        => nil,           # The request object sent by the client
        :request_type   => nil,           # The request type expected by the client
        :response_type  => nil,           # The response type expected by the client
        :async          => false,         # Whether or not to block a client call, this is actually handled by client.rb
        :timeout        => 30             # The default timeout for the request, also handled by client.rb
      }
      
      # For state tracking
      STATES = {
        :pending    => 0,
        :succeeded  => 1,
        :failed     => 2,
        :completed  => 3
      }
      
      def self.connect options={}
        options = DEFAULT_OPTIONS.merge(options)
        Protobuf::Logger.debug '[client-cnxn] Connecting to server: %s' % options.inspect
        host = options[:host]
        port = options[:port]
        EventMachine.connect host, port, self, options
      end
      
      def initialize options={}, &failure_callback
        @failure_callback = failure_callback
        
        # Verify the options that are necessary and merge them in
        [:service, :method, :host, :port].each do |opt|
          fail(:RPC_ERROR, "Invalid client connection configuration. #{opt} must be a defined option.") if !options[opt] || options[opt].nil?
        end
        @options = DEFAULT_OPTIONS.merge(options)
        log_debug '[client-cnxn] Client Initialized: %s' % options.inspect
        
        @error = ClientError.new
        @success_callback = nil
        @state = STATES[:pending]
        
        @stats = Protobuf::Rpc::Stat.new(:CLIENT, true)
        @stats.server = [@options[:port], @options[:host]]
        @stats.service = @options[:service].name
        @stats.method = @options[:method]
      rescue
        fail(:RPC_ERROR, 'Failed to initialize connection: %s' % $!.message) unless failed?
      end

      # Success callback registration
      def on_success &success_callback
        @success_callback = success_callback
      end
      
      # Failure callback registration
      def on_failure &failure_callback
        @failure_callback = failure_callback
      end
      
      # Completion callback registration
      def on_complete &complete_callback
        @complete_callback = complete_callback
      end
      
      # Called after the EM.connect
      def connection_completed
        log_debug '[client-cnxn] Established server connection, sending request'
        send_request unless error?
      rescue
        fail(:RPC_ERROR, 'Connection error: %s' % $!.message) unless failed?
      end
      
      # Setup the read buffer for data coming back
      def post_init
        log_debug '[client-cnxn] Post init, new read buffer created'
        @buffer = Protobuf::Rpc::Buffer.new :read
      rescue
        fail(:RPC_ERROR, 'Connection error: %s' % $!.message) unless failed?
      end
      
      def receive_data data
        log_debug '[client-cnxn] receive_data: %s' % data
        @buffer << data
        parse_response if @buffer.flushed?
      end
    
      def pending?
        @state == STATES[:pending]
      end
    
      def succeeded?
        @state == STATES[:succeeded]
      end
    
      def failed?
        @state == STATES[:failed]
      end
    
      def completed?
        @state == STATES[:completed]
      end
      
    private
    
      # Sends the request to the server, invoked by the connection_completed event
      def send_request
        request_wrapper = Protobuf::Socketrpc::Request.new
        request_wrapper.service_name = @options[:service].name
        request_wrapper.method_name = @options[:method].to_s
        
        if @options[:request].class == @options[:request_type]
          request_wrapper.request_proto = @options[:request].serialize_to_string
        else
          expected = @options[:request_type].name
          actual = @options[:request].class.name
          fail :INVALID_REQUEST_PROTO, 'Expected request type to be type of %s, got %s instead' % [expected, actual]
        end
        
        log_debug '[client-cnxn] Sending Request: %s' % request_wrapper.inspect
        request_buffer = Protobuf::Rpc::Buffer.new(:write, request_wrapper)
        send_data(request_buffer.write)
        @stats.request_size = request_buffer.size
      end
      
      def parse_response
        # Close up the connection as we no longer need it
        close_connection
        
        log_debug '[client-cnxn] Parsing response from server (connection closed)'
        @stats.response_size = @buffer.size
        
        # Parse out the raw response
        response_wrapper = Protobuf::Socketrpc::Response.new
        response_wrapper.parse_from_string @buffer.data
        
        # Determine success or failure based on parsed data
        if response_wrapper.has_field? :error_reason
          log_debug '[client-cnxn] Error response parsed'
          
          # fail the call if we already know the client is failed
          # (don't try to parse out the response payload)
          fail response_wrapper.error_reason, response_wrapper.error
        else
          log_debug '[client-cnxn] Successful response parsed'
          
          # Ensure client_response is an instance
          response_type = @options[:response_type].new
          parsed = response_type.parse_from_string(response_wrapper.response_proto.to_s)
      
          if parsed.nil? and not response_wrapper.has_field?(:error_reason)
            fail :BAD_RESPONSE_PROTO, 'Unable to parse response from server'
          else
            succeed parsed
          end
        end
      end
      
      def fail code, message
        @state = STATES[:failed]
        @error.code = code.is_a?(Symbol) ? Protobuf::Socketrpc::ErrorReason.values[code] : code
        @error.message = message
        log_debug '[client-cnxn] Server failed request (invoking on_failure): %s' % @error.inspect
        begin
          @stats.end
          @stats.log_stats
          @failure_callback.call(@error) unless @failure_callback.nil?
        rescue
          log_error '[client-cnxn] Failure callback error encountered: %s' % $!.message
          log_error '[client-cnxn] %s' % $!.backtrace.join("\n")
          raise
        ensure
          complete
        end
      end
      
      def succeed response
        @state = STATES[:succeeded]
        begin
          log_debug '[client-cnxn] Server succeeded request (invoking on_success)'
          @stats.end
          @stats.log_stats
          @success_callback.call(response) unless @success_callback.nil?
          complete
        rescue
          log_error '[client-cnxn] Success callback error encountered: %s' % $!.message
          log_error '[client-cnxn] %s' % $!.backtrace.join("\n")
          fail :RPC_ERROR, 'An exception occurred while calling on_success: %s' % $!.message
        end
      end
      
      def complete
        @state = STATES[:completed]
        begin
          log_debug '[client-cnxn] Response proceessing complete'
          @success_callback = @failure_callback = nil
          @complete_callback.call(@state) unless @complete_callback.nil?
        rescue
          log_error '[client-cnxn] Complete callback error encountered: %s' % $!.message
          log_error '[client-cnxn] %s' % $!.backtrace.join("\n")
          raise
        end
      end
  
    end
  end
end