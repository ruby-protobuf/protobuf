require "protobuf"

require_relative "reverse.pb.rb"

# Protobuf::Logger.configure :level => Protobuf::Logger::DEBUG, :file => "./log/protobuf-client.log"

configuration = {
  :host => "localhost",
  :port => 9399
}

request = {
  :input => (ARGV[0] or 'hello world')
}

Example::ReverseService.client(configuration).reverse(Example::ReverseRequest.new(request)) do |client|
  client.on_success do |response|
    puts response.reversed
  end
  client.on_failure do |error|
    puts 'It failed: ' + error.message
  end
end
