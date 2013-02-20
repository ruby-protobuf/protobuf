require 'date'
require 'protobuf/logger'

module Protobuf
  module Rpc
    class Stat
      attr_accessor :mode, :start_time, :end_time, :request_size, :dispatcher
      attr_accessor :response_size, :client, :server, :service, :method_name

      MODES = [:SERVER, :CLIENT].freeze

      def initialize(mode = :SERVER)
        @mode = mode
        start
      end

      def client=(client_host)
        @client = client_host
      end

      def client
        @client || nil
      end

      def elapsed_time
        (start_time && end_time ? "#{(end_time - start_time).round(4)}s" : nil)
      end

      def method_name
        @method_name ||= @dispatcher.try(:service).try(:method_name)
      end

      def server=(peer)
        @server = {:port => peer[0], :ip => peer[1]}
      end

      def server
        @server ? "#{@server[:ip]}:#{@server[:port]}" : nil
      end

      def service
        @service ||= @dispatcher.try(:service).class.name
      end

      def sizes
        "#{@request_size || 0}B/#{@response_size || 0}B" if stopped?
      end

      def start
        @start_time ||= Time.now
      end

      def stop
        start unless @start_time
        @end_time ||= Time.now
      end

      def stopped?
        ! end_time.nil?
      end

      def rpc
        service && method_name ? "#{service}##{method_name}" : nil
      end

      def server?
        @mode == :SERVER
      end

      def client?
        @mode == :CLIENT
      end

      def to_s
        [
          server? ? "[SRV]" : "[CLT]",
          server? ? client : server,
          trace_id,
          rpc,
          elapsed_time,
          sizes
        ].compact.join(' - ')
      end

      def trace_id
        Thread.current.object_id.to_s(16)
      end

    end
  end
end

