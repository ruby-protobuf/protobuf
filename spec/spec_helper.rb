require 'simplecov'
SimpleCov.start

require 'timeout'
require 'rubygems'
require 'bundler'
Bundler.setup :default, :development, :test
require 'pry'

$: << ::File.expand_path('../..', __FILE__)
$: << ::File.expand_path('../support', __FILE__)

require 'protobuf'
require 'protobuf/rpc/server'
require ::File.expand_path('../support/all', __FILE__)

$: << ::File.expand_path("../../lib/protobuf/descriptors", __FILE__)
require 'google/protobuf/compiler/plugin.pb'

# Including a way to turn on debug logger for spec runs
if ENV.key?('DEBUG')
  debug_log = ::File.expand_path('../debug_specs.log', File.dirname(__FILE__) )
  ::Protobuf::Logger.configure(:file => debug_log, :level => ::Logger::DEBUG)
end

# Get rid of the deprecation env var if present (messes with specs).
ENV.delete("PB_IGNORE_DEPRECATIONS")

::RSpec.configure do |c|
  c.include(::Sander6::CustomMatchers)
  c.mock_with :rspec

  c.before(:suite) do
    unless ENV['NO_COMPILE_TEST_PROTOS']
      require 'rake'
      load ::File.expand_path('../../Rakefile', __FILE__)
      $stdout.puts 'Compiling test protos (use NO_COMPILE_TEST_PROTOS=1 to skip)'
      ::Rake::Task['compile:spec']
    end
  end
end

support_proto_glob = File.expand_path('../support/**/*.pb.rb', __FILE__)
Dir[support_proto_glob].each { |proto_file| require proto_file }

class ::Protobuf::Rpc::Client
  def ==(other)
    connector.options == other.options && \
      success_cb == other.success_cb && \
      failure_cb == other.failure_cb
  end
end

def reset_service_location(service)
  service.host = nil
  service.port = nil
end
