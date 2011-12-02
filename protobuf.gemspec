# -*- encoding: utf-8 -*-
$:.push File.expand_path("./lib", File.dirname(__FILE__))
require "protobuf/version"

Gem::Specification.new do |s|
  s.name          = 'protobuf'
  s.version       = Protobuf::VERSION
  s.date          = %q{2011-11-06}

  s.authors       = ['BJ Neilsen']
  s.email         = ["bj.neilsen@gmail.com"]
  s.homepage      = %q{https://github.com/localshred/protobuf}
  s.summary       = 'Ruby implementation for Protocol Buffers. Works with other protobuf rpc implementations (e.g. Java, Python, C++).'
  s.description   = s.summary + "\n\nThis gem has diverged from https://github.com/macks/ruby-protobuf. All credit for serialization and rprotoc work most certainly goes to the original authors. All RPC implementation code (client/server/service) was written and is maintained by this author. Attempts to reconcile the original codebase with the current RPC implementation went unsuccessful."
  
  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
  
  s.add_dependency 'eventmachine', '~> 0.12.10'
  s.add_dependency 'socketpool'
  
  s.add_development_dependency 'rake', '~> 0.8.7'
  s.add_development_dependency 'rspec', '~> 2.7.0'
end
