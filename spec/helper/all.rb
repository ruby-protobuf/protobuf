require 'rubygems'
require 'rspec'

require 'helper/tolerance_matcher'
require 'helper/server'

def now
  Time.new.to_f
end

RSpec.configure do |con|
  con.include(Sander6::CustomMatchers)
end
