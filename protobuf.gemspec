# encoding: UTF-8
$:.push ::File.expand_path("../lib", __FILE__)
require "protobuf/version"

::Gem::Specification.new do |s|
  s.name          = 'protobuf'
  s.version       = ::Protobuf::VERSION
  s.date          = ::Time.now.strftime('%Y-%m-%d')
  s.license       = 'WTFPL'

  s.authors       = ['BJ Neilsen', 'Brandon Dewitt', 'Devin Christensen']
  s.email         = ['bj.neilsen+protobuf@gmail.com', 'brandonsdewitt+protobuf@gmail.com', 'quixoten@gmail.com']
  s.homepage      = 'https://github.com/localshred/protobuf'
  s.summary       = "Google Protocol Buffers serialization and RPC implementation for Ruby."
  s.description   = s.summary

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map { |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency 'activesupport', '~> 4.0'
  s.add_dependency 'multi_json', '~> 1.8'
  s.add_dependency 'thor', '~> 0.18'

  s.add_development_dependency 'ffi-rzmq', '~> 1.0'
  s.add_development_dependency 'pry-nav', '~> 0.2'
  s.add_development_dependency 'rake', '~> 10.1'
  s.add_development_dependency 'rspec', '~> 2.14'
  s.add_development_dependency 'simplecov', '~> 0.8'
  s.add_development_dependency 'yard', '~> 0.8'
  s.add_development_dependency 'timecop', '~> 0.6'
  s.add_development_dependency 'perftools.rb', '~> 2.0'
end
