require 'protobuf/generators/base'

module Protobuf
  module Generators
    class ServiceGenerator < Base

      def compile
        run_once(:compile) do
          print_class(descriptor.name, :service) do
            descriptor.method.each do |method_descriptor|
              puts build_method(method_descriptor)
            end
          end
        end
      end

      def build_method(method_descriptor)
        name = method_descriptor.name
        request_klass = modulize(method_descriptor.input_type)
        response_klass = modulize(method_descriptor.output_type)
        "rpc :#{name.underscore}, #{request_klass}, #{response_klass}"
      end

    end
  end
end
