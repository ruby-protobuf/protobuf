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
        if method_descriptor.options
          opts = {}
          method_descriptor.options.each_field do |field_option|
            next unless field_option.extension?
            default_option_value = method_descriptor.options.send(field_option.name)
            next if default_option_value == field_option.default_value
            opts[field_option.name] = serialize_value(default_option_value)
          end
          option_string = opts.map { |option_name, value| ", :#{option_name} => #{value}" }.join()
        else
          option_string = ""
        end
        "rpc :#{name.underscore}, #{request_klass}, #{response_klass}#{option_string}"
      end

    end
  end
end
