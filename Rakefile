$:.push File.expand_path("./", File.dirname(__FILE__))
$:.push File.expand_path("./spec", File.dirname(__FILE__))

require "bundler/gem_tasks"
require "benchmark/tasks"

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'test:.'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end

require 'rspec/core/rake_task'

desc 'Default: run specs.'
task :default => :spec

desc "Run specs"
RSpec::Core::RakeTask.new(:spec)

## 
# Rake-compiler
#
require 'rake/extensiontask'

Rake::ExtensionTask.new("ruby_generator")
