begin
  require 'active_support/subscriber'
rescue LoadError
  require 'backports/active_support/subscriber'
end

module Protobuf
  module Rpc
    class LogSubscriber < ::ActiveSupport::Subscriber
      include ::Protobuf::Logging

      RECEIVED_FORMAT  = '[%s] Received %s#%s from %s'.freeze
      COMPLETED_FORMAT = '[%s] Completed in %.1fms (%s) (%s)'.freeze
      TIMING_FORMAT    = '%s: %.1fms'.freeze

      def decode_request(event)
        add_timing('Decode', event)

        unless event.payload[:exception]
          logger.info do
            RECEIVED_FORMAT % [
              thread_id,
              event.payload['service_name'],
              event.payload['method_name'],
              event.payload['client_host']
            ]
          end
        end
      end

      def dispatch_request(event)
        add_timing('Dispatch', event)
      end

      def encode_request(event)
        add_timing('Encode', event)
      end

      def handle_request(event)
        logger.info do
          COMPLETED_FORMAT % [
            thread_id,
            event.duration,
            "#{event.payload['encoded_response'].size} Bytes",
            event.children.map { |child| child.payload['timing'] }.compact.join(' | ')
          ]
        end
      end

      private

      def add_timing(label, event)
        event.payload['timing'] = TIMING_FORMAT % [label, event.duration]
      end
    end
  end
end

::Protobuf::Rpc::LogSubscriber.attach_to 'protobuf'
