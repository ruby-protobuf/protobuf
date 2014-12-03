require 'timeout'
require 'rubygems'
require 'bundler'
Bundler.setup :default, :development, :test
require 'pry'

$LOAD_PATH << ::File.expand_path('../..', __FILE__)
$LOAD_PATH << ::File.expand_path('../support', __FILE__)

require 'protobuf'
require 'protobuf/rpc/server'
require ::File.expand_path('../support/all', __FILE__)

$LOAD_PATH << ::File.expand_path("../../lib/protobuf/descriptors", __FILE__)
require 'google/protobuf/compiler/plugin.pb'

# Including a way to turn on debug logger for spec runs
if ENV.key?('DEBUG')
  debug_log = ::File.expand_path('../../debug_specs.log', __FILE__)
  ::Protobuf::Logging.initialize_logger(debug_log, ::Logger::DEBUG)
else
  ::Protobuf::Logging.initialize_logger('/dev/null')
end

# Get rid of the deprecation env var if present (messes with specs).
ENV.delete("PB_IGNORE_DEPRECATIONS")

support_proto_glob = File.expand_path('../support/**/*.pb.rb', __FILE__)
Dir[support_proto_glob].each { |proto_file| require proto_file }

RSpec.configure(&:disable_monkey_patching!)

::Protobuf::Rpc::Client.class_eval do
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
