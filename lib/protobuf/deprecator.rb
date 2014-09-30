module Protobuf
  module Deprecator

    def warn_deprecated(old_method, new_method)
      $stderr.puts %([DEPRECATED] #{name}.#{old_method} is deprecated and will disappear in a future version.
              Please use #{name}.#{new_method} instead.\n)
    end

    # Given deprecations should be a hash whose keys are the new methods
    # and values are a list of deprecated methods that should send to t
    def deprecate_method(old_method, new_method)
      define_method old_method do |*args|
        self.class.warn_deprecated(old_method, new_method)
        public_send(new_method, *args)
      end
    end

    # Given deprecations should be a hash whose keys are the new methods
    # and values are a list of deprecated methods that should send to t
    def deprecate_class_method(old_method, new_method)
      define_singleton_method old_method do |*args|
        warn_deprecated(old_method, new_method)
        public_send(new_method, *args)
      end
    end

  end
end
