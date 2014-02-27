require 'active_support/subscriber'
require 'active_support/number_helper'

module Protobuf
  module Rpc
    class LogSubscriber < ::ActiveSupport::Subscriber
      include ::Protobuf::Logging
      include ::ActiveSupport::NumberHelper

      TIMING_FORMAT    = '%s: %.1fms'.freeze
      COMPLETED_FORMAT = '[%s] Completed in %.1fms (%s) (%s)'.freeze

      def decode_request(event)
        add_timing('Decode', event)
      end

      def dispatch_request(event)
        add_timing('Dispatch', event)
      end

      def encode_request(event)
        add_timing('Encode', event)
      end

      def handle_request(event)
        puts "#{event.payload.inspect}"
        logger.info do
          COMPLETED_FORMAT % [
            thread_id,
            event.duration,
            number_to_human_size(event.payload['encoded_response'].size),
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
