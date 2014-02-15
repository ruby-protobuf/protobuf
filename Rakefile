$: << ::File.expand_path('../', __FILE__)
$: << ::File.expand_path('../spec', __FILE__)

require 'fileutils'
require 'rubygems'
require 'rubygems/package_task'
require 'bundler/gem_tasks'
require 'benchmark/tasks'

require 'rspec/core/rake_task'

desc 'Default: run specs.'
task :default => :spec

RSpec::Core::RakeTask.new(:spec)

desc 'Run specs'
namespace :compile do

  desc 'Compile spec protos in spec/supprt/'
  task :spec do |task, args|
    proto_path = ::File.expand_path('../spec/support/', __FILE__)
    cmd = %Q{protoc --plugin=./bin/protoc-gen-ruby --ruby_out=#{proto_path} -I #{proto_path} #{File.join(proto_path, '**', '*.proto')}}
    puts cmd
    exec cmd
  end

  desc "Compile spec protos in spec/supprt/"
  task :rpc do |task, args|
    proto_path = ::File.expand_path('../proto', __FILE__)
    output_dir = ::File.expand_path('../tmp/rpc', __FILE__)
    ::FileUtils.mkdir_p(output_dir)

    cmd = %Q{protoc --plugin=./bin/protoc-gen-ruby --ruby_out=#{output_dir} -I #{proto_path} #{File.join(proto_path, '**', '*.proto')}}

    puts cmd
    puts %x(#{cmd})

    files = {
      'tmp/rpc/dynamic_discovery.pb.rb'               => 'lib/protobuf/rpc',
      'tmp/rpc/rpc.pb.rb'                             => 'lib/protobuf/rpc',
      'tmp/rpc/google/protobuf/descriptor.pb.rb'      => 'lib/protobuf/descriptors/google/protobuf',
      'tmp/rpc/google/protobuf/compiler/plugin.pb.rb' => 'lib/protobuf/descriptors/google/protobuf/compiler'
    }

    files.each_pair do |source_file, destination_dir|
      source_file = ::File.expand_path("../#{source_file}", __FILE__)
      destination_dir = ::File.expand_path("../#{destination_dir}", __FILE__)
      ::FileUtils::Verbose.cp(source_file, destination_dir)
    end
  end

end

task :console do
  require 'pry'
  require 'protobuf'
  ARGV.clear
  ::Pry.start
end
