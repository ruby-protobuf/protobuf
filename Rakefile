require 'protobuf/tasks'

require 'bundler/gem_tasks'

require 'rspec/core/rake_task'
require 'rubocop/rake_task'

RSpec::Core::RakeTask.new(:spec)
RuboCop::RakeTask.new

task :default => ['compile:spec', :spec, :rubocop]

desc 'compile protos'
namespace :compile do
  desc 'Compile spec protos in spec/supprt/ directory'
  task :spec do
    proto_path = ::File.expand_path('../spec/support/', __FILE__)
    proto_files = Dir[File.join(proto_path, '**', '*.proto')]
    cmd = %(protoc --plugin=./bin/protoc-gen-ruby --ruby_out=#{proto_path} -I #{proto_path} #{proto_files.join(' ')})

    puts cmd
    system(cmd)
  end
end

task :console do
  require 'pry'
  require 'protobuf'
  ARGV.clear
  ::Pry.start
end
