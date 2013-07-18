$:.push File.expand_path("./", File.dirname(__FILE__))
$:.push File.expand_path("./spec", File.dirname(__FILE__))

require "rubygems"
require "rubygems/package_task"
require "bundler/gem_tasks"
# require "benchmark/tasks"

require "rspec/core/rake_task"

desc "Default: compile test protos and run specs."
task :default => [:compile_protos, :spec]

desc "Run specs"
RSpec::Core::RakeTask.new(:spec)

desc "Compile test protos"
task :compile_protos do
  unless defined?(JRUBY_VERSION)
    unless ENV['NO_COMPILE_TEST_PROTOS']
      $stdout.puts 'Compiling test protos (use NO_COMPILE_TEST_PROTOS=1 to skip)'
      proto_path = File.expand_path("../spec/support/", __FILE__)
      cmd = "rprotoc --proto_path=#{proto_path} --ruby_out=#{proto_path} #{File.join(proto_path, '**', '*.proto')}"
      puts cmd
      %x{#{cmd}}
    end
  end
end

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
end
