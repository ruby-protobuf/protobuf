module Protobuf
  module Descriptor
    class FileDescriptor
      class <<self
        def proto_type
          'Google::Protobuf::FileDescriptorProto'
        end

        def build(proto, opt={})
          mod = Object
          if package = proto.package and not package.empty?
            module_names = package.split '::'
            module_names.each do |module_name|
              mod = mod.const_set module_name, Module.new
            end
          end
          proto.message_type.each do |message_proto|
            Protobuf::Message.descriptor.build message_proto, :module => mod
          end
          proto.enum_type.each do |enum_proto|
            Protobuf::Enum.descriptor.build enum_proto, :module => mod
          end
        end

        def unbuild(messages)
          messages = [messages] unless messages.is_a? Array
          proto = Google::Protobuf::FileDescriptorProto.new
          proto.package = messages.first.to_s.split('::')[0..-2].join('::') if messages.first.to_s =~ /::/
          messages.each do |message|
            message.descriptor.unbuild proto
          end
          proto
        end
      end
    end
  end
end
