require 'logger'

module Protobuf
  class Logger < ::Logger
    
    class << self
      attr_accessor :file, :level
      
      # One-line file/level configuration
      def configure options
        self.file = options[:file] if options[:file]
        self.level = options[:level] if options[:level]
      end
      
      def configured?
        ! instance.nil?
      end
      
      # Use to reset the instance
      def reset_device!
        self.file = self.level = @__instance = nil
      end
      
      # Singleton instance
      def instance
        @__instance ||= begin
          log = nil
          if @file and @level
            log = new(self.file)
            log.level = self.level
          end
          log
        end
      end
      
      # Stub out the log methods for Protobuf::Logger as singleton methods
      [:debug, :info, :warn, :error, :fatal, :any, :add, :log].each do |m|
        define_method(m) do |*params, &block|
          instance && instance.__send__(m, *params, &block)
        end
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
    end
    
  end
end