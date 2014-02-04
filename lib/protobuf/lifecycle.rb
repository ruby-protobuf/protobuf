module Protobuf
  class Lifecycle
    include ::Protobuf::Logger::LogMethods

    def self.register( event_name, &blk )
      raise "Lifecycle register must have a block" unless block_given?

      event_name = normalized_event_name( event_name )

      log_warn {
        message = "Lifecycle events have been deprecated. Use ::ActiveSupport::Notifications.subscribe('#{event_name}')"
        sign_message(message)
      }

      ::ActiveSupport::Notifications.subscribe(event_name) do |name, start, finish, id, args|
        blk.call(*args)
      end
    end

    def self.trigger( event_name, *args )
      log_warn {
        message = "Lifecycle events have been deprecated. Use ::ActiveSupport::Notifications.instrument(...)"
        sign_message(message)
      }

      event_name = normalized_event_name( event_name )

      ::ActiveSupport::Notifications.instrument(event_name, args)
    end

    def self.normalized_event_name( event_name )
      return "#{event_name}".downcase
    end

    class << self
      attr_accessor :lifecycle_events

      alias_method :on, :register
    end

    @lifecycle_events ||= {}
  end
end
