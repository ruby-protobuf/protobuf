$: << ::File.expand_path('../', __FILE__)
$: << ::File.expand_path('../spec', __FILE__)

require "rubygems"
require "rubygems/package_task"
require "bundler/gem_tasks"
require "benchmark/tasks"

require "rspec/core/rake_task"

desc "Default: run specs."
task :default => :spec

desc "Run specs"
RSpec::Core::RakeTask.new(:spec)

task :console do
  require 'pry'
  require 'protobuf'
  ARGV.clear
  ::Pry.start
end
