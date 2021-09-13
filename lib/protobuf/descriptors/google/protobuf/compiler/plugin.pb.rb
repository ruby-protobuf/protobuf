# encoding: utf-8

##
# This file is auto-generated. DO NOT EDIT!
#
require 'protobuf'


##
# Imports
#
require 'google/protobuf/descriptor.pb'

module Google
  module Protobuf
    module Compiler
      ::Protobuf::Optionable.inject(self) { ::Google::Protobuf::FileOptions }

      ##
      # Message Classes
      #
      class Version < ::Protobuf::Message; end
      class CodeGeneratorRequest < ::Protobuf::Message; end
      class CodeGeneratorResponse < ::Protobuf::Message
        class Feature < ::Protobuf::Enum
          define :FEATURE_NONE, 0
          define :FEATURE_PROTO3_OPTIONAL, 1
        end

        class File < ::Protobuf::Message; end

      end



      ##
      # File Options
      #
      set_option :java_package, "com.google.protobuf.compiler"
      set_option :java_outer_classname, "PluginProtos"
      set_option :go_package, "google.golang.org/protobuf/types/pluginpb"


      ##
      # Message Fields
      #
      class Version
        optional :int32, :major, 1
        optional :int32, :minor, 2
        optional :int32, :patch, 3
        optional :string, :suffix, 4
      end

      class CodeGeneratorRequest
        repeated :string, :file_to_generate, 1
        optional :string, :parameter, 2
        repeated ::Google::Protobuf::FileDescriptorProto, :proto_file, 15
        optional ::Google::Protobuf::Compiler::Version, :compiler_version, 3
      end

      class CodeGeneratorResponse
        class File
          optional :string, :name, 1
          optional :string, :insertion_point, 2
          optional :string, :content, 15
          optional ::Google::Protobuf::GeneratedCodeInfo, :generated_code_info, 16
        end

        optional :string, :error, 1
        optional :uint64, :supported_features, 2
        repeated ::Google::Protobuf::Compiler::CodeGeneratorResponse::File, :file, 15
      end

    end

  end

end

