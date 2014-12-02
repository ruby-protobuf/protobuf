require 'active_support/deprecation'

module Protobuf
  class DeprecationBase < ::ActiveSupport::Deprecation
    def deprecate_methods(*args)
      deprecation_options = { :deprecator => self }

      if args.last.is_a?(Hash)
        args.last.merge!(deprecation_options)
      else
        args.push(deprecation_options)
      end

      super
    end
  end

  class Deprecation < DeprecationBase
    def define_deprecated_methods(target_module, method_hash)
      target_module.module_eval do
        method_hash.each do |old_method, new_method|
          alias_method old_method, new_method
        end
      end

      deprecate_methods(target_module, method_hash)
    end
  end

  class FieldDeprecation < DeprecationBase
    # this is a convenience deprecator for deprecated proto fields

    def deprecate_method(target_module, method_name)
      deprecate_methods(target_module, method_name => target_module)
    end

    private

    def deprecated_method_warning(method_name, target_module)
      "#{target_module.name}##{method_name} field usage is deprecated"
    end
  end
end
