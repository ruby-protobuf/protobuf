##
# This file is auto-generated. DO NOT EDIT!
#
require 'protobuf/message'

##
# Imports
#
require 'google/protobuf/descriptor.pb'

module Google

  module Protobuf
  
    module Compiler
    
      ##
      # Message Classes
      #
      class CodeGeneratorRequest < ::Protobuf::Message; end
      class CodeGeneratorResponse < ::Protobuf::Message
        class File < ::Protobuf::Message; end
      end
      
      ##
      # Message Fields
      #
      class CodeGeneratorRequest
        repeated ::Protobuf::Field::StringField, :file_to_generate, 1
        optional ::Protobuf::Field::StringField, :parameter, 2
        repeated ::Google::Protobuf::FileDescriptorProto, :proto_file, 15
      end
      
      class CodeGeneratorResponse
        class File
          optional ::Protobuf::Field::StringField, :name, 1
          optional ::Protobuf::Field::StringField, :insertion_point, 2
          optional ::Protobuf::Field::StringField, :content, 15
        end
        
        optional ::Protobuf::Field::StringField, :error, 1
        repeated ::Google::Protobuf::Compiler::CodeGeneratorResponse::File, :file, 15
      end
      
      
    end
    
  end
  
end

