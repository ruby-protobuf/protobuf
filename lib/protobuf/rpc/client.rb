require 'eventmachine'
require 'protobuf/common/logger'
require 'protobuf/rpc/client_connection'
require 'protobuf/rpc/buffer'
require 'protobuf/rpc/error'
require 'timeout'

module Protobuf
  module Rpc
    class Client
      include Protobuf::Logger::LogMethods
      
      attr_reader :error, :options, :do_block
      
      # Create a new client with default options (defined in ClientConnection)
      # See Service#client for a more convenient way to create a client, as well
      # as Client#method_missing defined below.
      # 
      #   request = WidgetFindRequest.new
      #   client = Client.new({
      #     :service => WidgetService,
      #     :method => "find",
      #     :request_type => "WidgetFindRequest",
      #     :response_type => "WidgetList",
      #     :request => request
      #   })
      #
      def initialize options={}
        raise "Invalid client configuration. Service must be defined." if !options[:service] || options[:service].nil?
        @error = {}
        @options = ClientConnection::DEFAULT_OPTIONS.merge(options)
        @success_callback = nil
        @failure_callback = nil
        @do_block = !@options[:async]
        log_debug '[client] Initialized with options: %s' % @options.inspect
      end
      
      # Set a success callback on the client to return the
      # successful response from the service when it is returned.
      # If this callback is called, failure_callback will NOT be called.
      # Callback is called regardless of :async setting.
      # 
      #   Client(:service => WidgetService).new.find do |c|
      #     c.on_success {|res| ... }
      #   end
      # 
      def on_success &success_callback
        @success_callback = success_callback
      end
      
      # Set a failure callback on the client to return the
      # error returned by the service, if any. If this callback
      # is called, success_callback will NOT be called.
      # Callback is called regardless of :async setting.
      # 
      #   Client(:service => WidgetService).new.find do |c|
      #     c.on_failure {|err| ... }
      #   end
      # 
      def on_failure &failure_callback
        @failure_callback = failure_callback
      end
      
      # Provides a mechanism to call the service method against the client
      # and will automatically setup the service_class and method_name
      # in the wrapper protobuf request.
      #
      #   # find is not defined by Client which will trigger method_missing
      #   Client(:service => WidgetService).new.find
      # 
      def method_missing method, *params, &client_callback
        service = @options[:service]
        unless service.rpcs[service].keys.include?(method)
          log_error '[client] %s#%s not rpc method, passing to super' % [service.name, method.to_s]
          super method, *params
        else
          log_debug '[client] %s#%s' % [service.name, method.to_s]
          rpc = service.rpcs[service][method.to_sym]
          @options[:request_type] = rpc.request_type
          log_debug '[client] Request Type: %s' % @options[:request_type].name
          @options[:response_type] = rpc.response_type
          log_debug '[client] Response Type: %s' % @options[:response_type].name
          @options[:method] = method.to_s
          @options[:request] = params[0].is_a?(Hash) ? @options[:request_type].new(params[0]) : params[0]
          log_debug '[client] Request Data: %s' % @options[:request].inspect
          
          #### TODO remove first part here once we are able to convert everything to the new event based way of handling success/failure
          unless client_callback.nil?
            if client_callback.arity == 2
              @options[:version] = 1.0
              log_debug '[client] version = 1.0'
              
              log_warn deprecation_warning
              STDOUT.puts deprecation_warning unless Protobuf::Logger.configured?
              
              on_success {|res| client_callback.call(self, res) }
              on_failure {|err| client_callback.call(self, nil) }
            else
              ### TODO Replace block above with this once all client definitions use new event driven approach
              # Call client to setup on_success and on_failure event callbacks
              @options[:version] = 2.0
              log_debug '[client] version = 2.0'
              client_callback.call(self)
            end
          else
            log_debug '[client] no callbacks given'
          end
      
          send_request
        end
      end
      
      # Send the request to the service through eventmachine.
      # This method is usually never called directly
      # but is invoked by method_missing (see docs above).
      #
      #   request = WidgetFindRequest.new
      #   client = Client.new({
      #     :service => WidgetService,
      #     :method => "find",
      #     :request_type => "WidgetFindRequest",
      #     :response_type => "WidgetList",
      #     :request => request
      #   })
      # 
      #   client.on_success do |res|
      #     res.widgets.each{|w| puts w.inspect }
      #   end
      #
      #   client.on_failure do |err|
      #     puts err.message
      #   end
      # 
      #   client.send_request
      #
      def send_request
        Thread.new { EM.run } unless EM.reactor_running?
        
        EM.schedule do
          log_debug '[client] Scheduling client connection to be created on next tick'
          connection = ClientConnection.connect @options, &ensure_callback
          connection.on_success &@success_callback unless @success_callback.nil?
          connection.on_failure &ensure_callback
          connection.on_complete { @do_block = false } if @do_block
          log_debug '[client] Connection scheduled'
        end
        
        return synchronize_or_return
      end
      
      # Block the client call to send_request from returning if
      # async is false, otherwise do nothing.
      # Simple blocking algorithm to sleep while @do_block is set to true.
      # The eventmachine connection has a registered callback to flip 
      # @do_block to false as soon as the response has been received and processed.
      # If any errors are returned an appropriate RPC_ERROR is sent back to the client
      # through the failure callback.
      # 
      def synchronize_or_return
        if @do_block
          begin
            Timeout.timeout(@options[:timeout]) do
              sleep 0.5 while @do_block
              true
            end
          rescue => ex
            log_error 'An exception occurred while waiting for server response:'
            log_error ex.message
            log_error ex.backtrace.join("\n")
          
            if ex.is_a?(Timeout::Error)
              message = 'Client timeout of %d seconds expired' % @options[:timeout]
            else
              message = 'Client failed: %s' % ex.message
            end
          
            err = ClientError.new(Protobuf::Socketrpc::ErrorReason::RPC_ERROR, message)
            ensure_callback.call(err)
          end
        else
          true
        end
      end
      
      # Returns a proc that ensures any errors will be returned to the client
      # 
      # If a failure callback was set, just use that as a direct assignment
      # otherwise implement one here that simply throws an exception, since we
      # don't want to swallow the black holes.
      # 
      # TODO: remove "else" portion below once 1.0 is gone
      # 
      def ensure_callback
        @ensure_callback ||= begin
          if @options[:version] == 2.0
            if @failure_callback.nil?
              cbk = proc do |error|
                raise '%s: %s' % [error.code.name, error.message]
              end
            else
              cbk = @failure_callback
            end
          else
            cbk = proc do |error|
              @error = error
              @failure_callback ? @failure_callback.call(self) : raise('%s: %s' % [error.code.name, error.message])
            end
          end
          cbk
        end
      end
      
      # Annoying deprecation warning to print if you are still on v1 DSL
      def deprecation_warning
        %Q{
##################################################
# Deprecation Warning - Upgrade Client Callbacks
# ==============================================
# 
# You are attempting to use two block arguments (presumably client and response)
# in your client callback for the call to #{@options[:service].name}.client.#{@options[:method]}.
# 
# The next version of ruby-protobuf will completely remove the 
# style of client calls that accepts two arguments in favor of a more explicit evented approach.
# 
# You should refactor the code before upgrading to the next version of this gem. An example of callback style v1:
# 
#     #{@options[:service]}.client.#{@options[:method]}(request) do |client, response|
#       if client.failed?
#         # do something with client.error or client.message
#       else
#         # do something with response
#       end
#     end
# 
# Refactor the previous example of callback style v1 usage to v2 with the following:
# 
#     #{@options[:service]}.client.#{@options[:method]}(request) do |c|
#       c.on_failure do |error|
#         # do something with error.code or error.message
#       end
#       c.on_success do |response|
#         # do something with response
#       end
#     end
# 
##################################################
}
      end
      
      # Controller error/failure methods
      # TODO remove these when v1 is gone
      def failed?
        !@error.nil? and !@error[:code].nil?
      end
      def error
        @error[:message] if failed?
      end
      def error_reason
        Protobuf::Socketrpc::ErrorReason.name_by_value(@error[:code]).to_s if failed?
      end
      def error_message
        "%s: %s" % [error_reason, error] if failed?
      end
      
    end
  end
end