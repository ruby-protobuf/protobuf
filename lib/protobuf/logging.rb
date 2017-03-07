require 'logger'

module Protobuf
  module Logging
    PROTOBUF_LOGGER = "_protobuf_logger".freeze

    def self.initialize_logger(log_target = $stdout, log_level = ::Logger::INFO)
      @logger = Logger.new(log_target)
      @logger.level = log_level
      @logger
    end

    def self.logger
      defined?(@logger) ? ::Thread.current[PROTOBUF_LOGGER] || @logger : initialize_logger
    end

    def self.logger=(new_logger)
      @logger = new_logger
    end

    def self.with_logger(scoped_logger)
      ::Thread.current[PROTOBUF_LOGGER] = scoped_logger
      yield
    ensure
      ::Thread.current[PROTOBUF_LOGGER] = nil
    end

    class << self
      attr_writer :logger
    end

    def logger
      ::Protobuf::Logging.logger
    end

    def log_exception(ex)
      logger.error { ex.message }
      logger.error { ex.backtrace[0..5].join("\n") }
      logger.debug { ex.backtrace.join("\n") }
    end

    def log_signature
      @_log_signature ||= "[#{self.class == Class ? name : self.class.name}]"
    end

    def sign_message(message)
      "#{log_signature} #{message}"
    end

    class FlushLogger < Logger
      attr_reader :queued_messages

      def initialize(*args)
        @queued_messages = []
        super
      end

      def debug(message = nil, &block)
        queued_messages << [DEBUG, message, block]
      end

      def error(message = nil, &block)
        queued_messages << [ERROR, message, block]
      end

      def fatal(message = nil, &block)
        queued_messages << [FATAL, message, block]
      end

      def flush!
        queued_messages.each do |level, message, block|
          add(level, message, &block)
        end
      ensure
        @queued_messages = []
      end

      def info(message = nil, &block)
        queued_messages << [INFO, message, block]
      end

    end
  end
end

# Inspired by [mperham](https://github.com/mperham/sidekiq)
