require 'active_support/deprecation'

module Protobuf
  class Deprecation < ::ActiveSupport::Deprecation
    def deprecate_methods(*args)
      args.last.merge!(:deprecator => self) if args.last.is_a?(Hash)
      super
    end

    def define_deprecated_methods(target_module, method_hash)
      target_module.module_eval do
        method_hash.each do |old_method, new_method|
          alias_method old_method, new_method
        end
      end

      deprecate_methods(target_module, method_hash)
    end
  end
end
