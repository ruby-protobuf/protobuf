$: << ::File.expand_path('../', __FILE__)
$: << ::File.expand_path('../spec', __FILE__)

require "rubygems"
require "rubygems/package_task"
require "bundler/gem_tasks"
# require "benchmark/tasks"

require "rspec/core/rake_task"

desc "Default: run specs."
task :default => :spec

desc "Run specs"
::RSpec::Core::RakeTask.new(:spec)

namespace :spec do
  desc "Compile Test Protos in spec/supprt/"
  task :compile_test_protos do |task, args|
    proto_path = ::File.expand_path('../spec/support/', __FILE__)
    cmd = %Q{protoc --plugin=./bin/protoc-gen-ruby --ruby_out=#{proto_path} -I #{proto_path} #{File.join(proto_path, '**', '*.proto')}}
    puts cmd
    exec cmd
  end
end
