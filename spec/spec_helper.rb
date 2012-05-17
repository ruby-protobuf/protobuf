require 'simplecov'
SimpleCov.start

require 'rubygems'
require 'bundler'
Bundler.setup :default, :development, :test

$:.push File.expand_path('..', File.dirname(__FILE__))
$:.push File.expand_path('../lib', File.dirname(__FILE__))

require 'protobuf'
require 'protobuf/rpc/client'
require File.dirname(__FILE__) + '/helper/all'
require 'pry'

# Including a way to turn on debug logger for spec runs
if ENV["DEBUG"]
  debug_log = File.expand_path('../debug_specs.log', File.dirname(__FILE__) )
  Protobuf::Logger.configure(:file => debug_log, :level => ::Logger::DEBUG)
end

RSpec.configure do |c|
  c.include(SilentConstants)
  c.include(Sander6::CustomMatchers)
  c.mock_with :rspec
end

class ::Protobuf::Rpc::Client
  def == other
    connector.options == other.options && \
      success_cb == other.success_cb && \
      failure_cb == other.failure_cb
  end
end

def reset_service_location service
  service.instance_variable_set :@locations, nil
end
