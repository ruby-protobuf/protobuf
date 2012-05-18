module Protobuf
  module Rpc
    class Buffer

      attr_accessor :mode, :data, :size

      MODES = [:read, :write]

      # constantize this so we don't re-initialize the regex every time we need it
      SIZE_REGEX = /^\d+-/

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
          get_data_size
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
      def get_data_size
        if @size == 0 || @data.match(SIZE_REGEX)
          sliced_size = @data.slice!(SIZE_REGEX)
          @size = sliced_size.gsub('-', '').to_i unless(sliced_size.nil?)
        end
      end

      def check_for_flush
        if !@size.nil? && @data.length == @size
          @flush = true
        end
      end
    end
  end
end
