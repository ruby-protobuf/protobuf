module Protobuf
  module Deprecator

    def warn_deprecated(old_method, new_method)
      $stderr.puts %Q{[DEPRECATED] #{self.name}.#{old_method} is deprecated and will disappear in a future version.
              Please use #{self.name}.#{new_method} instead.\n}
    end

    # Given deprecations should be a hash whose keys are the new methods
    # and values are a list of deprecated methods that should send to t
    def deprecate_method(old_method, new_method)
      class_eval(<<-DEPRECATED, __FILE__, __LINE__ + 1)
        def #{old_method}(*args)
          warn_deprecated("#{old_method}", "#{new_method}")
          new_meth = method("#{new_method}")
          if new_meth.arity == 0
            __send__("#{new_method}")
          else
            __send__("#{new_method}", *args)
          end
        end
      DEPRECATED
    end

    # Given deprecations should be a hash whose keys are the new methods
    # and values are a list of deprecated methods that should send to t
    def deprecate_class_method(old_method, new_method)
      class_eval(<<-DEPRECATED, __FILE__, __LINE__ + 1)
        def self.#{old_method}(*args)
          warn_deprecated("#{old_method}", "#{new_method}")
          new_meth = method("#{new_method}")
          if new_meth.arity == 0
            __send__("#{new_method}")
          else
            __send__("#{new_method}", *args)
          end
        end
      DEPRECATED
    end

  end
end
