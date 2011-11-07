module Protobuf
  module Rpc
    class Buffer
      
      attr_accessor :mode
      attr_reader :data, :size
      
      MODES = [:read, :write]
      
      def initialize mode=:read, data=''
        @data = data.is_a?(Protobuf::Message) ? data.serialize_to_string : data.to_s
        @flush = false
        self.mode = mode
      end
      
      def mode= mode
        if MODES.include? mode
          @mode = mode
        else
          @mode = :read
        end
      end
      
      def write force_mode=true
        if force_mode and reading?
          mode = :write
        elsif not force_mode and reading?
          raise = 'You chose to write the buffer when in read mode'
        end
        
        @size = @data.length
        '%d-%s' % [@size, @data]
      end
      
      def << data
        @data << data
        if reading?
          get_data_size
          check_for_flush
        end
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
    
      def get_data_size
        if @size.nil?
          sliced_size = @data.slice! /^\d+-/
          unless sliced_size.nil?
            @size = sliced_size.gsub(/-/, '').to_i 
          end
        end
      end
      
      def check_for_flush
        if not @size.nil? and @data.length == @size
          @flush = true
        end
      end
      
    end
  end
end