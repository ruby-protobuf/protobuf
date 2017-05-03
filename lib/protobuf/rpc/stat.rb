require 'date'
require 'time'
require 'protobuf/logging'

module Protobuf
  module Rpc
    class Stat
      attr_accessor :mode, :start_time, :end_time, :request_size, :dispatcher
      attr_accessor :response_size, :client, :service, :method_name
      attr_reader   :server

      MODES = [:SERVER, :CLIENT].freeze

      def initialize(mode = :SERVER)
        @mode = mode
        @request_size = 0
        @response_size = 0
        start
      end

      attr_writer :client

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
        case peer
        when Array
          @server = "#{peer[1]}:#{peer[0]}"
        when String
          @server = peer
        end
      end

      def service
        @service ||= @dispatcher.try(:service).class.name
      end

      def sizes
        if stopped?
          "#{@request_size}B/#{@response_size}B"
        else
          "#{@request_size}B/-"
        end
      end

      def start
        @start_time ||= ::Time.now
      end

      def stop
        start unless @start_time
        @end_time ||= ::Time.now
      end

      def stopped?
        !end_time.nil?
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
          sizes,
          elapsed_time,
          @end_time.try(:iso8601),
        ].compact.join(' - ')
      end

      def trace_id
        ::Thread.current.object_id.to_s(16)
      end

    end
  end
end
