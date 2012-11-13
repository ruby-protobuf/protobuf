$:.push File.expand_path("./", File.dirname(__FILE__))
$:.push File.expand_path("./spec", File.dirname(__FILE__))

require "rubygems"
require "rubygems/package_task"
require "bundler/gem_tasks"
# require "benchmark/tasks"

require "rspec/core/rake_task"

desc "Default: run specs."
task :default => :spec

desc "Run specs"
RSpec::Core::RakeTask.new(:spec)

##
# rake-compiler
#
spec = Gem::Specification.load("protobuf.gemspec")

Gem::PackageTask.new(spec) do |pkg|
end

if RUBY_PLATFORM =~ /java/
  require "rake/javaextensiontask"
else
  require "rake/extensiontask"
  Rake::ExtensionTask.new("ruby_generator", spec)
end
