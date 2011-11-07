module Protobuf
  module Descriptor
    class Descriptor
      def initialize(message_class)
        @message_class = message_class
      end

      def proto_type
        'Google::Protobuf::DescriptorProto'
      end

      def build(proto, opt={})
        mod = opt[:module]
        cls = mod.const_set(proto.name, Class.new(@message_class))
        proto.nested_type.each do |message_proto|
          Protobuf::Message.descriptor.build(message_proto, :module => cls)
        end
        proto.enum_type.each do |enum_proto|
          Protobuf::Enum.descriptor.build(enum_proto, :module => cls)
        end
        proto.field.each do |field_proto|
          Protobuf::Field::BaseField.descriptor.build(field_proto, :class => cls)
        end
      end

      def unbuild(parent_proto)
        message_proto = Google::Protobuf::DescriptorProto.new
        message_proto.name = @message_class.to_s.split('::').last
        @message_class.fields.each do |tag, field|
          field.descriptor.unbuild(message_proto)
        end
        ObjectSpace.each_object(Class) do |cls|
          if innerclass?(@message_class, cls)
            cls.descriptor.unbuild(message_proto)
          end
        end

        case parent_proto
        when Google::Protobuf::FileDescriptorProto
          parent_proto.message_type << message_proto
        when Google::Protobuf::DescriptorProto
          parent_proto.nested_type << message_proto
        else
          raise TypeError, parent_proto.class.name
        end
      end

      private

      def innerclass?(parent, child)
        child.name =~ /::/ && child.name.split('::')[0..-2].join('::') == parent.name
      end
    end
  end
end
