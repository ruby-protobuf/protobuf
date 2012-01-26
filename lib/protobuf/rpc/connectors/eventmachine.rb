require 'protobuf/rpc/connectors/base'
require 'protobuf/rpc/connectors/em_client'

module Protobuf
  module Rpc
    module Connectors
      class EventMachine < Base

        def send_request
          ensure_em_running do 
            f = Fiber.current

            EM.next_tick do
              log_debug "[#{log_signature}] Scheduling EventMachine client request to be created on next tick"
              cnxn = EMClient.connect(options, &ensure_cb)
              cnxn.on_success(&success_cb) if success_cb
              cnxn.on_failure(&ensure_cb)
              cnxn.on_complete { resume_fiber(f) } unless async?
              log_debug "[#{log_signature}] Connection scheduled"
            end

            async? ? true : set_timeout_and_validate_fiber
          end
        end

        # Returns a callable that ensures any errors will be returned to the client
        # 
        # If a failure callback was set, just use that as a direct assignment
        # otherwise implement one here that simply throws an exception, since we
        # don't want to swallow the black holes.
        # 
        def ensure_cb
          @ensure_cb ||= (@failure_cb || lambda { |error| raise '%s: %s' % [error.code.name, error.message] } )
        end

        def log_signature
          @log_signature ||= "client-#{self.class}"
        end

        private

        def ensure_em_running(&blk)
          if EM.reactor_running? 
            @global_reactor = true
            yield
          else 
            @global_reactor = false
            EM.fiber_run do 
              blk.call
              EM.stop
            end
          end
        end

        def resume_fiber(fib)
          EM::cancel_timer(@timeout_timer)
          fib.resume(true)
        rescue => ex 
          log_error "[#{log_signature}] An exception occurred while waiting for server response:"
          log_error ex.message
          log_error ex.backtrace.join("\n")

          message = 'Synchronous client failed: %s' % ex.message
          err = Protobuf::Rpc::ClientError.new(Protobuf::Socketrpc::ErrorReason::RPC_ERROR, message)
          ensure_cb.call(err)
          EM.stop if !@global_reactor
        end

        def set_timeout_and_validate_fiber
          @timeout_timer = EM::add_timer(@options[:timeout]) do
            message = 'Client timeout of %d seconds expired' % @options[:timeout]
            err = Protobuf::Rpc::ClientError.new(Protobuf::Socketrpc::ErrorReason::RPC_ERROR, message)
            ensure_cb.call(err)
            EM.stop if !@global_reactor
          end

          Fiber.yield
        rescue FiberError
          message = "Synchronous calls must be in 'EM.fiber_run' block" 
          err = Protobuf::Rpc::ClientError.new(Protobuf::Socketrpc::ErrorReason::RPC_ERROR, message)
          ensure_cb.call(err)
          EM.stop if !@global_reactor
       end

      end
    end
  end
end
