require 'protobuf/descriptor/file_descriptor'

module Protobuf
  module Descriptor
    def self.id2type(type_id)
      require 'protobuf/descriptor/descriptor_proto'
      case type_id
      when Google::Protobuf::FieldDescriptorProto::Type::TYPE_DOUBLE then
        :double
      when Google::Protobuf::FieldDescriptorProto::Type::TYPE_FLOAT then
        :float
      when Google::Protobuf::FieldDescriptorProto::Type::TYPE_INT64 then
        :int64
      when Google::Protobuf::FieldDescriptorProto::Type::TYPE_UINT64 then
        :unit64
      when Google::Protobuf::FieldDescriptorProto::Type::TYPE_INT32 then
        :int64
      when Google::Protobuf::FieldDescriptorProto::Type::TYPE_FIXED64 then
        :fixed64
      when Google::Protobuf::FieldDescriptorProto::Type::TYPE_FIXED32 then
        :fixed32
      when Google::Protobuf::FieldDescriptorProto::Type::TYPE_BOOL then
        :bool
      when Google::Protobuf::FieldDescriptorProto::Type::TYPE_STRING then
        :string
      when Google::Protobuf::FieldDescriptorProto::Type::TYPE_GROUP then
        :group
      when Google::Protobuf::FieldDescriptorProto::Type::TYPE_MESSAGE then
        :message
      when Google::Protobuf::FieldDescriptorProto::Type::TYPE_BYTES then
        :bytes
      when Google::Protobuf::FieldDescriptorProto::Type::TYPE_UINT32 then
        :uint32
      when Google::Protobuf::FieldDescriptorProto::Type::TYPE_ENUM then
        :enum
      when Google::Protobuf::FieldDescriptorProto::Type::TYPE_SFIXED32 then
        :sfixed32
      when Google::Protobuf::FieldDescriptorProto::Type::TYPE_SFIXED64 then
        :sfixed64
      when Google::Protobuf::FieldDescriptorProto::Type::TYPE_SINT32 then
        :sint32
      when Google::Protobuf::FieldDescriptorProto::Type::TYPE_SINT64 then
        :sint64
      else
        raise ArgumentError, "Invalid type: #{proto.type}"
      end
    end

    def self.type2id(type)
      require 'protobuf/descriptor/descriptor_proto'
      case type
      when :double then
        Google::Protobuf::FieldDescriptorProto::Type::TYPE_DOUBLE 
      when :float then
        Google::Protobuf::FieldDescriptorProto::Type::TYPE_FLOAT
      when :int64 then
        Google::Protobuf::FieldDescriptorProto::Type::TYPE_INT64 
      when :unit64 then
        Google::Protobuf::FieldDescriptorProto::Type::TYPE_UINT64 
      when :int64 then
        Google::Protobuf::FieldDescriptorProto::Type::TYPE_INT32 
      when :fixed64 then
        Google::Protobuf::FieldDescriptorProto::Type::TYPE_FIXED64 
      when :fixed32 then
        Google::Protobuf::FieldDescriptorProto::Type::TYPE_FIXED32 
      when :bool then
        Google::Protobuf::FieldDescriptorProto::Type::TYPE_BOOL 
      when :string then
        Google::Protobuf::FieldDescriptorProto::Type::TYPE_STRING 
      when :group then
        Google::Protobuf::FieldDescriptorProto::Type::TYPE_GROUP 
      when :message then
        Google::Protobuf::FieldDescriptorProto::Type::TYPE_MESSAGE 
      when :bytes then
        Google::Protobuf::FieldDescriptorProto::Type::TYPE_BYTES
      when :uint32 then
        Google::Protobuf::FieldDescriptorProto::Type::TYPE_UINT32 
      when :enum then
        Google::Protobuf::FieldDescriptorProto::Type::TYPE_ENUM 
      when :sfixed32 then
        Google::Protobuf::FieldDescriptorProto::Type::TYPE_SFIXED32 
      when :sfixed64 then
        Google::Protobuf::FieldDescriptorProto::Type::TYPE_SFIXED64 
      when :sint32 then
        Google::Protobuf::FieldDescriptorProto::Type::TYPE_SINT32 
      when :sint64 then
        Google::Protobuf::FieldDescriptorProto::Type::TYPE_SINT64 
      else
        Google::Protobuf::FieldDescriptorProto::Type::TYPE_MESSAGE
      end
    end

    def self.id2label(label_id)
      require 'protobuf/descriptor/descriptor_proto'
      case label_id
      when Google::Protobuf::FieldDescriptorProto::Label::LABEL_REQUIRED then
        :required
      when Google::Protobuf::FieldDescriptorProto::Label::LABEL_OPTIONAL then
        :optional
      when Google::Protobuf::FieldDescriptorProto::Label::LABEL_REPEATED then
        :repeated
      else
        raise ArgumentError, "Invalid label: #{proto.label}"
      end
    end

    def self.label2id(label)
      require 'protobuf/descriptor/descriptor_proto'
      case label
      when :required then
        Google::Protobuf::FieldDescriptorProto::Label::LABEL_REQUIRED
      when :optional then
        Google::Protobuf::FieldDescriptorProto::Label::LABEL_OPTIONAL
      when :repeated then
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
