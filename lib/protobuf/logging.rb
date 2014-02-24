require 'delegate'
require 'logger'

module Protobuf

  # Borrowed from the wonderful https://github.com/mperham/sidekiq
  module Logging
    class Pretty < ::Logger::Formatter
      def call(severity, time, program_name, message)
        "#{time.utc.iso8601} #{Process.pid} TID-#{thread_id}#{context} #{severity}: #{message}\n"
      end

      def thread_id
        Thread.current.object_id.to_s(36)
      end

      def context
        c = Thread.current[:protobuf_context]
        c ? " #{c}" : ''
      end
    end

    class ContextLogger < Delegator
      def initialize(logger, context)
        @logger  = logger
        @context = context
      end

      def method_missing(*)
        ::Protobuf::Logging.with_context(@context) do
          super
        end
      end

      def __getobj__
        @logger
      end
    end

    def self.with_context(msg)
      begin
        Thread.current[:protobuf_context] = msg
        yield
      ensure
        Thread.current[:protobuf_context] = nil
      end
    end

    def self.initialize_logger(device = $stdout, level = ::Logger::INFO)
      oldlogger = @logger
      @logger = ::Logger.new(device)
      @logger.level = level
      @logger.formatter = Pretty.new
      oldlogger && oldlogger.close unless $testing
      @logger
    end

    def self.logger
      @logger || initialize_logger
    end

    def self.logger=(log)
      @logger = (log ? log : ::Logger.new('/dev/null'))
    end

    def logger
      ::Protobuf::Logging.logger
    end

    def log_exception(exception, context={})
      self.logger.warn context unless context.empty?
      self.logger.warn exception
      self.logger.debug exception.backtrace.join("\n") if exception.backtrace
    end

    def log_signature
      self.class.name
    end

    def signed_logger
      @signed_logger ||= ::Protobuf::Logging::ContextLogger.new(
        self.logger,
        self.log_signature
      )
    end
  end
end
