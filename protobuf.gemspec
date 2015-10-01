# encoding: UTF-8
$LOAD_PATH.push ::File.expand_path("../lib", __FILE__)
require "protobuf/version"

::Gem::Specification.new do |s|
  s.name          = 'protobuf'
  s.version       = ::Protobuf::VERSION
  s.date          = ::Time.now.strftime('%Y-%m-%d')
  s.license       = 'MIT'

  s.authors       = ['BJ Neilsen', 'Brandon Dewitt', 'Devin Christensen', 'Adam Hutchison']
  s.email         = ['bj.neilsen+protobuf@gmail.com', 'brandonsdewitt+protobuf@gmail.com', 'quixoten@gmail.com', 'liveh2o@gmail.com']
  s.homepage      = 'https://github.com/localshred/protobuf'
  s.summary       = "Google Protocol Buffers serialization and RPC implementation for Ruby."
  s.description   = s.summary

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map { |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency 'activesupport', '>= 3.2'
  s.add_dependency 'middleware'
  s.add_dependency 'thor'
  s.add_dependency 'thread_safe'

  s.add_development_dependency 'ffi-rzmq'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'rspec', '>= 3.0'
  s.add_development_dependency 'rubocop', '0.34.2'
  s.add_development_dependency 'simplecov'
  s.add_development_dependency 'timecop'
  s.add_development_dependency 'yard'

  # debuggers only work in MRI
  if RUBY_ENGINE.to_sym == :ruby
    # we don't support MRI < 1.9.3
    pry_debugger = if RUBY_VERSION < '2.0.0'
                     'pry-debugger'
                   else
                     'pry-byebug'
                   end

    s.add_development_dependency pry_debugger
    s.add_development_dependency 'pry-stack_explorer'

    s.add_development_dependency 'varint'
    s.add_development_dependency 'ruby-prof'
  else
    s.add_development_dependency 'pry'
  end
end
