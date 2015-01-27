require 'pry'

$LOAD_PATH << ::File.expand_path('../support', __FILE__)

require 'protobuf'

# Get rid of the deprecation env var if present (messes with specs).
ENV.delete("PB_IGNORE_DEPRECATIONS")

support_proto_glob = File.expand_path('../support/**/*.pb.rb', __FILE__)
Dir[support_proto_glob].each { |proto_file| require proto_file }

RSpec.configure(&:disable_monkey_patching!)
