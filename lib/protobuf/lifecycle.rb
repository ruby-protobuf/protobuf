module Protobuf
  class Lifecycle

    def self.register( event_name, &blk )
      raise "Lifecycle register must have a block" unless block_given?
      event_name = normalized_event_name( event_name )

      lifecycle_events[ event_name ] ||= []
      lifecycle_events[ event_name ] << blk
    end

    def self.trigger( event_name )
      event_name = normalized_event_name( event_name )

      if lifecycle_events.has_key?( event_name )
        lifecycle_events[ event_name ].each do |block|
          block.call
        end
      end
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
