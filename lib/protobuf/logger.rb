require 'logger'

module Protobuf
  class Logger < ::Logger

    class << self
      attr_accessor :file, :level

      # Stub out the log methods for Protobuf::Logger as singleton methods
      [:debug, :info, :warn, :error, :fatal, :any, :add, :log].each do |m|
        define_method(m) do |*params, &block|
          instance && instance.__send__(m, *params, &block)
        end
      end
    end

    # One-line file/level/logger configuration. If logger is
    # specified, file and level are ignored.
    #
    # @param options [Hash] Hash of options for the logger
    # @option :logger [::Logger] Logger instance to use underneath.
    # @option :file [String] File name to log to. Ignored if :logger is specified
    # @option :level [Logger::Severity] Level to log at. Ignored if :logger is specified
    def self.configure(options)
      @__instance = options.fetch(:logger, nil)
      self.file = options.fetch(:file, false)
      self.level = options.fetch(:level, false)
    end

    # Use to reset the instance
    def self.reset_device!
      self.file = self.level = @__instance = nil
    end

    # Singleton instance
    def self.instance
      @__instance ||= begin
        log = nil

        if @file && @level
          log = new(self.file)
          log.level = self.level
        end

        log
      end
    end

    #
    # LogMethods module for log method including, e.g.:
    #
    # class MyClass
    #   include Protobuf::Logger::LogMethods
    #   ...
    # end
    #
    # Produce a module to allow "include" in other classes to avoid
    # cluttering the namespace of the including class with the other methods defined above
    #
    module LogMethods
      [:debug, :info, :warn, :error, :fatal, :any, :add, :log].each do |m|
        define_method("log_#{m}") do |*params, &block|
          params.map! { |message| sign_message(message) }
          ::Protobuf::Logger.__send__(m, *params, &block)
        end
      end

      # When included, also extend the LogMethods module for class access.
      def self.included(base)
        base.extend(LogMethods)
      end

      # We often want to log an exception, so let's make that a core
      # concern of the logger.
      #
      def log_exception(ex)
        log_error { ex.message }
        log_error { ex.backtrace[0..5].join("\n") }
        log_debug { ex.backtrace.join("\n") }
      end

      def log_signature
        @_log_signature ||= "[#{self.class == Class ? self.name : self.class.name}]"
      end

      def sign_message(message)
        "#{log_signature} #{message}"
      end

    end

  end
end
