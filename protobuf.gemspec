# encoding: UTF-8
$:.push File.expand_path("./lib", File.dirname(__FILE__))
require "protobuf/version"

Gem::Specification.new do |s|
  s.name          = 'protobuf'
  s.version       = Protobuf::VERSION
  s.date          = Time.now.strftime('%Y-%m-%d')

  s.authors       = ['BJ Neilsen', 'Brandon Dewitt']
  s.email         = ["bj.neilsen+protobuf@gmail.com", "brandonsdewitt+protobuf@gmail.com"]
  s.homepage      = "https://github.com/localshred/protobuf"
  s.summary       = "Google Protocol Buffers v#{Protobuf::PROTOC_VERSION} Serialization and RPC implementation for Ruby."
  s.description   = s.summary

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  unless ENV['WITHOUT_PROTO_COMPILER']
    s.extensions << File.join('ext', 'ruby_generator', 'extconf.rb')
  end

  s.add_dependency 'activesupport'
  s.add_dependency 'ffi'
  s.add_dependency 'multi_json'
  s.add_dependency 'thor'

  s.add_development_dependency 'eventmachine'
  s.add_development_dependency 'ffi-rzmq'
  s.add_development_dependency 'perftools.rb'
  s.add_development_dependency 'pry'
  s.add_development_dependency 'pry-nav'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'rake-compiler'
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'simplecov'
  s.add_development_dependency 'yard'
end
