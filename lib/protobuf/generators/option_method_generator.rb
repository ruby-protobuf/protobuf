require 'protobuf/generators/base'

module Protobuf
  module Generators
    class OptionMethodGenerator < Base

      attr_accessor :method_name, :option_field_name

      def initialize(method_name, option_field_name, options_descriptor, indent_level = 0)
        self.method_name = method_name
        self.option_field_name = option_field_name
        super(options_descriptor, indent_level)
      end

      def compile
        run_once(:compile) do
          puts "def self.#{method_name}"
          indent { puts self.descriptor[option_field_name].to_s }
          puts "end"
          puts
        end
      end

    end
  end
end


