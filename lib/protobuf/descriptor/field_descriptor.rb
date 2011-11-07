module Protobuf
  module Descriptor
    class FieldDescriptor
      def initialize(field_instance=nil)
        @field_instance = field_instance
      end

      def proto_type
        'Google::Protobuf::FieldDescriptorProto'
      end

      def build(proto, opt={})
        cls = opt[:class]
        rule = Protobuf::Descriptor.id2label(proto.label)
        type = Protobuf::Descriptor.id2type(proto.type)
        type = proto.type_name.to_sym if [:message, :enum].include?(type)
        opts = {}
        opts[:default] = proto.default_value if proto.default_value
        cls.define_field(rule, type, proto.name, proto.number, opts)
      end

      def unbuild(parent_proto, extension=false)
        field_proto = Google::Protobuf::FieldDescriptorProto.new
        field_proto.name = @field_instance.name.to_s
        field_proto.number = @field_instance.tag
        field_proto.label = Protobuf::Descriptor.label2id(@field_instance.rule)
        field_proto.type = Protobuf::Descriptor.type2id(@field_instance.type)
        if [Google::Protobuf::FieldDescriptorProto::Type::TYPE_MESSAGE,
          Google::Protobuf::FieldDescriptorProto::Type::TYPE_ENUM].include? field_proto.type
          field_proto.type_name = @field_instance.type.to_s.split('::').last
        end
        field_proto.default_value = @field_instance.default.to_s if @field_instance.default

        case parent_proto
        when Google::Protobuf::FileDescriptorProto
          parent_proto.extension << field_proto
        when Google::Protobuf::DescriptorProto
          if extension
            parent_proto.extension << field_proto
          else
            parent_proto.field << field_proto
          end
        else
          raise TypeError, parent_proto.class.name
        end
      end
    end
  end
end
