require 'active_support/concern'

module Protobuf
  module Optionable
    extend ::ActiveSupport::Concern

    module ClassMethods
      def get_option(name)
        optionable_options[name]
      end

      def set_option(name, value = true)
        optionable_options[name] = value
      end

      private

      def optionable_options
        @optionable_options ||= {}
      end
    end

    def get_option(name)
      self.class.get_option(name)
    end

  end
end
