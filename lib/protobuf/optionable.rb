require 'active_support/concern'

module Protobuf
  module Optionable
    extend ::ActiveSupport::Concern

    module ClassMethods
      def get_option(name)
        @_optionable_options.try(:[], name)
      end

      def set_option(name, value = true)
        @_optionable_options ||= {}
        @_optionable_options[name] = value
      end
    end

    def get_option(name)
      self.class.get_option(name)
    end

  end
end
