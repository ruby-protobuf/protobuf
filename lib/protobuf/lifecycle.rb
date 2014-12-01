module Protobuf
  class Lifecycle
    class << self
      def register(event_name, &blk)
        fail "Lifecycle register must have a block" unless block_given?
        event_name = normalized_event_name(event_name)

        if ::Protobuf.print_deprecation_warnings?
          $stderr.puts <<-ERROR
          [DEPRECATED] ::Protobuf::Lifecycle has been deprecated and will be removed in a future version.
            Use ::ActiveSupport::Notifications.subscribe('#{event_name}')
          ERROR
        end

        ::ActiveSupport::Notifications.subscribe(event_name) do |_name, _start, _finish, _id, args|
          blk.call(*args)
        end
      end
      alias_method :on, :register

      def trigger(event_name, *args)
        if ::Protobuf.print_deprecation_warnings?
          $stderr.puts <<-ERROR
          [DEPRECATED] ::Protobuf::Lifecycle has been deprecated and will be removed in a future version.
            Use ::ActiveSupport::Notifications.instrument(...)
          ERROR
        end

        event_name = normalized_event_name(event_name)

        ::ActiveSupport::Notifications.instrument(event_name, args)
      end

      def normalized_event_name(event_name)
        event_name.to_s.downcase
      end
    end
  end
end
