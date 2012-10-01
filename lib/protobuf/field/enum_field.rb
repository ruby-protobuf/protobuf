require 'protobuf/field/varint_field'

module Protobuf
  module Field
    class EnumField < VarintField
      def acceptable?(val)
        case val
        when Symbol then
          raise TypeError unless @type.const_defined?(val)
        when EnumValue then
          raise TypeError if val.parent_class != @type
        else
          raise TypeError unless @type.valid_tag?(val)
        end
        true
      end

      def encode(value)
        super(value.to_i)
      end

      private

      def typed_default_value
        if @default.is_a?(Symbol)
          @type.const_get(@default)
        else
          self.class.default
        end
      end

      def define_setter
        field = self
        @message_class.class_eval do
          define_method("#{field.name}=") do |val|
            if val.nil?
              @values.delete(field.name)
            else
              val = \
                case val
                when Symbol then
                  field.type.const_get(val) rescue nil
                when Integer then
                  field.type.const_get(field.type.name_by_value(val)) rescue nil
                when EnumValue then
                  raise TypeError, "Invalid value: #{val.inspect} for #{field.name}" if val.parent_class != field.type
                  val
                end
              raise TypeError, "Invalid value: #{val.inspect} for #{field.name}" unless val

              @values[field.name] = val
            end
          end
        end
      end
    end
  end
end
