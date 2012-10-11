require 'simplecov'
SimpleCov.start

require 'rubygems'
require 'bundler'
Bundler.setup :default, :development, :test
require 'pry'

$: << ::File.expand_path('..', File.dirname(__FILE__))
#$: << ::File.expand_path('../lib', File.dirname(__FILE__))

require 'protobuf'
require ::File.dirname(__FILE__) + '/support/all'

# Including a way to turn on debug logger for spec runs
if ENV["DEBUG"]
  debug_log = ::File.expand_path('../debug_specs.log', File.dirname(__FILE__) )
  ::Protobuf::Logger.configure(:file => debug_log, :level => ::Logger::DEBUG)
end

::RSpec.configure do |c|
  c.include(::Sander6::CustomMatchers)
  c.mock_with :rspec

  c.before(:suite) do
    unless ENV['NO_COMPILE_TEST_PROTOS']
      $stdout.puts 'Compiling test protos (use NO_COMPILE_TEST_PROTOS=1 to skip)'
      proto_path = File.expand_path("../support/", __FILE__)
      %x{ rprotoc --proto_path=#{proto_path} --ruby_out=#{proto_path} #{File.join(proto_path, '**', '*.proto')} }
    end
  end
end

Dir[File.expand_path('../support/**/*.pb.rb', __FILE__)].each do |proto_file|
  require proto_file
end

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
