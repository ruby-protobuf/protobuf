require 'erb'
require 'fileutils'
require 'protobuf/descriptor/descriptor_proto'

module Protobuf
  module Visitor
    class Base
      attr_reader :silent

      def create_file_with_backup(filename, contents, executable=false)
        if File.exist?(filename)
          if File.read(filename) == contents
            # do nothing
            return
          else
            backup_filename = "#{filename}.#{Time.now.to_i}"
            log_writing("#{backup_filename}", "backingup...")
            FileUtils.copy(filename, backup_filename)
          end
        end

        FileUtils.mkpath(File.dirname(filename))
        File.open(filename, 'w') do |file|
          log_writing(filename)
          file.write(contents)
        end
        FileUtils.chmod(0755, filename) if executable
      end

      def log_writing(filename, message="wrote")
        puts "#{message} #{filename}" unless silent
      end
    end

    class CreateMessageVisitor < Base
      attr_accessor :package, :indent, :context, :attach_proto, :proto_file

      def initialize(proto_file=nil, proto_dir='.', out_dir='.')
        @proto_dir, @out_dir = proto_dir, out_dir
        @indent = 0
        @context = []
        @attach_proto = true
        @proto_file = proto_file
      end

      def attach_proto?
        @attach_proto
      end

      def commented_proto_contents
        if proto_file
          proto_filepath = if File.exist?(proto_file)
                           then proto_file
                           else "#{@proto_dir}/#{proto_file}"
                           end
          File.read(proto_filepath).gsub(/^/, '# ')
        end
      end

      def write(str)
        ruby << "#{'  ' * @indent}#{str}"
      end

      def increment
        @indent += 1
      end

      def decrement
        @indent -= 1
      end

      def close_ruby
        while 0 < indent
          decrement
          write('end')
        end
      end

      def ruby
        @ruby ||= []
      end

      def to_s
        @ruby.join("\n")
      end

      def in_context(klass, &block)
        increment
        context.push klass
        block.call
        context.pop
        decrement
      end

      def visit(node)
        node.accept_message_visitor(self)
        self
      end

      def required_message_from_proto(proto_file)
        rb_path = [
          proto_file.sub(/\.proto\z/, '.pb.rb')
        ].join('/').gsub(/\/{2,}/, '/')
        
        unless File.exist?(rb_path)
          Compiler.compile(proto_file, @proto_dir, @out_dir)
        end
        
        rb_path.sub(/\.rb$/, '')
      end

      def create_files(filename, out_dir, file_create)
        $: << File.expand_path(out_dir)
        Class.new.class_eval(to_s) # check the message
        $:.delete File.expand_path(out_dir)
      rescue LoadError
        puts "Error creating file #{filename}"
        puts $!.message
        exit 1
      else 
        
        file = File.basename(filename)
        filename = if package
                     File.join out_dir, Util.module_to_path(package.map{|p| p.to_s.capitalize}.join('::')), file
                   else
                     File.join out_dir, file
                   end
        
        if file_create
          log_writing(filename)
          FileUtils.mkpath(File.dirname(filename))
          File.open(filename, 'w') {|file| file.write(to_s) }
        else
          to_s
        end
      end
    end

    class CreateRpcVisitor < Base
      attr_accessor :package, :services, :current_service, :file_contents

      def initialize
        @services = {}
        @create_file = true
        @file_contents = {}
      end

      def visit(node)
        node.accept_rpc_visitor(self)
        self
      end

      def add_rpc(name, request, response)
        (@services[@current_service] ||= []) << [name, Util.moduleize(request), Util.moduleize(response)]
      end

      def create_files(message_file, out_dir, create_file=true)
        @create_file = create_file
        default_port = 9999
        @services.each do |service_name, rpcs|
          underscored_name = underscore service_name.to_s
          message_module = package.map{|p| p.to_s.capitalize}.join('::')
          required_file = [
            Util.module_to_path(message_module),
            File.basename(message_file.sub(/^\.\//, '').sub(/\.rb$/, ''))
          ].join('/').gsub(/\/{2,}/, '/')

          create_service(message_file, out_dir, underscored_name, message_module, service_name, default_port, rpcs, required_file)
        end
        @file_contents
      end

      def create_service(message_file, out_dir, underscored_name, module_name, service_name, default_port, rpcs, required_file)
        service_filename = "#{out_dir}/#{Util.module_to_path(module_name)}/#{underscored_name}.rb"
        service_contents = template_erb('rpc_service_implementation').result(binding)
        create_file_with_backup(service_filename, service_contents) if @create_file
        @file_contents[service_filename] = service_contents
      end

      private

      def underscore(str)
        str.to_s.gsub(/\B[A-Z]/, '_\&').downcase
      end

      def template_erb(template)
        ERB.new(File.read("#{File.dirname(__FILE__)}/template/#{template}.erb"), nil, '-')
      end
    end

    class CreateDescriptorVisitor < Base
      attr_reader :file_descriptor
      attr_accessor :filename

      def initialize(filename=nil)
        @context = []
        @filename = filename
      end

      def visit(node)
        node.accept_descriptor_visitor(self)
        self
      end

      def in_context(descriptor, &block)
        @context.push descriptor
        block.call
        @context.pop
      end

      def current_descriptor
        @context.last
      end

      def file_descriptor=(descriptor)
       @file_descriptor = descriptor
       @file_descriptor.name = @filename
      end

      def add_option(name, value)
        options =
          case current_descriptor
          when Google::Protobuf::FileDescriptorProto then
            Google::Protobuf::FileOptions.new
          when Google::Protobuf::DescriptorProto then
            Google::Protobuf::MessageOptions.new
          when Google::Protobuf::FieldDescriptorProto then
            Google::Protobuf::FieldOptions.new
          when Google::Protobuf::EnumDescriptorProto then
            Google::Protobuf::EnumOptions.new
          when Google::Protobuf::EnumValueDescriptorProto then
            Google::Protobuf::EnumValueOptions.new
          when Google::Protobuf::ServiceDescriptorProto then
            Google::Protobuf::ServiceOptions.new
          when Google::Protobuf::MethodDescriptorProto then
            Google::Protobuf::MethodOptions.new
          else
            raise ArgumentError, 'Invalid context'
          end
        #TODO how should options be handled?
        #current_descriptor.options << option
      end

      def descriptor=(descriptor)
        case current_descriptor
        when Google::Protobuf::FileDescriptorProto then
          current_descriptor.message_type << descriptor
        when Google::Protobuf::DescriptorProto then
          current_descriptor.nested_type << descriptor
        else
          raise ArgumentError, 'Invalid context'
        end
      end
      alias message_descriptor= descriptor=

      def enum_descriptor=(descriptor)
        current_descriptor.enum_type << descriptor
      end

      def enum_value_descriptor=(descriptor)
        current_descriptor.value << descriptor
      end

      def service_descriptor=(descriptor)
        current_descriptor.service << descriptor
      end

      def method_descriptor=(descriptor)
        current_descriptor.method << descriptor
      end

      def field_descriptor=(descriptor)
        case current_descriptor
        when Google::Protobuf::FileDescriptorProto then
          current_descriptor.extension << descriptor
        when Google::Protobuf::DescriptorProto then
          current_descriptor.field << descriptor
          #TODO: how should i distiguish between field and extension
          #current_descriptor.extension << descriptor
        else
          raise ArgumentError, 'Invalid context'
        end
      end

      def extension_range_descriptor=(descriptor)
        current_descriptor.extension_range << descriptor
      end
    end
  end
end
