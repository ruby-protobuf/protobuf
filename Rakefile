$LOAD_PATH << ::File.expand_path('../', __FILE__)
$LOAD_PATH << ::File.expand_path('../spec', __FILE__)

require 'fileutils'
require 'rubygems'
require 'rubygems/package_task'
require 'bundler/gem_tasks'
require 'benchmark/tasks'

require 'rspec/core/rake_task'
require 'rubocop/rake_task'

RSpec::Core::RakeTask.new(:spec)
RuboCop::RakeTask.new

task :default => ['compile:spec', 'compile:descriptors', :spec, :rubocop]

desc 'Run both the spec and descriptors compilation tasks'
task :compile => ['compile:spec', 'compile:descriptors']

desc 'Run specs'
namespace :compile do

  desc 'Compile spec protos in spec/supprt/ directory'
  task :spec do
    source = ::File.expand_path('../spec/support/', __FILE__)
    input_files = ::File.join(source, '**', '*.proto')
    destination = source

    command = []
    command << "PB_NO_TAG_WARNINGS=1"
    command << "protoc --plugin=./bin/protoc-gen-ruby"
    command << "--ruby_out=#{destination}"
    command << "-I #{source}"
    command << Dir[input_files].join(' ')
    command = command.join(' ')

    puts command
    system(command)
  end

  desc 'Compile rpc protos in protos/ directory'
  task :descriptors do
    source      = ::File.expand_path('../proto', __FILE__)
    input_files = ::File.join(source, '**', '*.proto')
    destination = ::File.expand_path('../tmp/rpc', __FILE__)
    ::FileUtils.mkdir_p(destination)

    command = []
    command << "PB_NO_TAG_WARNINGS=1"
    command << "protoc --plugin=./bin/protoc-gen-ruby"
    command << "--ruby_out=#{destination}"
    command << "-I #{source}"
    command << Dir[input_files].join(' ')
    command = command.join(' ')

    puts command
    system(command)

    files = {
      'tmp/rpc/dynamic_discovery.pb.rb'               => 'lib/protobuf/rpc',
      'tmp/rpc/rpc.pb.rb'                             => 'lib/protobuf/rpc',
      'tmp/rpc/google/protobuf/descriptor.pb.rb'      => 'lib/protobuf/descriptors/google/protobuf',
      'tmp/rpc/google/protobuf/compiler/plugin.pb.rb' => 'lib/protobuf/descriptors/google/protobuf/compiler',
    }

    files.each_pair do |source_file, destination_dir|
      source_file     = ::File.expand_path("../#{source_file}", __FILE__)
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
