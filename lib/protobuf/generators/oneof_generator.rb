require 'protobuf/generators/base'

module Protobuf
  module Generators
    class OneofGenerator < Base

      def compile
        run_once(:compile) do
          puts "set_oneof_names #{oneof_names.join(', ')}"
        end
      end

      private

      def oneof_names
        @oneof_names ||= descriptor.oneof_decl.map { |oneof_descriptor|
          ":#{oneof_descriptor.name}"
        }
      end

    end
  end
end

