require 'rubygems'
require 'bundler'
Bundler.setup :default, :development, :test

RSpec.configure do |c|
  c.mock_with :rspec
end

$:.push File.expand_path('..', File.dirname(__FILE__))
$:.push File.expand_path('../lib', File.dirname(__FILE__))
require 'protobuf'

require 'protobuf/rpc/client'
class ::Protobuf::Rpc::Client
  def == other
   options == other.options && \
   error == other.error && \
   do_block == other.do_block && \
   @success_callback == other.instance_variable_get(:@success_callback) && \
   @failure_callback == other.instance_variable_get(:@failure_callback)
  end
end

def reset_service_location service
  service.instance_variable_set :@locations, nil
end