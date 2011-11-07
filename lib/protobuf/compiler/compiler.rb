require 'fileutils'
require 'protobuf/compiler/proto_parser'
require 'protobuf/compiler/nodes'
require 'protobuf/compiler/visitors'

module Protobuf
  class Compiler
    def self.compile(proto_file, proto_dir='.', out_dir='.', file_create=true)
      self.new.compile(proto_file, proto_dir, out_dir, file_create)
    end

    def compile(proto_file, proto_dir='.', out_dir='.', file_create=true)
      create_message(proto_file, proto_dir, out_dir, file_create)
      create_rpc(proto_file, proto_dir, out_dir, file_create)
    end

    def create_message(proto_file, proto_dir='.', out_dir='.', file_create=true)
      rb_file = File.join(out_dir, File.basename(proto_file).sub(/\.[^\0]*\z/, '') + '.pb.rb')
      proto_path = validate_existence(proto_file, proto_dir)

      message_visitor = Visitor::CreateMessageVisitor.new(proto_file, proto_dir, out_dir)
      File.open(proto_path) do |file|
        message_visitor.visit(ProtoParser.new.parse(file))
      end
      message_visitor.create_files(rb_file, out_dir, file_create)
    end

    def create_rpc(proto_file, proto_dir='.', out_dir='.', file_create=true)
      message_file = File.join(out_dir, File.basename(proto_file).sub(/\.[^\0]*\z/, '') + '.pb.rb')
      proto_path = validate_existence(proto_file, proto_dir)

      rpc_visitor = Visitor::CreateRpcVisitor.new
      File.open(proto_path) do |file|
        rpc_visitor.visit(ProtoParser.new.parse(file))
      end
      rpc_visitor.create_files(message_file, out_dir, file_create)
    end

    def validate_existence(path, base_dir)
      if File.exist?(path)
        path
      else
        newpath = File.join(base_dir, path)
        if File.exist?(newpath)
          newpath
        else
          raise ArgumentError, "File does not exist: #{path}"
        end
      end
    end
  end
end
