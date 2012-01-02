# Handles client connections to the server
module Protobuf
  module Rpc
    module Connectors
    
      class EMClient < EM::Connection
        include Protobuf::Logger::LogMethods
        include Protobuf::Rpc::Connectors::Common
        include Eventually
        enable_strict!
        emits :success, :arity => 1
        emits :failure, :arity => 1
        emits :complete, :arity => 1
      
        attr_reader :options, :request, :response
        attr_reader :error, :error_reason, :error_message
      
       class << self

          def connect(options={})
            options = DEFAULT_OPTIONS.merge(options)
            log_debug "[client-#{self}] Connecting to server: %s" % options.inspect
            EM.connect(options[:host], options[:port], self, options)
          end

        end
       
        def initialize(options={}, &failure_cb)
          @failure_cb = failure_cb
          @options = DEFAULT_OPTIONS.merge(options)
          verify_options
          initialize_stats

          log_debug "[#{log_signature}] Client Initialized: %s" % options.inspect
        rescue
          fail(:RPC_ERROR, 'Failed to initialize connection: %s' % $!.message)
        end

        # # Success callback registration
        # def on_success(&success_cb)
        #   @success_cb = success_cb
        # end
        #       
        # # Failure callback registration
        # def on_failure(&failure_cb)
        #   @failure_cb = failure_cb
        # end
        #       
        # # Completion callback registration
        # def on_complete(&complete_cb)
        #   @complete_cb = complete_cb
        # end
      
        def receive_data(data)
          log_debug "[#{log_signature}] receive_data: %s" % data
          @buffer << data
          parse_response if @buffer.flushed?
        end
     
      end
    end
  end
end
