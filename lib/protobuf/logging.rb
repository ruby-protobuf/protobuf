module Protobuf
  module Logging
    def self.initialize_logger(log_target=$stdout, log_level=::Logger::INFO)
      @counter ||= 0
      @counter = @counter + 1
      old_logger = defined?(@logger) ? @logger : nil
      @logger = Logger.new(log_target)
      @logger.level = log_level
      old_logger.close if old_logger and log_target != $stdout
      @logger
    end

    def self.logger
      defined?(@logger) ? @logger : initialize_logger
    end

    def self.logger=(new_logger)
      @logger = new_logger
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
      @_log_signature ||= "[#{self.class == Class ? self.name : self.class.name}]"
    end

    def sign_message(message)
      "#{log_signature} #{message}"
    end
  end
end

# Inspired by [mperham](https://github.com/mperham/sidekiq)
