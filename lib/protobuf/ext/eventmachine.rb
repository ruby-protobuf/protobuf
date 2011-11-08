require 'fiber'

# Method and concept from em-synchrony
# https://github.com/igrigorik/em-synchrony
#
# A convenience method for wrapping EM.run body within
# a Ruby Fiber such that async operations can be transparently
# paused and resumed based on IO scheduling
module EventMachine
  def self.fiber_run(blk=nil, tail=nil, &block)
    blk ||= block
    context = Proc.new{ Fiber.new{ blk.call }.resume }

    self.run(context, tail)
  end
end
