require 'date'
require 'protobuf/logger'

module Protobuf
  module Rpc
    class Stat
      TYPES = [:SERVER, :CLIENT]
      
      def initialize type=:SERVER, do_start=true
        @type = type
        start if do_start
      attr_accessor :mode, :start_time, :end_time, :request_size, :dispatcher
      attr_accessor :response_size, :client, :server, :service, :method

      end

      def client=(peer)
        @client = {:port => peer[0], :ip => peer[1]}
      end

      def client
        @client ? "#{@client[:ip]}:#{@client[:port]}" : nil
      end
      
      def server= peer
        @server = {:port => peer[0], :ip => peer[1]}
      end

      def server
        @server ? "#{@server[:ip]}:#{@server[:port]}" : nil
      end

      def sizes
        "#{@request_size || 0}B/#{@response_size || 0}B"
      end

      def start
        @start_time ||= Time.now
      end

      def stop
        start if !@start_time
        @end_time ||= Time.now
      end

      def rpc
        service && method ? "#{service}##{method}" : nil
      end

      def elapsed_time
        (start_time && end_time ? "#{(end_time - start_time).round(4)}s" : nil)
      end

      def server?
        @mode == :SERVER
      end

      def client?
        @mode == :CLIENT
      end

      def to_s
        [
          @type == :SERVER ? "[SRV-#{self.class}]" : "[CLT-#{self.class}]",
          rpc,
          elapsed_time,
          sizes,
          @type == :SERVER ? server : client
        ].compact.join(' - ')
      end

    end
  end
end

