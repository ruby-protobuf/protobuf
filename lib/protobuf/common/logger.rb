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

    # One-line file/level configuration
    def self.configure(options)
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
          Protobuf::Logger.__send__(m, *params, &block)
        end
      end

      def self.included(base)
        base.extend(LogMethods)
      end
    end
  end
end
