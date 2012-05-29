# Handles client connections to the server
module Protobuf
  module Rpc
    module Connectors

      class EMClient < EM::Connection
        include Protobuf::Logger::LogMethods
        include Protobuf::Rpc::Connectors::Common

        attr_reader :options, :request, :response
        attr_reader :error, :error_reason, :error_message

        ##
        # Constructor
        #
        def initialize(options={}, &failure_cb)
          @failure_cb = failure_cb
          @options = DEFAULT_OPTIONS.merge(options)
          verify_options

          log_debug { "[#{log_signature}] Client Initialized: %s" % options.inspect }
        rescue
          fail(:RPC_ERROR, 'Failed to initialize connection: %s' % $!.message)
        end

        ##
        # Class Methods
        #
        def self.connect(options={})
          options = DEFAULT_OPTIONS.merge(options)
          log_debug { "[client-#{self}] Connecting to server: %s" % options.inspect }
          EM.connect(options[:host], options[:port], self, options)
        end

        # turn post_init back into a no-op for event machine
        def post_init
        end

        ##
        # Instance Methods
        #
        # Completion callback registration
        def on_complete(&complete_cb)
          @complete_cb = complete_cb
        end

        # Failure callback registration
        def on_failure(&failure_cb)
          @failure_cb = failure_cb
        end

        # Success callback registration
        def on_success(&success_cb)
          @success_cb = success_cb
        end

        def receive_data(data)
          response_buffer = ::Protobuf::Rpc::Buffer.new(:read)
          log_debug { "[#{log_signature}] receive_data: %s" % data }
          response_buffer << data
          @response_data = response_buffer.data
          parse_response if(!@response_data.nil?)
        end

        def send_data
          request_buffer = ::Protobuf::Rpc::Buffer.new(:write)
          request_buffer.set_data(@request_data)
          log_debug { "[#{log_signature}] sending data: #{request_buffer.inspect}" }
          super(request_buffer.write)
        rescue
          fail(:RPC_ERROR, 'Connection error: %s' % $!.message)
        end

        # overwriting this method for java because it's broken in eventmachine. See https://github.com/eventmachine/eventmachine/issues/14
        if RUBY_PLATFORM =~ /java/
          def error?
            !!@error
          end
        end

      end
    end
  end
end
