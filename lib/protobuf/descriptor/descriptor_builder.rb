require 'protobuf/descriptor/file_descriptor'

module Protobuf
  module Descriptor
    def self.id2type(type_id)
      require 'protobuf/descriptor/descriptor_proto'
      case type_id
      when Google::Protobuf::FieldDescriptorProto::Type::TYPE_DOUBLE
        :double
      when Google::Protobuf::FieldDescriptorProto::Type::TYPE_FLOAT
        :float
      when Google::Protobuf::FieldDescriptorProto::Type::TYPE_INT64
        :int64
      when Google::Protobuf::FieldDescriptorProto::Type::TYPE_UINT64
        :unit64
      when Google::Protobuf::FieldDescriptorProto::Type::TYPE_INT32
        :int64
      when Google::Protobuf::FieldDescriptorProto::Type::TYPE_FIXED64
        :fixed64
      when Google::Protobuf::FieldDescriptorProto::Type::TYPE_FIXED32
        :fixed32
      when Google::Protobuf::FieldDescriptorProto::Type::TYPE_BOOL
        :bool
      when Google::Protobuf::FieldDescriptorProto::Type::TYPE_STRING
        :string
      when Google::Protobuf::FieldDescriptorProto::Type::TYPE_GROUP
        :group
      when Google::Protobuf::FieldDescriptorProto::Type::TYPE_MESSAGE
        :message
      when Google::Protobuf::FieldDescriptorProto::Type::TYPE_BYTES
        :bytes
      when Google::Protobuf::FieldDescriptorProto::Type::TYPE_UINT32
        :uint32
      when Google::Protobuf::FieldDescriptorProto::Type::TYPE_ENUM
        :enum
      when Google::Protobuf::FieldDescriptorProto::Type::TYPE_SFIXED32
        :sfixed32
      when Google::Protobuf::FieldDescriptorProto::Type::TYPE_SFIXED64
        :sfixed64
      when Google::Protobuf::FieldDescriptorProto::Type::TYPE_SINT32
        :sint32
      when Google::Protobuf::FieldDescriptorProto::Type::TYPE_SINT64
        :sint64
      else
        raise ArgumentError, "Invalid type: #{proto.type}"
      end
    end

    def self.type2id(type)
      require 'protobuf/descriptor/descriptor_proto'
      case type
      when :double
        Google::Protobuf::FieldDescriptorProto::Type::TYPE_DOUBLE
      when :float
        Google::Protobuf::FieldDescriptorProto::Type::TYPE_FLOAT
      when :int64
        Google::Protobuf::FieldDescriptorProto::Type::TYPE_INT64
      when :unit64
        Google::Protobuf::FieldDescriptorProto::Type::TYPE_UINT64
      when :int64
        Google::Protobuf::FieldDescriptorProto::Type::TYPE_INT32
      when :fixed64
        Google::Protobuf::FieldDescriptorProto::Type::TYPE_FIXED64
      when :fixed32
        Google::Protobuf::FieldDescriptorProto::Type::TYPE_FIXED32
      when Google::Protobuf::FieldDescriptorProto::Type::TYPE_BOOL
        :bool
      when :string
        Google::Protobuf::FieldDescriptorProto::Type::TYPE_STRING
      when :group
        Google::Protobuf::FieldDescriptorProto::Type::TYPE_GROUP
      when :message
        Google::Protobuf::FieldDescriptorProto::Type::TYPE_MESSAGE
      when :bytes
        Google::Protobuf::FieldDescriptorProto::Type::TYPE_BYTES
      when :uint32
        Google::Protobuf::FieldDescriptorProto::Type::TYPE_UINT32
      when :enum
        Google::Protobuf::FieldDescriptorProto::Type::TYPE_ENUM
      when :sfixed32
        Google::Protobuf::FieldDescriptorProto::Type::TYPE_SFIXED32
      when :sfixed64
        Google::Protobuf::FieldDescriptorProto::Type::TYPE_SFIXED64
      when :sint32
        Google::Protobuf::FieldDescriptorProto::Type::TYPE_SINT32
      when :sint64
        Google::Protobuf::FieldDescriptorProto::Type::TYPE_SINT64
      else
        Google::Protobuf::FieldDescriptorProto::Type::TYPE_MESSAGE
      end
    end

    def self.id2label(label_id)
      require 'protobuf/descriptor/descriptor_proto'
      case label_id
      when Google::Protobuf::FieldDescriptorProto::Label::LABEL_REQUIRED
        :required
      when Google::Protobuf::FieldDescriptorProto::Label::LABEL_OPTIONAL
        :optional
      when Google::Protobuf::FieldDescriptorProto::Label::LABEL_REPEATED
        :repeated
      else
        raise ArgumentError, "Invalid label: #{proto.label}"
      end
    end

    def self.label2id(label)
      require 'protobuf/descriptor/descriptor_proto'
      case label
      when :required
        Google::Protobuf::FieldDescriptorProto::Label::LABEL_REQUIRED
      when :optional
        Google::Protobuf::FieldDescriptorProto::Label::LABEL_OPTIONAL
      when :repeated
        Google::Protobuf::FieldDescriptorProto::Label::LABEL_REPEATED
      else
        raise ArgumentError, "Invalid label: #{label}"
      end
    end

    class DescriptorBuilder
      class <<self

        def proto_type
          nil
        end

        def build(proto, opt={})
          acceptable_descriptor(proto).build(proto)
        end

        def acceptable_descriptor(proto)
          Protobuf::Descriptor.constants.each do |class_name|
            descriptor_class = Protobuf::Descriptor.const_get(class_name)
            if descriptor_class.respond_to?(:proto_type) && descriptor_class.proto_type == proto.class.name
              return descriptor_class
            end
          end
        end
      end
    end
  end
end
