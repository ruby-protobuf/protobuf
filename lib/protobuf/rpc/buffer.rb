module Protobuf
  module Rpc
    class Buffer
      
      attr_accessor :mode, :data, :size
      
      MODES = [:read, :write]
      
      def initialize(mode=:read)
        @flush = false
        @data = ""
        @size = 0
        self.mode = mode
      end
      
      def mode=(mode)
        if MODES.include?(mode)
          @mode = mode
        else
          @mode = :read
        end
      end

      def size_prefixed_data
        @size = @data.length
        return "#{@size}-#{@data}"
      end
      
      def write(force_mode=true)
        if force_mode and reading?
          mode = :write
        elsif not force_mode and reading?
          raise = 'You chose to write the buffer when in read mode'
        end
        
        @size = @data.length
        '%d-%s' % [@size, @data]
      end
      
      def <<(data)
        @data << data
        if reading?
          @size = @data.size
          check_for_flush
        end
      end

      def set_data(data)
        @data = data.is_a?(Protobuf::Message) ? data.serialize_to_string : data.to_s
        @size = @data.size
      end
      
      def reading?
        mode == :read
      end
      
      def writing?
        mode == :write
      end
      
      def flushed?
        @flush
      end
      
    private
     
      def check_for_flush
        if !@size.nil? && @data.length == @size
          @flush = true
        end
      end
    end
  end
end
