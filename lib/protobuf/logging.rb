require 'logger'

module Protobuf

  # Inspired by https://github.com/mperham/sidekiq
  module Logging
    def self.initialize_logger(device = $stdout, level = ::Logger::INFO)
      oldlogger = @logger
      @logger = ::Logger.new(device)
      @logger.level = level
      @logger
    ensure
      oldlogger && oldlogger.close
    end

    def self.logger
      @logger || initialize_logger
    end

    def self.logger=(log)
      @logger = (log ? log : ::Logger.new('/dev/null'))
    end

    private

    def logger
      ::Protobuf::Logging.logger
    end

    def log_exception(exception, context={})
      logger.warn context unless context.empty?
      logger.warn exception
      logger.debug exception.backtrace.join("\n") if exception.backtrace
    end

    def thread_id
      "TID-#{Thread.current.object_id.to_s(36)}"
    end
  end
end
