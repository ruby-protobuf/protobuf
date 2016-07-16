run lambda { |env|
  request = ::Protobuf::Rpc::HTTPRequest.new(env)
  request.handle
}
